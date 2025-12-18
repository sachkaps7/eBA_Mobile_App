import 'dart:developer';

import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/item_details_response.dart';
import 'package:eyvo_v3/api/response_models/update_blind_stock.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/app/sizes_helper.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BlindStockDetailsView extends StatefulWidget {
  final int itemId;
  const BlindStockDetailsView({super.key, required this.itemId});

  @override
  State<BlindStockDetailsView> createState() => _BlindStockDetailsViewState();
}

class _BlindStockDetailsViewState extends State<BlindStockDetailsView> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _commmentsController = TextEditingController();
  final TextEditingController _physicalQtyController = TextEditingController();
  final FocusNode physicalQtyFocusNode = FocusNode();

  late List<ItemDetails> items = [];
  bool isItemEditable = false;
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  final ApiService apiService = ApiService();
  DateTime selectedDate = DateTime.now();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode quantityFocusNode = FocusNode();
  int? itemType;
  @override
  void initState() {
    super.initState();
    _physicalQtyController.text = getFormattedPriceStringPrice(0.00);
    _dateController.text = DateFormat('dd-MMM-yyyy').format(selectedDate);
    _priceController.text = getFormattedStringPrice(0.0);
    fetchItemDetails();
    physicalQtyFocusNode.addListener(() {
      if (!physicalQtyFocusNode.hasFocus) {
        _formatPhysicalQty();
      }
    });

    quantityFocusNode.addListener(() {
      if (!quantityFocusNode.hasFocus) {
        _performQuantityActionOnFocusChanged();
      }
    });
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    quantityFocusNode.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    _commmentsController.dispose();
    _physicalQtyController.dispose();
    physicalQtyFocusNode.dispose();
    SharedPrefs().isItemScanned = false;
    super.dispose();
  }

  void _performQuantityActionOnFocusChanged() {
    if (_quantityController.text.isNotEmpty) {
      _quantityController.text = getDefaultString(_quantityController.text);
      _quantityController.text =
          getFormattedString(double.parse(_quantityController.text));
    } else {
      _quantityController.text = getFormattedString(1);
    }
  }

  void fetchItemDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      "itemid": widget.itemId,
      "locationid": SharedPrefs().isItemScanned
          ? SharedPrefs().scannedLocationID
          : SharedPrefs().selectedLocationID,
      'regionid': SharedPrefs().isItemScanned
          ? SharedPrefs().scannedRegionID
          : SharedPrefs().selectedRegionID,
      "uid": SharedPrefs().uID,
      'apptype': AppConstants.apptype,
    };

    final jsonResponse = await apiService.postRequest(
        context, ApiService.blindStockDetails, data);
    if (jsonResponse != null) {
      final response = ItemDetailsResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          items = response.data;
          _priceController.text =
              getFormattedPriceStringPrice(items[0].basePrice);
          isItemEditable = items[0].itemEdit;

          // Save item_type for later use
          itemType = items[0].itemType;
        } else {
          isError = true;
          errorText = response.message.join(', ');
        }
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  String getFormattedPriceStringPricetwo(double price) {
    var priceFormatter =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);
    return priceFormatter.format(price);
  }

  void _formatPhysicalQty() {
    if (_physicalQtyController.text.isEmpty) {
      _physicalQtyController.text = "0.00";
    } else {
      final value = double.tryParse(_physicalQtyController.text);
      if (value != null) {
        _physicalQtyController.text = getFormattedPriceStringPricetwo(value);
      }
    }
  }

  void updateBlindStack() async {
    double adjustQuantity = double.tryParse(
          _physicalQtyController.text.trim().replaceAll(',', ''),
        ) ??
        0.00;

    String notes = _commmentsController.text.trim();

    //  Validation

    if (_physicalQtyController.text.trim().isEmpty) {
      showErrorDialog(
        context,
        "Physical Quantity cannot be empty.",
        false,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      "itemid": widget.itemId,
      "adjustquantity": adjustQuantity,
      "locationid": SharedPrefs().isItemScanned
          ? SharedPrefs().scannedLocationID
          : SharedPrefs().selectedLocationID,
      "notes": notes,
      "uid": SharedPrefs().uID,
      "itemtype": itemType,
      'apptype': AppConstants.apptype,
    };

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.updateBlindStock,
      data,
    );

    if (jsonResponse != null) {
      final response = UpdateBlindStockResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          showSuccessDialog(
            context,
            ImageAssets.successfulIcon,
            '',
            response.message.join(', '),
            true,
          );
        } else {
          showErrorDialog(context, response.message.join(', '), false);
        }
      });
    }
    setState(() {
      isLoading = false;
    });
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
          title: "Blind Stock Details",
        ),
        body: isLoading
            ? const Center(child: CustomProgressIndicator())
            : isError
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
                                    ImageAssets.errorMessageIcon),
                                Text(errorText,
                                    style: getRegularStyle(
                                        color: ColorManager.lightGrey,
                                        fontSize: FontSize.s17)),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                border: Border.all(
                                    color: ColorManager.grey4, width: 1.0),
                                borderRadius: BorderRadius.circular(8)),
                            width: screenWidth,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      // Center(
                                      //     child: SizedBox(
                                      //         height: 160,
                                      //         width: 160,
                                      //         child: Image.network(
                                      //             items[0].itemImage))),
                                      Center(
                                        child: SizedBox(
                                          height: 160,
                                          width: 160,
                                          child: (items[0].itemImage.isNotEmpty)
                                              ? Image.network(
                                                  items[0].itemImage,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    // If URL is invalid or fails to load
                                                    return Image.asset(
                                                        ImageAssets.noImages);
                                                  },
                                                )
                                              : Image.asset(
                                                  ImageAssets.noImages),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(items[0].outline,
                                                style: getBoldStyle(
                                                    color:
                                                        ColorManager.darkBlue,
                                                    fontSize: FontSize.s22_5)),
                                            const SizedBox(height: 5),
                                            RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                text:
                                                    AppStrings.itemCodeDetails,
                                                style: getSemiBoldStyle(
                                                    color: ColorManager.black,
                                                    fontSize: FontSize.s14),
                                                children: [
                                                  TextSpan(
                                                      text: items[0].itemCode,
                                                      style: getRegularStyle(
                                                          color: ColorManager
                                                              .black,
                                                          fontSize:
                                                              FontSize.s14))
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                text: AppStrings
                                                    .categoryCodeDetails,
                                                style: getSemiBoldStyle(
                                                    color: ColorManager.black,
                                                    fontSize: FontSize.s14),
                                                children: [
                                                  TextSpan(
                                                    text: items[0].categoryCode,
                                                    style: getRegularStyle(
                                                        color:
                                                            ColorManager.black,
                                                        fontSize: FontSize.s14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Divider(
                                              height: 0.2,
                                              thickness: 0.4,
                                              color: ColorManager.lightBlue2,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(items[0].description,
                                                style: getRegularStyle(
                                                    color: ColorManager.black,
                                                    fontSize: FontSize.s14)),
                                            const SizedBox(height: 5),
                                            Divider(
                                              height: 0.2,
                                              thickness: 0.4,
                                              color: ColorManager.lightBlue2,
                                            ),
                                            //   const SizedBox(height: 6),
                                            // RichText(
//   overflow: TextOverflow.ellipsis,
//   maxLines: 1,
//   text: TextSpan(
//     text: "Current Stock: ",
//     style: getBoldStyle(
//       color: ColorManager.green,
//       fontSize: FontSize.s18,
//     ),
//     children: [
//       TextSpan(
//         text: getFormattedPriceStringPrice(
//             items[0].stockCount),
//         style: getBoldStyle(
//           color: ColorManager.green,
//           fontSize: FontSize.s18,
//         ),
//       ),
//     ],
//   ),
// ),

                                            const SizedBox(height: 20),
                                            // Physical Quantity Block
                                            SizedBox(
                                              width: (screenWidth) - 45,
                                              height: 50,
                                              child: TextField(
                                                focusNode: physicalQtyFocusNode,
                                                controller:
                                                    _physicalQtyController,
                                                style: getSemiBoldStyle(
                                                  color: ColorManager.black,
                                                  fontSize: FontSize.s16,
                                                ),
                                                readOnly: isItemEditable
                                                    ? false
                                                    : true,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  decimal: true,
                                                ),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                    AppConstants
                                                        .maxCharactersForQuantity,
                                                  ),
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(
                                                        r'^\d*\.?\d*$'), //Only numbers + optional decimal
                                                  ),
                                                ],
                                                onTap: () {
                                                  // Place cursor at the end of the text instead of selecting all
                                                  _physicalQtyController
                                                          .selection =
                                                      TextSelection
                                                          .fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            _physicalQtyController
                                                                .text.length),
                                                  );
                                                },
                                                onEditingComplete: () {
                                                  _formatPhysicalQty();
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  labelText:
                                                      "Physical Quantity",
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  floatingLabelStyle:
                                                      getSemiBoldStyle(
                                                    color:
                                                        ColorManager.lightGrey1,
                                                    fontSize: FontSize.s16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              width: (screenWidth) - 45,
                                              height: 120,
                                              child: TextField(
                                                controller:
                                                    _commmentsController,
                                                style: getSemiBoldStyle(
                                                  color: ColorManager.black,
                                                  fontSize: FontSize.s16,
                                                ),
                                                readOnly: isItemEditable
                                                    ? false
                                                    : true,
                                                maxLines: null,
                                                minLines: 5,
                                                expands: false,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                    AppConstants
                                                        .maxCharactersForComment,
                                                  ),
                                                ],
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  labelText: AppStrings.notes,
                                                  alignLabelWithHint: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  floatingLabelStyle:
                                                      getSemiBoldStyle(
                                                    color:
                                                        ColorManager.lightGrey1,
                                                    fontSize: FontSize.s16,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //   const SizedBox(height: 20),
                                isItemEditable
                                    ? Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Container(
                                          color: ColorManager.white,
                                          width: (screenWidth) - 65,
                                          //  height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 20, 0, 20),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          CustomTextActionButton(
                                                        buttonText:
                                                            "Adjust Stock",
                                                        backgroundColor:
                                                            ColorManager.green,
                                                        borderColor:
                                                            Colors.transparent,
                                                        fontColor:
                                                            ColorManager.white,
                                                        buttonWidth:
                                                            double.infinity,
                                                        buttonHeight: 50,
                                                        isBoldFont: true,
                                                        fontSize: FontSize.s20,
                                                        onTap: () {
                                                          updateBlindStack();
                                                          log("adjust stock");
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
      ),
    );
  }
}
