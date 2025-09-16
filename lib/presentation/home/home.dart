import 'dart:developer';

import 'package:eyvo_inventory/CommonCode/global_utils.dart';
import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/dashboard_response.dart';
import 'package:eyvo_inventory/api/response_models/inventory_manager_check_response.dart';
import 'package:eyvo_inventory/api/response_models/location_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/custom_card_item.dart';
import 'package:eyvo_inventory/core/widgets/custom_list_tile.dart';
import 'package:eyvo_inventory/core/widgets/setting_page.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:eyvo_inventory/presentation/blind_stock/blindstock_list.dart';
import 'package:eyvo_inventory/presentation/change_password/change_password.dart';
import 'package:eyvo_inventory/presentation/image_upload/Image_upload.dart';
import 'package:eyvo_inventory/presentation/item_details/item_details.dart';
import 'package:eyvo_inventory/presentation/item_list/item_list.dart';
import 'package:eyvo_inventory/presentation/location_list/location_list.dart';
import 'package:eyvo_inventory/presentation/select_order/select_order.dart';
import 'package:eyvo_inventory/presentation/site_list/region_list.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  bool isPermissionDenied = false;
  bool isLoading = false;
  bool isRegionEnabled = false;
  bool isRegionEditable = false;
  bool isLocationEnabled = false;
  bool isLocationEditable = false;
  bool isScanItemsEnabled = false;
  bool isListItemsEnabled = false;
  bool isGREnabled = false;
  List<String> items = [];
  List<String> menuItems = [];
  String selectRegionTitle = '';
  String selectLocationTitle = '';
  String? selectedRegion;
  String? selectedLocation;
  final ApiService apiService = ApiService();
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  bool isFetchingLocation = false; // Add this variable
  bool isLoginazureAd = SharedPrefs().isLoginazureAd;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? selectedRegionId;
  bool isLocationNull = false;
  bool inventoryManager = SharedPrefs().inventoryManager;
  //bool blindStockEdit = SharedPrefs().blindStockEdit;
  String displayUserName = SharedPrefs().displayUserName;
  int totalRecords = 0;
  final Map<String, IconData> menuIcons = {
    AppStrings.home: Icons.home_outlined,
    AppStrings.settings: Icons.settings_outlined,
    AppStrings.changePassword: Icons.lock_outlined,
  };
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.unsubscribe(this);

    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    fetchNewInvebtoryMangaerLocation();
  }

  @override
  void initState() {
    super.initState();
    menuItems = [AppStrings.home, AppStrings.settings];
    if (!isLoginazureAd) {
      menuItems.add(AppStrings.changePassword);
    }
    fetchDashboardItems();
  }

  void fetchDashboardItems() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.dashboard, data);
    if (jsonResponse != null) {
      final response = DashboardResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          var dataList = jsonResponse['data'] as String;
          List<dynamic> data = jsonDecode(dataList);
          for (var item in data) {
            item.forEach((key, value) {
              if (value is bool && value == true) {
                if (key != AppStrings.apiKeyRegion &&
                    key != AppStrings.apiKeyEditRegion &&
                    key != AppStrings.apiKeyLocation &&
                    key != AppStrings.apiKeyEditLocation) {
                  items.add(key);
                }
              }
            });
          }

          if (response.data.isNotEmpty) {
            SharedPrefs().selectedRegionID = response.data[0].regionId;
            SharedPrefs().selectedLocationID = response.data[0].locationId;
            selectRegionTitle = response.data[0].regionLabelName;
            selectedRegion = response.data[0].regionName;
            selectLocationTitle = response.data[0].locationLabelName;
            selectedLocation = response.data[0].locationName;
            SharedPrefs().selectedLocation = response.data[0].locationName;
            isRegionEnabled = response.data[0].region;
            isRegionEditable = response.data[0].regionEdit;
            isLocationEnabled = response.data[0].location;
            isLocationEditable = response.data[0].locationEdit;
            isScanItemsEnabled = response.data[0].scanYourItem;
            isListItemsEnabled = response.data[0].listAllItems;
            selectedRegionId = response.data[0].regionId;
            SharedPrefs().inventoryManager = response.data[0].inventoryManager;
            SharedPrefs().blindStockEdit = response.data[0].blindStockEdit;
            inventoryManager = response.data[0].inventoryManager;
            // blindStockEdit =
            //  response.data[0].blindStockEdit;
            isGREnabled = response.data[0].gr;
            SharedPrefs().decimalPlaces = response.data[0].decimalPlaces;
            SharedPrefs().decimalplacesprice =
                response.data[0].decimalplacesprice;
            isPermissionDenied = (!isRegionEnabled &&
                    !isLocationEnabled &&
                    !isScanItemsEnabled &&
                    !isListItemsEnabled &&
                    !isGREnabled)
                ? true
                : false;
          }
        });
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> scanBarcode() async {
    try {
      ScanResult barcodeScanResult = await BarcodeScanner.scan();
      String resultString = barcodeScanResult.rawContent;
      if (resultString.isNotEmpty && resultString != "-1") {
        Map<String, dynamic> jsonDict = jsonDecode(resultString);
        SharedPrefs().scannedLocationID = jsonDict['location_id'];
        SharedPrefs().scannedRegionID = jsonDict['region_id'];
        SharedPrefs().isItemScanned = true;
        navigateToItemDetails(jsonDict['itemid']);
      }
    } catch (e) {
      setState(() {
        errorText = "Failed to scan";
      });
    }
  }

  // void navigateToLocationList() async {
  //   final selectedCode = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => LocationListView(
  //         selectedItem: selectedLocation ?? '',
  //         selectedTitle: selectLocationTitle,
  //         selectedRegioId: selectedRegionId!,
  //       ),
  //     ),
  //   );

  //   if (selectedCode != null) {
  //     setState(() {
  //       selectedLocation = selectedCode; // update UI
  //       SharedPrefs().selectedLocation = selectedCode;
  //     });

  //     // also refresh dashboard/items if needed
  //     fetchDashboardItems();
  //   }
  // }

  void navigateToItemDetails(int itemId) {
    navigateToScreen(context, ItemDetailsView(itemId: itemId));
  }

  void navigateToScanItems() {
    scanBarcode();
  }

  void navigateToListItems() {
    navigateToScreen(context, const ItemListView());
  }

  void navigateToReceiveGoods() {
    navigateToScreen(context, const SelectOrderView());
  }

  void navigateFromSideMenuAsPerSelectedTitle(String title) {
    if (title == AppStrings.home) {
      Navigator.pop(context);
    }
    if (title == AppStrings.changePassword) {
      navigateToScreen(context, const ChangePasswordView());
    }
    if (title == AppStrings.settings) {
      navigateToScreen(context, const SettingPage());
    }
  }

  void logoutUser() {
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.loginRoute, (Route<dynamic> route) => false);
  }

  void fetchNewLocation(int regionId) async {
    setState(() {
      isFetchingLocation = true; // Set fetching location to true
    });

    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
      'regionid': regionId
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.locationList, data);
    //log("@@@@@@@@@@@@@@@@@@@@@@:$jsonResponse");
    if (jsonResponse != null) {
      final response = LocationResponse.fromJson(jsonResponse);
      totalRecords = response.totalRecords;

      if (response.code == '200') {
        setState(() {
          selectedLocation = response.data![0].locationCode;
          SharedPrefs().selectedLocationID = response.data![0].locationId!;
          isLocationNull = false;
          isLocationEditable = totalRecords > 1;
        });
      } else if (response.code == '400') {
        setState(() {
          selectedLocation = '';
          isLocationNull = true;
        });
      } else {
        setState(() {
          isError = true;
          errorText = response.message.join(', ');
        });
      }
    }

    setState(() {
      isFetchingLocation = false;
    });
  }

  void fetchNewInvebtoryMangaerLocation() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
      'locationid': SharedPrefs().selectedLocationID
    };
    final jsonResponse = await apiService.postRequest(
        context, ApiService.inventoryManagerLocationCheck, data);

    if (jsonResponse != null) {
      final response = InventoryManagerCheckResponse.fromJson(jsonResponse);

      if (response.code == '200') {
        setState(() {
          SharedPrefs().blindStockEdit = response.data.blindstockedit;
          //  blindStockEdit = response.data.blindstockedit;
          log("&&&&&&&&&&&&&&&&&&&&&&&blindStockEdit: ${SharedPrefs().blindStockEdit}");
        });
      } else if (response.code == '400') {
        setState(() {
          SharedPrefs().blindStockEdit = false;
        });
      } else {
        setState(() {
          isError = true;
          errorText = response.message.join(', ');
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  // Widget build(BuildContext context) {
  //   double topPadding = MediaQuery.of(context).padding.top;
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     backgroundColor: ColorManager.primary,
  //     appBar: AppBar(
  //       backgroundColor: ColorManager.darkBlue,
  //       toolbarHeight: 56,
  //       title: Text(
  //         AppStrings.dashboard,
  //         style: getBoldStyle(
  //           color: ColorManager.white,
  //           fontSize: FontSize.s20,
  //         ),
  //       ),
  //       leading: IconButton(
  //         icon: Image.asset(
  //           ImageAssets.menu,
  //           width: 20,
  //           height: 20,
  //         ),
  //         onPressed: () {
  //           _scaffoldKey.currentState?.openDrawer();
  //         },
  //       ),
  //     ),
  //     drawer: Drawer(
  //       backgroundColor: ColorManager.light3,
  //       child: Column(
  //         children: <Widget>[
  //           SizedBox(height: topPadding + 10),
  //           Image.asset(ImageAssets.splashLogo, width: 90, height: 72),
  //           const SizedBox(height: 20),
  //           Padding(
  //             padding: const EdgeInsets.all(2),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(Icons.person, color: ColorManager.blue, size: 20),
  //                 const SizedBox(width: 6),
  //                 Flexible(
  //                   child: Text(
  //                     displayUserName,
  //                     style: TextStyle(fontSize: 18, color: ColorManager.blue),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.visible,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Container(
  //               height: 300, // Reduced from 320 if you want a tighter fit
  //               decoration: BoxDecoration(
  //                 color: ColorManager.white,
  //                 border: Border.all(color: ColorManager.grey4, width: 1.0),
  //                 borderRadius: BorderRadius.circular(6),
  //               ),
  //               child: Column(
  //                 children: [
  //                   Expanded(
  //                     child: ListView.separated(
  //                       padding: EdgeInsets.zero,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemCount: menuItems.length,
  //                       separatorBuilder: (context, index) => Divider(
  //                         height: 0.5,
  //                         thickness: 0.5,
  //                         color: ColorManager.primary,
  //                       ),
  //                       itemBuilder: (context, index) {
  //                         final title = menuItems[index];
  //                         final icon =
  //                             menuIcons[title] ?? Icons.arrow_forward_ios;

  //                         return Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 0.5),
  //                           child: MenuItemListTile(
  //                             title: title,
  //                             iconData: icon,
  //                             onTap: () {
  //                               navigateFromSideMenuAsPerSelectedTitle(title);
  //                             },
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(height: 6), // Slightly reduced
  //                   GestureDetector(
  //                     onTap: logoutUser,
  //                     child: SizedBox(
  //                       height: 60,
  //                       width: displayWidth(context),
  //                       child: Column(
  //                         children: [
  //                           Container(height: 1, color: ColorManager.grey6),
  //                           const SizedBox(height: 10),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Image.asset(ImageAssets.logoutIcon,
  //                                   width: 20, height: 20),
  //                               const SizedBox(width: 6),
  //                               Text(
  //                                 AppStrings.logout,
  //                                 style: getSemiBoldStyle(
  //                                   color: ColorManager.orange,
  //                                   fontSize: FontSize.s18,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           const Spacer(),
  //           Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: Text(
  //               SharedPrefs().mobileVersion,
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 color: ColorManager.blue,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     body: isLoading
  //         ? const Center(child: CustomProgressIndicator())
  //         : isPermissionDenied
  //             ? SingleChildScrollView(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(18.0),
  //                   child: Container(
  //                     height: displayHeight(context) - 150,
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(8)),
  //                       color: ColorManager.white,
  //                     ),
  //                     child: const Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         SizedBox(
  //                           child: Image(
  //                             image: AssetImage(ImageAssets.permissionDenied),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           child: CenterTitleHeader(
  //                               titleText: AppStrings.permissionDeniedTitle,
  //                               detailText:
  //                                   AppStrings.permissionDeniedSubTitle),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             : SingleChildScrollView(
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 15, left: 10, right: 10, bottom: 15),
  //                   child: Column(
  //                     children: [
  //                       isRegionEnabled
  //                           ? CustomItemCardWithEdit(
  //                               imageString: ImageAssets.selectSite,
  //                               title: selectRegionTitle,
  //                               subtitle: selectedRegion!,
  //                               onEdit: isRegionEditable
  //                                   ? () async {
  //                                       final result = await Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                           builder: (context) =>
  //                                               RegionListView(
  //                                                   selectedItem:
  //                                                       selectedRegion!,
  //                                                   selectedTitle:
  //                                                       selectRegionTitle),
  //                                         ),
  //                                       );

  //                                       if (result != null) {
  //                                         setState(() {
  //                                           selectedRegion =
  //                                               SharedPrefs().selectedRegion;
  //                                           selectedRegionId =
  //                                               SharedPrefs().selectedRegionID;
  //                                         });
  //                                         fetchNewLocation(
  //                                             SharedPrefs().selectedRegionID);
  //                                       }
  //                                     }
  //                                   : () {},
  //                               backgroundColor: ColorManager.white,
  //                               cornerRadius: 10,
  //                               isEditable: isRegionEditable)
  //                           : const SizedBox(),
  //                       isRegionEnabled
  //                           ? const SizedBox(height: 8)
  //                           : const SizedBox(),
  //                       isLocationEnabled
  //                           ? Visibility(
  //                               visible: !isFetchingLocation,
  //                               replacement: const Center(
  //                                   child: CustomProgressIndicator()),
  //                               child: CustomItemCardWithEdit(
  //                                   imageString: ImageAssets.selectLocation,
  //                                   title: selectLocationTitle,
  //                                   subtitle: selectedLocation ?? "",
  //                                   onEdit: isLocationEditable
  //                                       ? () async {
  //                                           final result = await Navigator.push(
  //                                             context,
  //                                             MaterialPageRoute(
  //                                               builder: (context) =>
  //                                                   LocationListView(
  //                                                 selectedItem:
  //                                                     selectedLocation!,
  //                                                 selectedTitle:
  //                                                     selectLocationTitle,
  //                                                 selectedRegioId:
  //                                                     selectedRegionId!,
  //                                               ),
  //                                             ),
  //                                           );
  //                                           if (result != null) {
  //                                             setState(() {
  //                                               selectedLocation = SharedPrefs()
  //                                                   .selectedLocation;
  //                                             });
  //                                           }
  //                                         }
  //                                       : () {},
  //                                   backgroundColor: ColorManager.white,
  //                                   cornerRadius: 10,
  //                                   isEditable: isLocationEditable),
  //                             )
  //                           : const SizedBox(),
  //                       isLocationEnabled
  //                           ? const SizedBox(height: 1)
  //                           : const SizedBox(),
  //                       items.length > 1
  //                           ? SizedBox(
  //                               child: Center(
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceEvenly,
  //                                   children: [
  //                                     // First card
  //                                     SizedBox(
  //                                       width:
  //                                           (MediaQuery.of(context).size.width -
  //                                                   30) /
  //                                               2,
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             vertical: 8),
  //                                         child: CustomItemCard(
  //                                           imageString: items[0] ==
  //                                                   AppStrings.apiKeyScanItems
  //                                               ? ImageAssets.scanYourItems
  //                                               : items[0] ==
  //                                                       AppStrings
  //                                                           .apiKeyListItems
  //                                                   ? ImageAssets.listAllItems
  //                                                   : ImageAssets.receiveGoods,
  //                                           title: items[0] ==
  //                                                   AppStrings.apiKeyScanItems
  //                                               ? AppStrings.scanYourItem
  //                                               : items[0] ==
  //                                                       AppStrings
  //                                                           .apiKeyListItems
  //                                                   ? AppStrings.listAllItems
  //                                                   : AppStrings.receiveGoods,
  //                                           backgroundColor: ColorManager.white,
  //                                           cornerRadius: 10,
  //                                           onTap: isLocationNull
  //                                               ? () {
  //                                                   globalUtils
  //                                                       .showNegativeSnackBar(
  //                                                     context: context,
  //                                                     message:
  //                                                         "Location Required",
  //                                                   );
  //                                                 }
  //                                               : () {
  //                                                   items[0] ==
  //                                                           AppStrings
  //                                                               .apiKeyScanItems
  //                                                       ? navigateToScanItems()
  //                                                       : items[0] ==
  //                                                               AppStrings
  //                                                                   .apiKeyListItems
  //                                                           ? navigateToListItems()
  //                                                           : navigateToReceiveGoods();
  //                                                 },
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 10),
  //                                     // Second card
  //                                     SizedBox(
  //                                       width:
  //                                           (MediaQuery.of(context).size.width -
  //                                                   30) /
  //                                               2,
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             vertical: 8),
  //                                         child: CustomItemCard(
  //                                           imageString: items[1] ==
  //                                                   AppStrings.apiKeyScanItems
  //                                               ? ImageAssets.scanYourItems
  //                                               : items[1] ==
  //                                                       AppStrings
  //                                                           .apiKeyListItems
  //                                                   ? ImageAssets.listAllItems
  //                                                   : ImageAssets.receiveGoods,
  //                                           title: items[1] ==
  //                                                   AppStrings.apiKeyScanItems
  //                                               ? AppStrings.scanYourItem
  //                                               : items[1] ==
  //                                                       AppStrings
  //                                                           .apiKeyListItems
  //                                                   ? AppStrings.listAllItems
  //                                                   : AppStrings.receiveGoods,
  //                                           backgroundColor: ColorManager.white,
  //                                           cornerRadius: 10,
  //                                           onTap: isLocationNull
  //                                               ? () {
  //                                                   globalUtils
  //                                                       .showNegativeSnackBar(
  //                                                     context: context,
  //                                                     message:
  //                                                         "Location Required",
  //                                                   );
  //                                                 }
  //                                               : () {
  //                                                   items[1] ==
  //                                                           AppStrings
  //                                                               .apiKeyScanItems
  //                                                       ? navigateToScanItems()
  //                                                       : items[1] ==
  //                                                               AppStrings
  //                                                                   .apiKeyListItems
  //                                                           ? navigateToListItems()
  //                                                           : navigateToReceiveGoods();
  //                                                 },
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             )
  //                           : items.isNotEmpty
  //                               ? SizedBox(
  //                                   width: (MediaQuery.of(context).size.width -
  //                                           30) /
  //                                       2,
  //                                   child: Center(
  //                                     child: Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.spaceEvenly,
  //                                       children: [
  //                                         CustomItemCard(
  //                                             imageString: items[0] ==
  //                                                     AppStrings.apiKeyScanItems
  //                                                 ? ImageAssets.scanYourItems
  //                                                 : items[0] ==
  //                                                         AppStrings
  //                                                             .apiKeyListItems
  //                                                     ? ImageAssets.listAllItems
  //                                                     : ImageAssets
  //                                                         .receiveGoods,
  //                                             title: items[0] ==
  //                                                     AppStrings.apiKeyScanItems
  //                                                 ? AppStrings.scanYourItem
  //                                                 : items[0] ==
  //                                                         AppStrings
  //                                                             .apiKeyListItems
  //                                                     ? AppStrings.listAllItems
  //                                                     : AppStrings.receiveGoods,
  //                                             backgroundColor:
  //                                                 ColorManager.white,
  //                                             cornerRadius: 10,
  //                                             onTap: isLocationNull
  //                                                 ? () {
  //                                                     globalUtils
  //                                                         .showNegativeSnackBar(
  //                                                             context: context,
  //                                                             message:
  //                                                                 "Location Required");
  //                                                   }
  //                                                 : () {
  //                                                     items[0] ==
  //                                                             AppStrings
  //                                                                 .apiKeyScanItems
  //                                                         ? navigateToScanItems()
  //                                                         : items[0] ==
  //                                                                 AppStrings
  //                                                                     .apiKeyListItems
  //                                                             ? navigateToListItems()
  //                                                             : navigateToReceiveGoods();
  //                                                   }),
  //                                         const Spacer(),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 )
  //                               : const SizedBox(),
  //                       //const SizedBox(height: 5),
  //                       items.length > 2
  //                           ? SizedBox(
  //                               child: Center(
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceEvenly,
  //                                   children: [
  //                                     CustomItemCard(
  //                                       imageString: items[2] ==
  //                                               AppStrings.apiKeyScanItems
  //                                           ? ImageAssets.scanYourItems
  //                                           : items[2] ==
  //                                                   AppStrings.apiKeyListItems
  //                                               ? ImageAssets.listAllItems
  //                                               : ImageAssets.receiveGoods,
  //                                       title: items[2] ==
  //                                               AppStrings.apiKeyScanItems
  //                                           ? AppStrings.scanYourItem
  //                                           : items[2] ==
  //                                                   AppStrings.apiKeyListItems
  //                                               ? AppStrings.listAllItems
  //                                               : AppStrings.receiveGoods,
  //                                       backgroundColor: ColorManager.white,
  //                                       cornerRadius: 10,
  //                                       onTap: isLocationNull
  //                                           ? () {
  //                                               globalUtils
  //                                                   .showNegativeSnackBar(
  //                                                 context: context,
  //                                                 message: "Location Required",
  //                                               );
  //                                             }
  //                                           : () {
  //                                               items[2] ==
  //                                                       AppStrings
  //                                                           .apiKeyScanItems
  //                                                   ? navigateToScanItems()
  //                                                   : items[2] ==
  //                                                           AppStrings
  //                                                               .apiKeyListItems
  //                                                       ? navigateToListItems()
  //                                                       : navigateToReceiveGoods();
  //                                             },
  //                                     ),
  //                                     const SizedBox(width: 8),
  //                                     // Show Blind Stock card only if inventoryManager is true
  //                                     if (inventoryManager == true) ...[
  //                                       SizedBox(
  //                                         width: (MediaQuery.of(context)
  //                                                     .size
  //                                                     .width -
  //                                                 30) /
  //                                             2,
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.symmetric(
  //                                               vertical: 8),
  //                                           child: Opacity(
  //                                             opacity: SharedPrefs()
  //                                                         .blindStockEdit ==
  //                                                     true
  //                                                 ? 1.0
  //                                                 : 0.5, // blur effect
  //                                             child: CustomItemCard(
  //                                               imageString: ImageAssets
  //                                                   .blindstocklisting,
  //                                               title: "Blind Stock Listing",
  //                                               backgroundColor:
  //                                                   ColorManager.white,
  //                                               cornerRadius: 10,
  //                                               onTap: () {
  //                                                 if (SharedPrefs()
  //                                                         .blindStockEdit !=
  //                                                     true) {
  //                                                   // Not allowed → show snackbar
  //                                                   globalUtils
  //                                                       .showNegativeSnackBar(
  //                                                     context: context,
  //                                                     message:
  //                                                         "You are not the Inventory Manager for this location.",
  //                                                   );
  //                                                   return;
  //                                                 }

  //                                                 if (isLocationNull) {
  //                                                   globalUtils
  //                                                       .showNegativeSnackBar(
  //                                                     context: context,
  //                                                     message:
  //                                                         "Location Required",
  //                                                   );
  //                                                   return;
  //                                                 }

  //                                                 // Allowed → navigate
  //                                                 Navigator.push(
  //                                                   context,
  //                                                   MaterialPageRoute(
  //                                                     builder: (context) =>
  //                                                         const BlindStockListView(),
  //                                                   ),
  //                                                 );
  //                                               },
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ] else ...[
  //                                       const Spacer(),
  //                                     ]
  //                                   ],
  //                                 ),
  //                               ),
  //                             )
  //                           : const SizedBox(),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        backgroundColor: ColorManager.darkBlue,
        toolbarHeight: 56,
        title: Text(
          AppStrings.dashboard,
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s20,
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            ImageAssets.menu,
            width: 20,
            height: 20,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: ColorManager.light3,
        child: Column(
          children: <Widget>[
            SizedBox(height: topPadding + 10),
            Image.asset(ImageAssets.splashLogo, width: 90, height: 72),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: ColorManager.blue, size: 20),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      displayUserName,
                      style: TextStyle(fontSize: 18, color: ColorManager.blue),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  border: Border.all(color: ColorManager.grey4, width: 1.0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menuItems.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: ColorManager.primary,
                        ),
                        itemBuilder: (context, index) {
                          final title = menuItems[index];
                          final icon =
                              menuIcons[title] ?? Icons.arrow_forward_ios;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.5),
                            child: MenuItemListTile(
                              title: title,
                              iconData: icon,
                              onTap: () {
                                navigateFromSideMenuAsPerSelectedTitle(title);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: logoutUser,
                      child: SizedBox(
                        height: 60,
                        width: displayWidth(context),
                        child: Column(
                          children: [
                            Container(height: 1, color: ColorManager.grey6),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ImageAssets.logoutIcon,
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  AppStrings.logout,
                                  style: getSemiBoldStyle(
                                    color: ColorManager.orange,
                                    fontSize: FontSize.s18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                SharedPrefs().mobileVersion,
                style: TextStyle(
                  fontSize: 13,
                  color: ColorManager.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isPermissionDenied
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      height: displayHeight(context) - 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: ColorManager.white,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image(
                              image: AssetImage(ImageAssets.permissionDenied),
                            ),
                          ),
                          SizedBox(
                            child: CenterTitleHeader(
                              titleText: AppStrings.permissionDeniedTitle,
                              detailText: AppStrings.permissionDeniedSubTitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 15),
                    child: Column(
                      children: [
                        // Region card
                        isRegionEnabled
                            ? CustomItemCardWithEdit(
                                imageString: ImageAssets.selectSite,
                                title: selectRegionTitle,
                                subtitle: selectedRegion!,
                                onEdit: isRegionEditable
                                    ? () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegionListView(
                                              selectedItem: selectedRegion!,
                                              selectedTitle: selectRegionTitle,
                                            ),
                                          ),
                                        );

                                        if (result != null) {
                                          setState(() {
                                            selectedRegion =
                                                SharedPrefs().selectedRegion;
                                            selectedRegionId =
                                                SharedPrefs().selectedRegionID;
                                          });
                                          fetchNewLocation(
                                              SharedPrefs().selectedRegionID);
                                        }
                                      }
                                    : () {},
                                backgroundColor: ColorManager.white,
                                cornerRadius: 10,
                                isEditable: isRegionEditable)
                            : const SizedBox(),
                        isRegionEnabled
                            ? const SizedBox(height: 8)
                            : const SizedBox(),

                        // Location card
                        isLocationEnabled
                            ? Visibility(
                                visible: !isFetchingLocation,
                                replacement: const Center(
                                    child: CustomProgressIndicator()),
                                child: CustomItemCardWithEdit(
                                    imageString: ImageAssets.selectLocation,
                                    title: selectLocationTitle,
                                    subtitle: selectedLocation ?? "",
                                    onEdit: isLocationEditable
                                        ? () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LocationListView(
                                                  selectedItem:
                                                      selectedLocation!,
                                                  selectedTitle:
                                                      selectLocationTitle,
                                                  selectedRegioId:
                                                      selectedRegionId!,
                                                ),
                                              ),
                                            );
                                            if (result != null) {
                                              setState(() {
                                                selectedLocation = SharedPrefs()
                                                    .selectedLocation;
                                              });
                                            }
                                          }
                                        : () {},
                                    backgroundColor: ColorManager.white,
                                    cornerRadius: 10,
                                    isEditable: isLocationEditable),
                              )
                            : const SizedBox(),

                        const SizedBox(height: 10),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.7,
                          children: [
                            // Scan Item
                            if (items.contains(AppStrings.apiKeyScanItems))
                              CustomItemCard(
                                imageString: ImageAssets.scanYourItems,
                                title: AppStrings.scanYourItem,
                                backgroundColor: ColorManager.white,
                                cornerRadius: 10,
                                onTap: isLocationNull
                                    ? () => globalUtils.showNegativeSnackBar(
                                          context: context,
                                          message: "Location Required",
                                        )
                                    : navigateToScanItems,
                              ),

                            // List Items
                            if (items.contains(AppStrings.apiKeyListItems))
                              CustomItemCard(
                                imageString: ImageAssets.listAllItems,
                                title: AppStrings.listAllItems,
                                backgroundColor: ColorManager.white,
                                cornerRadius: 10,
                                onTap: isLocationNull
                                    ? () => globalUtils.showNegativeSnackBar(
                                          context: context,
                                          message: "Location Required",
                                        )
                                    : navigateToListItems,
                              ),

                            // Receive Goods
                            if (items.contains(AppStrings.apiKeyReceiveGoods))
                              CustomItemCard(
                                imageString: ImageAssets.receiveGoods,
                                title: AppStrings.receiveGoods,
                                backgroundColor: ColorManager.white,
                                cornerRadius: 10,
                                onTap: isLocationNull
                                    ? () => globalUtils.showNegativeSnackBar(
                                          context: context,
                                          message: "Location Required",
                                        )
                                    : navigateToReceiveGoods,
                              ),

                            // Blind Stock
                            if (inventoryManager == true)
                              Opacity(
                                opacity: SharedPrefs().blindStockEdit == true
                                    ? 1.0
                                    : 0.5,
                                child: CustomItemCard(
                                  imageString: ImageAssets.blindstocklisting,
                                  title: "Blind Stock Listing",
                                  backgroundColor: ColorManager.white,
                                  cornerRadius: 10,
                                  onTap: () {
                                    if (SharedPrefs().blindStockEdit != true) {
                                      globalUtils.showNegativeSnackBar(
                                        context: context,
                                        message:
                                            "You are not designated as the Inventory Manager for ${SharedPrefs().selectedLocation} location.",
                                      );
                                      return;
                                    }
                                    if (isLocationNull) {
                                      globalUtils.showNegativeSnackBar(
                                        context: context,
                                        message: "Location Required",
                                      );
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BlindStockListView(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
