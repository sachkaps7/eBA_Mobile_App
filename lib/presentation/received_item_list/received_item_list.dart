// ignore_for_file: unrelated_type_equality_checks

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/received_items_response.dart';
import 'package:eyvo_inventory/api/response_models/update_good_receive_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/constants.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/alert.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
import 'package:eyvo_inventory/core/widgets/custom_checkbox.dart';
import 'package:eyvo_inventory/core/widgets/custom_list_tile.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:eyvo_inventory/presentation/pdf_view/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReceivedItemListView extends StatefulWidget {
  final String orderNumber;
  final int orderId;
  const ReceivedItemListView(
      {super.key, required this.orderNumber, required this.orderId});

  @override
  State<ReceivedItemListView> createState() => _ReceivedItemListViewState();
}

class _ReceivedItemListViewState extends State<ReceivedItemListView>
    with RouteAware {
  final TextEditingController editQuantityController = TextEditingController();
  bool isPrintEnabled = false;
  String searchText = '';
  late List<OrderData> orderItems = [];
  late List selectedOrderItems = [];
  bool isGoodsReceived = false;
  bool isGenerateLabelEnabled = false;
  String receivedGoodsSuccessMessage = '';
  String receivedGoodsNumber = '';
  bool isAllSelected = false;
  bool isReceiveGoodsEnabled = false;
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  final ApiService apiService = ApiService();
  bool isEditingQuantity = false;
  final Duration duration = const Duration(milliseconds: 300);
  final double editBoxHeight = 350;
  late double maxQuantity;
  int selectedIndex = 0;
  bool isReject = false;
  final TextEditingController _commentsController = TextEditingController();
  int maxChars = AppConstants.maxCharactersForComment;
  String? selectedRejectReason = 'Broken'; // Default value
  String? selectedAction = 'Replace Item'; // Default value
  String? errorMessage;
  Map<int, Map<String, String>> uploadedImages = {};
  Map<int, Map<String, dynamic>> rejectDataMap = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    fetchOrderItems();
  }

  @override
  void initState() {
    super.initState();
    fetchOrderItems();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    editQuantityController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  bool hasRejectData(int orderLineId) {
    return rejectDataMap.containsKey(orderLineId);
  }

  void fetchOrderItems() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'orderid': widget.orderId.toString(),
    };
    final jsonResponse = await apiService.postRequest(
        context, ApiService.goodReceiveItemList, data);
    if (jsonResponse != null) {
      final response = ReceivedItemsResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          orderItems = response.data;
          isPrintEnabled = response.print;
        });
      } else {
        isError = true;
        errorText = response.message.join(', ');
        isPrintEnabled = response.print;
      }
    }

    // var res =
    //     await globalBloc.doFetchOrderItem(context, widget.orderId.toString());
    // if (res.code == '200') {
    //   setState(() {
    //     orderItems = res.data;
    //     isPrintEnabled = res.print;
    //   });
    // } else {
    //   isError = true;
    //   errorText = res.message.join(', ');
    //   isPrintEnabled = res.print;
    // }

    setState(() {
      isLoading = false;
    });
  }

  void didTappedOnSelectAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      for (var item in orderItems) {
        item.isSelected = isAllSelected;
      }
      checkIsAnyItemSelected();
    });
  }

  void editReceivedQuantity(BuildContext context, double bookInQuantity,
      double totalQuantity, int editingIndex, bool isRejectMode) {
    setState(() {
      isEditingQuantity = true;
      maxQuantity = bookInQuantity;
      editQuantityController.text = getFormattedString(bookInQuantity);
      selectedIndex = editingIndex;
      isReject = isRejectMode;

      // Initialize reject data if in reject mode
      if (isRejectMode) {
        final orderLineId = orderItems[selectedIndex].orderLineId;
        if (!rejectDataMap.containsKey(orderLineId)) {
          rejectDataMap[orderLineId] = {
            'rejectQuantity': bookInQuantity,
            'rejectReason': 'Broken',
            'creditReplace': 'Replace Item',
            'notes': '',
          };
        } else {
          // Update the quantity if already exists
          rejectDataMap[orderLineId]!['rejectQuantity'] = bookInQuantity;
        }
      }
    });
  }

  void updateReceivedQuantity() {
    var updatedQuantityString = '';
    var updatedQuantity = 0.0;

    if (editQuantityController.text.isNotEmpty) {
      updatedQuantityString =
          getFormattedString(double.parse(editQuantityController.text));
      updatedQuantity = double.parse(updatedQuantityString);
    }

    if (updatedQuantity <= 0) {
      showErrorDialog(context, AppStrings.quantityNotValid, false);
    } else {
      setState(() {
        isEditingQuantity = false;
        final orderLineId = orderItems[selectedIndex].orderLineId;

        if (isReject) {
          // Store reject data in the map - updatedQuantity goes to rejectquantity
          rejectDataMap[orderLineId] = {
            'rejectQuantity':
                updatedQuantity, // Use the updatedQuantity for reject
            'rejectReason': selectedRejectReason,
            'creditReplace': selectedAction,
            'notes': _commentsController.text,
          };

          // For reject items: received quantity = 0, reject quantity = updatedQuantity
          orderItems[selectedIndex].updatedQuantity =
              0.0; // This goes to receivedquantity in API
        } else {
          // For accept mode: received quantity = updatedQuantity, no reject data
          orderItems[selectedIndex].updatedQuantity =
              updatedQuantity; // This goes to receivedquantity in API
          rejectDataMap.remove(orderLineId); // Remove reject data if accepting
        }

        // Mark as edited if quantity changed from original received quantity
        if (orderItems[selectedIndex].receivedQuantity !=
            orderItems[selectedIndex].updatedQuantity) {
          orderItems[selectedIndex].isEdited = true;
        } else {
          orderItems[selectedIndex].isEdited = false;
        }

        orderItems[selectedIndex].isSelected = true;
        checkIsAnyItemSelected();

        // RESET DROPDOWN VALUES
        selectedRejectReason = 'Broken';
        selectedAction = 'Replace Item';
        // Clear controllers
        _commentsController.clear();
        errorMessage = null;
      });
    }
  }

  void updateQuantity(double updatedQuantity) {
    editQuantityController.text = getFormattedString(updatedQuantity);
  }

  void increaseReceivedQuantity() {
    var updatedQuantity = double.parse(editQuantityController.text) + 1.0;
    if (updatedQuantity <= orderItems[selectedIndex].bookInQuantity) {
      updateQuantity(updatedQuantity);
    }
  }

  void decreaseReceivedQuantity() {
    var updatedQuantity = double.parse(editQuantityController.text) - 1.0;
    if (updatedQuantity > 0) {
      updateQuantity(updatedQuantity);
    }
  }

  // void receiveGoods() {
  //   if (isReceiveGoodsEnabled) {
  //     selectedOrderItems = [];
  //     for (var item in orderItems) {
  //       if (item.isSelected) {
  //         Map<String, dynamic> data = {
  //           "orderlineid": item.orderLineId,
  //           "itemorder": item.itemOrder,
  //           "receivedquantity": item.updatedQuantity,
  //           "itemtype": item.itemType,
  //           "isstock": item.isStock,
  //           "isupdated": true
  //         };
  //         selectedOrderItems.add(data);
  //       }
  //     }
  //     showReceiveGoodsDialog(context);
  //   }
  // }
  // void receiveGoods() {
  //   if (isReceiveGoodsEnabled) {
  //     selectedOrderItems = [];
  //     for (var item in orderItems) {
  //       if (item.isSelected) {
  //         Map<String, dynamic> data = {
  //           "orderlineid": item.orderLineId,
  //           "itemorder": item.itemOrder,
  //           "receivedquantity": item.updatedQuantity,
  //           "itemtype": item.itemType,
  //           "isstock": item.isStock,
  //           "isupdated": true,
  //           "Document_FileName": "", // default empty
  //           // "Document_File": "", // default empty
  //           "Document_FileNameAzure": "",
  //         };

  //         // uploaded image data
  //         final imageData = uploadedImages[item.orderLineId];
  //         if (imageData != null) {
  //           data["Document_FileName"] = imageData["fileName"];
  //           //   data["Document_File"] = imageData["base64"];
  //           data["Document_FileNameAzure"] = imageData["azureImageName"];
  //         }

  //         selectedOrderItems.add(data);
  //       }
  //     }

  //     showReceiveGoodsDialog(context);
  //   }
  // }
  void receiveGoods() {
    if (isReceiveGoodsEnabled) {
      selectedOrderItems = [];
      for (var item in orderItems) {
        if (item.isSelected) {
          Map<String, dynamic> data = {
            "orderlineid": item.orderLineId,
            "itemorder": item.itemOrder,
            "receivedquantity": item.updatedQuantity,
            "itemtype": item.itemType,
            "isstock": item.isStock,
            "isupdated": true,
            "Document_FileName": "",
            "Document_FileNameAzure": "",
          };

          // Check if this item has reject data
          final rejectData = rejectDataMap[item.orderLineId];
          if (rejectData != null) {
            // Add reject data to the payload
            data["rejectquantity"] = rejectData['rejectQuantity'];
            data["rejectreason"] = rejectData['rejectReason'];
            data["creditReplace"] = rejectData['creditReplace'];
            data["notes"] = rejectData['notes'];
          }

          // uploaded image data
          final imageData = uploadedImages[item.orderLineId];
          if (imageData != null) {
            data["Document_FileName"] = imageData["fileName"];
            data["Document_FileNameAzure"] = imageData["azureImageName"];
          }

          selectedOrderItems.add(data);
        }
      }

      showReceiveGoodsDialog(context);
    }
  }

  void onConfirmReceiveGoods() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      "orderid": widget.orderId,
      "ordernumber": widget.orderNumber,
      "uid": SharedPrefs().uID,
      "locationid": SharedPrefs().selectedLocationID,
      "regionid": SharedPrefs().selectedRegionID,
      "usersession": SharedPrefs().userSession,
      "items": selectedOrderItems,
    };
    final jsonResponse = await apiService.postRequest(
        context, ApiService.goodReceiveUpdate, data);
    if (jsonResponse != null) {
      final response = UpdateGoodReceiveResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          isGoodsReceived = true;
          receivedGoodsNumber = response.data.grNumber;
          isGenerateLabelEnabled = response.data.print;
          receivedGoodsSuccessMessage = response.message.join(', ');
        } else {
          showErrorDialog(context, response.message.join(', '), false);
        }
      });
    }
    // var res = await globalBloc.doFetchConfirmReceiveGoods(
    //   context,
    //   orderId: widget.orderId,
    //   orderNumber: widget.orderNumber,
    //   uID: SharedPrefs().uID,
    //   selectedLocationID: SharedPrefs().selectedLocationID,
    //   selectedRegionID: SharedPrefs().selectedRegionID,
    //   userSession: SharedPrefs().userSession,
    //   itemList: selectedOrderItems,
    // );
    // setState(() {
    //   if (res.code == '200') {
    //     isGoodsReceived = true;
    //     receivedGoodsNumber = res.data.grNumber;
    //     isGenerateLabelEnabled = res.data.print;
    //     receivedGoodsSuccessMessage = res.message.join(', ');
    //   } else {
    //     showErrorDialog(context, res.message.join(', '), false);
    //   }
    // });

    setState(() {
      isLoading = false;
    });
  }

  void showReceiveGoodsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomImageActionAlert(
            iconString: "",
            imageString: ImageAssets.receiveGoodsImage,
            titleString: AppStrings.receiveGoodsTitle,
            subTitleString: AppStrings.receiveGoodsSubTitle
                .replaceAll("{count}", selectedOrderItems.length.toString()),
            destructiveActionString: AppStrings.yes,
            normalActionString: AppStrings.no,
            onDestructiveActionTap: () {
              Navigator.pop(context);
              onConfirmReceiveGoods();
            },
            onNormalActionTap: () {
              Navigator.pop(context);
            },
            isNormalAlert: true,
            isConfirmationAlert: true);
      },
    );
  }

  void checkIsAnyItemSelected() {
    isReceiveGoodsEnabled = false;
    for (var item in orderItems) {
      if (item.isSelected) {
        isReceiveGoodsEnabled = true;
      } else {
        isAllSelected = false;
      }
    }
  }

  void printReceiveGoods(int orderId, int itemId, String grNo) {
    isGoodsReceived = false;
    isReceiveGoodsEnabled = false;
    navigateToScreen(
        context,
        PDFViewScreen(
          orderNumber: widget.orderNumber,
          orderId: orderId,
          itemId: itemId,
          grNo: grNo,
        ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = displayWidth(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: buildCommonAppBar(
          context: context,
          title: AppStrings.itemDetails,
        ),
        body: isLoading
            ? const Center(child: CustomProgressIndicator())
            : Stack(
                children: [
                  isError
                      ? Column(
                          children: [
                            const SizedBox(height: 60),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                height: displayHeight(context) * 0.65,
                                width: displayWidth(context),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: ColorManager.white),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    Image.asset(
                                        width: displayWidth(context) * 0.5,
                                        ImageAssets.noRecordFoundIcon),
                                    Text(errorText,
                                        style: getRegularStyle(
                                            color: ColorManager.lightGrey,
                                            fontSize: FontSize.s17)),
                                    const Spacer()
                                  ],
                                )),
                              ),
                            ),
                          ],
                        )
                      : isGoodsReceived
                          ? Column(
                              children: [
                                const SizedBox(height: 60),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    height: displayHeight(context) * 0.65,
                                    width: displayWidth(context),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: ColorManager.white),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // const Spacer(),
                                        Image.asset(
                                            width: displayWidth(context) * 0.6,
                                            ImageAssets
                                                .successfulReceivedImage),
                                        Text(receivedGoodsSuccessMessage,
                                            textAlign: TextAlign.center,
                                            style: getRegularStyle(
                                                color: ColorManager.lightGrey,
                                                fontSize: FontSize.s17)),
                                        // const Spacer()
                                      ],
                                    )),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 60),
                                        SizedBox(
                                          width: displayWidth(context),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 18),
                                            child: CustomCheckBox(
                                                imageString: isAllSelected
                                                    ? ImageAssets
                                                        .selectedCheckBoxIcon
                                                    : ImageAssets.checkBoxIcon,
                                                titleString:
                                                    AppStrings.selectAll,
                                                isSelected: isAllSelected,
                                                onTap: () {
                                                  didTappedOnSelectAll();
                                                }),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              bottom: 8,
                                              left: 18,
                                              right: 18),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: orderItems.length,
                                            itemBuilder: (context, index) {
                                              return OrderItemListTile(
                                                itemID:
                                                    orderItems[index].itemOrder,
                                                title: orderItems[index]
                                                        .itemCode ??
                                                    '',
                                                subtitle: orderItems[index]
                                                    .description,
                                                imageString:
                                                    orderItems[index].itemImage,
                                                totalQuantity:
                                                    orderItems[index].quantity,
                                                receivedQuantity:
                                                    orderItems[index].isEdited
                                                        ? orderItems[index]
                                                            .updatedQuantity
                                                        : orderItems[index]
                                                            .receivedQuantity,
                                                isSelected: orderItems[index]
                                                    .isSelected,

                                                isReject: hasRejectData(
                                                    orderItems[index]
                                                        .orderLineId),
                                                rejectQuantity: hasRejectData(
                                                        orderItems[index]
                                                            .orderLineId)
                                                    ? rejectDataMap[
                                                            orderItems[index]
                                                                .orderLineId]![
                                                        'rejectQuantity'] // Pass reject quantity
                                                    : null,
                                                onTap: () {
                                                  setState(() {
                                                    orderItems[index]
                                                            .isSelected =
                                                        !orderItems[index]
                                                            .isSelected;
                                                    checkIsAnyItemSelected();
                                                  });
                                                },
                                                onEdit: () {
                                                  bool hasRejectData =
                                                      rejectDataMap.containsKey(
                                                          orderItems[index]
                                                              .orderLineId);

                                                  editReceivedQuantity(
                                                    context,
                                                    hasRejectData
                                                        ? rejectDataMap[orderItems[
                                                                    index]
                                                                .orderLineId]![
                                                            'rejectQuantity'] // Use reject quantity for editing
                                                        : (orderItems[index]
                                                                .isEdited
                                                            ? orderItems[index]
                                                                .updatedQuantity
                                                            : orderItems[index]
                                                                .receivedQuantity),
                                                    orderItems[index].quantity,
                                                    index,
                                                    hasRejectData,
                                                  );
                                                },
                                                isImageUploaded:
                                                    uploadedImages.containsKey(
                                                        orderItems[index]
                                                            .orderLineId),
                                                // onImageUploaded:
                                                //     (fileName, base64Image) {
                                                //   setState(() {
                                                //     uploadedImages[
                                                //         orderItems[index]
                                                //             .orderLineId] = {
                                                //       "fileName": fileName,
                                                //       "base64": base64Image,
                                                //     };
                                                //     LoggerData.dataLog(
                                                //         "Uploaded Base64 for orderLineId ${orderItems[index].orderLineId}: ${uploadedImages[orderItems[index].orderLineId]}");
                                                //   });
                                                // }
                                                uploadedImageBase64:
                                                    uploadedImages[
                                                            orderItems[index]
                                                                .orderLineId]
                                                        ?["base64"],

                                                // onImageUploaded:
                                                //     (fileName, base64Image) {
                                                //   setState(() {
                                                //     if (fileName.isEmpty &&
                                                //         base64Image.isEmpty) {
                                                //       uploadedImages.remove(
                                                //           orderItems[index]
                                                //               .orderLineId); // remove image
                                                //     } else {
                                                //       uploadedImages[
                                                //           orderItems[index]
                                                //               .orderLineId] = {
                                                //         "fileName": fileName,
                                                //         "base64": base64Image,
                                                //       };
                                                //       orderItems[index]
                                                //           .isSelected = true;
                                                //     }
                                                //     checkIsAnyItemSelected();
                                                //   });
                                                // },
                                                onImageUploaded: (fileName,
                                                    azureImageName,
                                                    base64Image) {
                                                  setState(() {
                                                    if (fileName.isEmpty &&
                                                        base64Image.isEmpty &&
                                                        azureImageName
                                                            .isEmpty) {
                                                      uploadedImages.remove(
                                                          orderItems[index]
                                                              .orderLineId);
                                                    } else {
                                                      uploadedImages[
                                                          orderItems[index]
                                                              .orderLineId] = {
                                                        "fileName": fileName,
                                                        "azureImageName":
                                                            azureImageName,
                                                        "base64": base64Image,
                                                      };
                                                      orderItems[index]
                                                          .isSelected = true;
                                                    }
                                                    checkIsAnyItemSelected();
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: ColorManager.white,
                      alignment: Alignment.topLeft,
                      height: 60,
                      width: displayWidth(context),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 18, right: 18, bottom: 8),
                            child: Text(
                              AppStrings.orderNumberDetail + widget.orderNumber,
                              style: getBoldStyle(
                                  color: ColorManager.darkBlue,
                                  fontSize: FontSize.s20),
                            ),
                          ),
                          // const Spacer(),
                          const SizedBox(height: 5),
                          isGoodsReceived
                              ? const SizedBox()
                              : isPrintEnabled
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 18),
                                      child: IconButton(
                                          onPressed: () {
                                            printReceiveGoods(
                                                widget.orderId, 0, "");
                                          },
                                          icon: Image.asset(
                                              ImageAssets.printIcon)),
                                    )
                                  : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: displayWidth(context),
                      height: 90,
                      color: isGoodsReceived
                          ? isGenerateLabelEnabled
                              ? ColorManager.white
                              : Colors.transparent
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: isGoodsReceived
                            ? isGenerateLabelEnabled
                                ? CustomButton(
                                    buttonText: AppStrings.generateLabels,
                                    onTap: () {
                                      printReceiveGoods(widget.orderId, 0,
                                          receivedGoodsNumber);
                                    },
                                    isEnabled: isReceiveGoodsEnabled)
                                : const SizedBox()
                            : CustomButton(
                                buttonText: AppStrings.receiveGoods,
                                onTap: () {
                                  isReceiveGoodsEnabled ? receiveGoods() : null;
                                },
                                isEnabled: isReceiveGoodsEnabled),
                      ),
                    ),
                  ),
                  isEditingQuantity
                      ? AnimatedPositioned(
                          duration: duration,
                          curve: Curves.easeInOut,
                          bottom: isEditingQuantity ? 0 : -editBoxHeight,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => isEditingQuantity = false),
                            child: AnimatedContainer(
                              color: ColorManager.blackOpacity50,
                              duration: duration,
                              height: isEditingQuantity
                                  ? displayHeight(context)
                                  : 0,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  QuantityEditPopup(
                                    quantityController: editQuantityController,
                                    commentsController: _commentsController,
                                    isReject: isReject,
                                    isReceiveGoodsEnabled:
                                        isReceiveGoodsEnabled,
                                    onIncrease: increaseReceivedQuantity,
                                    onDecrease: decreaseReceivedQuantity,
                                    onToggleAcceptReject: (value) {
                                      setState(() {
                                        isReject = !value;
                                        isReceiveGoodsEnabled = value;
                                      });
                                    },
                                    // Add the new parameters for dropdowns
                                    selectedRejectReason: selectedRejectReason,
                                    selectedAction: selectedAction,
                                    onRejectReasonChanged: (newValue) {
                                      setState(() {
                                        selectedRejectReason = newValue;
                                      });
                                    },
                                    onActionChanged: (newValue) {
                                      setState(() {
                                        selectedAction = newValue;
                                      });
                                    },
                                    boxHeight: editBoxHeight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  if (isEditingQuantity)
                    PopupTickButton(
                      isReject: isReject, // Pass the current state
                      onTap: () {
                        if (editQuantityController.text.isNotEmpty) {
                          updateReceivedQuantity();

                          // Clear the comments box after update
                          _commentsController.clear();

                          // Also clear any error message
                          setState(() {
                            errorMessage = null;
                          });
                        } else {
                          showErrorDialog(
                              context, AppStrings.quantityCannotBeBlank, false);
                        }
                      },
                    ),
                ],
              ),
      ),
    );
  }
}

class PopupTickButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isReject;

  const PopupTickButton({
    super.key,
    required this.onTap,
    required this.isReject,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    // Adjust offset based on reject state (increased for dropdowns)
    double calculatedBottomOffset = isReject
        ? screenHeight * 0.43 // Higher when dropdowns are visible
        : screenHeight * 0.25; // Lower when no dropdowns

    return Positioned(
      bottom: calculatedBottomOffset,
      right: screenHeight * 0.02,
      child: Container(
        width: screenWidth,
        height: 80,
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: onTap,
            icon: Image.asset(
              isReject ? ImageAssets.tickIconRed : ImageAssets.tickIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class QuantityEditPopup extends StatefulWidget {
  final TextEditingController quantityController;
  final TextEditingController commentsController;
  final bool isReject;
  final bool isReceiveGoodsEnabled;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<bool> onToggleAcceptReject;
  final double boxHeight;

  // Add these new parameters
  final String? selectedRejectReason;
  final String? selectedAction;
  final ValueChanged<String?> onRejectReasonChanged;
  final ValueChanged<String?> onActionChanged;

  const QuantityEditPopup({
    super.key,
    required this.quantityController,
    required this.commentsController,
    required this.isReject,
    required this.isReceiveGoodsEnabled,
    required this.onIncrease,
    required this.onDecrease,
    required this.onToggleAcceptReject,
    required this.selectedRejectReason,
    required this.selectedAction,
    required this.onRejectReasonChanged,
    required this.onActionChanged,
    this.boxHeight = 350,
  });

  @override
  State<QuantityEditPopup> createState() => _QuantityEditPopupState();
}

class _QuantityEditPopupState extends State<QuantityEditPopup> {
  int maxChars = AppConstants.maxCharactersForComment;
  String? errorMessage;

  // Animated height based on Accept/Reject
  double get _calculatedHeight {
    double screenHeight = MediaQuery.of(context).size.height;
    return widget.isReject ? screenHeight * 0.48 : screenHeight * 0.30;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(screenHeight * 0.02),
      height: _calculatedHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenHeight * 0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ToggleButtons Row
            Row(
              children: [
                SizedBox(width: screenWidth * 0.01),
                Container(
                  height: screenHeight * 0.05,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(screenHeight * 0.01),
                    border: Border.all(
                      color: ColorManager.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ToggleButtons(
                    isSelected: [!widget.isReject, widget.isReject],
                    onPressed: (index) {
                      widget.onToggleAcceptReject(index == 0);
                    },
                    borderRadius: BorderRadius.circular(screenHeight * 0.01),
                    constraints: BoxConstraints(
                      minWidth: screenWidth * 0.20,
                      minHeight: screenHeight * 0.10,
                    ),
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: MaterialStateColor.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        final selectedIndex = [
                          !widget.isReject,
                          widget.isReject
                        ].indexWhere((selected) => selected);
                        return selectedIndex == 0
                            ? ColorManager.green
                            : ColorManager.red2;
                      }
                      return Colors.transparent;
                    }),
                    children: [
                      // Accept Button with icon
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: screenHeight * 0.03,
                              color: !widget.isReject
                                  ? Colors.white
                                  : ColorManager.green,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              "Accept",
                              style: getBoldStyle(
                                fontSize: screenHeight * 0.018,
                                color: !widget.isReject
                                    ? Colors.white
                                    : ColorManager.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Reject Button with icon
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImageAssets.closeIcon,
                              width: screenHeight * 0.025,
                              height: screenHeight * 0.025,
                              color: widget.isReject
                                  ? Colors.white
                                  : ColorManager.red2,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              "Reject",
                              style: getBoldStyle(
                                fontSize: screenHeight * 0.018,
                                color: widget.isReject
                                    ? Colors.white
                                    : ColorManager.red2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            const Divider(thickness: 1),
            SizedBox(height: screenHeight * 0.02),

            // Quantity Label
            Text(
              widget.isReject
                  ? "Edit Reject Quantity"
                  : AppStrings.editReceiveQuantity,
              style: getBoldStyle(
                color: ColorManager.lightGrey2,
                fontSize: screenHeight * 0.025,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Quantity Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quantityButton(
                  icon: ImageAssets.minusIcon,
                  onPressed: widget.onDecrease,
                  size: screenHeight,
                ),
                SizedBox(
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.04,
                  child: TextField(
                    controller: widget.quantityController,
                    style: getBoldStyle(
                      color: ColorManager.lightGrey2,
                      fontSize: screenHeight * 0.022,
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      DecimalTextInputFormatter(
                        decimalPlaces: SharedPrefs().decimalPlaces,
                        minValue: 0.1,
                        maxValue: double.infinity,
                      ),
                      LengthLimitingTextInputFormatter(
                          AppConstants.maxCharactersForQuantity),
                    ],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: ColorManager.grey.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.008),
                        borderSide: BorderSide(
                          color: ColorManager.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.008),
                        borderSide: BorderSide(
                          color: ColorManager.darkBlue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                _quantityButton(
                  icon: ImageAssets.plusIcon,
                  onPressed: widget.onIncrease,
                  size: screenHeight,
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.03),

            // Dropdowns for Reject only - Using InputDecorator with proper styling
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: widget.isReject ? 1.0 : 0.0,
              child: Visibility(
                visible: widget.isReject,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // Two Dropdowns in Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Reject Reason Dropdown
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: screenWidth * 0.01),
                            child: _buildDropdownWithInputDecoration(
                              label: 'Reject Reason :',
                              value: widget
                                  .selectedRejectReason, 
                              items: [
                                'Broken',
                                'Not Required',
                                'Shortage',
                                'Unavailable',
                                'Wrong Specification'
                              ],
                              onChanged: widget
                                  .onRejectReasonChanged, 
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              fixedWidth: screenWidth * 0.38,
                            ),
                          ),
                        ),

                        SizedBox(width: screenWidth * 0.02),

                        // Action Dropdown
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: screenWidth * 0.01),
                            child: _buildDropdownWithInputDecoration(
                              label: 'Action :',
                              value: widget
                                  .selectedAction, // Use widget.selectedAction
                              items: ['Replace Item', 'Credit Note'],
                              onChanged: widget.onActionChanged,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              fixedWidth: screenWidth * 0.38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Comments for Reject only
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: widget.isReject ? 1.0 : 0.0,
              child: Visibility(
                visible: widget.isReject,
                child: SizedBox(
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.commentsController,
                          style: getSemiBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s18,
                          ),
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          keyboardType: TextInputType.multiline,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(maxChars),
                          ],
                          onChanged: (_) {
                            setState(() {}); 
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.all(screenHeight * 0.015),
                            labelText: 'Notes :',
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelStyle: getSemiBoldStyle(
                              color: ColorManager.lightGrey1,
                              fontSize: FontSize.s18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.01),
                              borderSide: BorderSide(
                                color: ColorManager.grey.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.01),
                              borderSide: BorderSide(
                                color: ColorManager.grey.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.01),
                              borderSide: BorderSide(
                                color: ColorManager.darkBlue,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      // Characters remaining
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Characters remaining ${maxChars - widget.commentsController.text.length}",
                            style: TextStyle(
                              fontSize: FontSize.s14,
                              color: ColorManager.darkGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownWithInputDecoration({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required double screenWidth,
    required double screenHeight,
    double? fixedWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: screenWidth * 0.3,
        maxWidth: fixedWidth ?? screenWidth * 0.5,
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: getSemiBoldStyle(
            color: ColorManager.lightGrey1,
            fontSize: FontSize.s18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.01),
            borderSide: BorderSide(
              color: ColorManager.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.008),
            borderSide: BorderSide(
              color: ColorManager.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.008),
            borderSide: BorderSide(
              color: ColorManager.darkBlue,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenHeight * 0.008,
          ),
          isCollapsed: true,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.05,
          ),
        ),
        isEmpty: value == null,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: ColorManager.darkBlue,
              size: screenHeight * 0.028,
            ),
            style: getSemiBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s18,
            ),
            dropdownColor: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(screenHeight * 0.008),
            menuMaxHeight: screenHeight * 0.35,
            underline: const SizedBox(),
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((String item) {
                return Text(
                  item,
                  style: getSemiBoldStyle(
                    color: ColorManager.darkBlue,
                    fontSize: FontSize.s16,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              }).toList();
            },
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: getSemiBoldStyle(
                    color: value == item
                        ? ColorManager.darkBlue
                        : ColorManager.black,
                    fontSize: FontSize.s16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _quantityButton({
    required String icon,
    required VoidCallback onPressed,
    required double size,
  }) {
    return Container(
      width: size * 0.06,
      height: size * 0.04,
      decoration: BoxDecoration(
        color: ColorManager.darkBlue,
        borderRadius: BorderRadius.circular(size * 0.008),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Image.asset(
          icon,
          width: size * 0.02,
          height: size * 0.02,
          color: Colors.white,
        ),
      ),
    );
  }
}
