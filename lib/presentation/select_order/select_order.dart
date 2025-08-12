// import 'dart:async';

// import 'package:eyvo_inventory/api/api_service/api_service.dart';
// import 'package:eyvo_inventory/api/response_models/order_response.dart';
// import 'package:eyvo_inventory/app/app_prefs.dart';
// import 'package:eyvo_inventory/app/sizes_helper.dart';
// import 'package:eyvo_inventory/core/resources/assets_manager.dart';
// import 'package:eyvo_inventory/core/resources/color_manager.dart';
// import 'package:eyvo_inventory/core/resources/constants.dart';
// import 'package:eyvo_inventory/core/resources/font_manager.dart';
// import 'package:eyvo_inventory/core/resources/strings_manager.dart';
// import 'package:eyvo_inventory/core/resources/styles_manager.dart';
// import 'package:eyvo_inventory/core/utils.dart';
// import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
// import 'package:eyvo_inventory/core/widgets/custom_field.dart';
// import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
// import 'package:eyvo_inventory/presentation/received_item_list/received_item_list.dart';
// import 'package:flutter/material.dart';

// class SelectOrderView extends StatefulWidget {
//   const SelectOrderView({super.key});

//   @override
//   State<SelectOrderView> createState() => _SelectOrderViewState();
// }

// class _SelectOrderViewState extends State<SelectOrderView> {
//   Timer? _debounce;
//   late ScrollController _scrollController;
//   final TextEditingController searchController = TextEditingController();
//   bool isSearching = false;
//   bool isLoading = false;
//   bool isLoadMore = false;
//   String searchText = '';
//   final ApiService apiService = ApiService();
//   late List<Order> orderItems = [];
//   bool isError = false;
//   String errorText = AppStrings.somethingWentWrong;
//   int page = 1;
//   int totalRecords = AppConstants.totalRecords;
//   int pageSize = AppConstants.pageSize;

//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(_onSearchChanged);
//     _scrollController = ScrollController()..addListener(_scrollListener);
//     fetchOrders(false);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       fetchOrders(true);
//     }
//   }

//   void fetchOrders(bool isLoadingMoreItems) async {
//     if (isLoading || isLoadMore || orderItems.length >= totalRecords) return;
//     setState(() {
//       isLoading = !isLoadingMoreItems && !isSearching;
//       isLoadMore = isLoadingMoreItems;
//     });

//     Map<String, dynamic> data = {
//       'uid': SharedPrefs().uID,
//       'search': searchController.text,
//       'regionid': SharedPrefs().selectedRegionID,
//       'pageno': page,
//       'pagesize': AppConstants.pageSize
//     };
//     final jsonResponse = await apiService.postRequest(
//         context, ApiService.goodReceiveOrderList, data);
//     if (jsonResponse != null) {
//       final response = OrderResponse.fromJson(jsonResponse);
//       if (response.code == '200') {
//         setState(() {
//           isError = false;
//           if (isLoadingMoreItems) {
//             orderItems.addAll(response.data);
//           } else {
//             orderItems = response.data;
//           }
//           totalRecords = response.totalRecords;
//           page++;
//         });
//       } else {
//         orderItems = [];
//         isError = true;
//         errorText = response.message.join(', ');
//       }
//     }

//     setState(() {
//       isLoading = false;
//       isSearching = false;
//       isLoadMore = false;
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   _onSearchChanged() {
//     if ((searchController.text.length >= 3 &&
//             searchText != searchController.text &&
//             searchController.text.isNotEmpty) ||
//         searchText.isNotEmpty) {
//       setState(() {
//         searchText = searchController.text;
//         isSearching = true;
//         page = 1;
//         totalRecords = 10000000;
//       });
//       if (_debounce?.isActive ?? false) _debounce?.cancel();
//       _debounce = Timer(const Duration(milliseconds: 550), () {
//         fetchOrders(false);
//       });
//     }
//   }

//   String getNormalizedStatus(String? status) {
//     return (status != null && status.trim().isNotEmpty)
//         ? status.trim().toUpperCase()
//         : 'REJECTED';
//   }

//   Color getStatusColor(String? status) {
//     switch (getNormalizedStatus(status)) {
//       case 'UNISSUED':
//         return const Color(0xFF09AF00);
//       case 'ISSUED':
//         return const Color(0xFF1976D2);
//       case 'PARTIAL':
//         return const Color(0xFF4DD0E1);
//       case 'CLOSED':
//         return const Color(0xFF8D6E63);
//       case 'REJECTED':
//         return const Color(0xFFC62809);
//       case 'PENDING':
//         return const Color(0xFFF57F17);
//       case 'APPROVED':
//         return const Color(0xFFAFB42B);
//       case 'AMENDED':
//         return const Color(0xFFA07C03);
//       case 'CANCELLED':
//         return const Color(0xFFB0BEC5);
//       default:
//         return Colors.grey;
//     }
//   }

// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         FocusScope.of(context).unfocus();
// //       },
// //       child: Scaffold(
// //         backgroundColor: ColorManager.primary,
// //         appBar: buildCommonAppBar(
// //           context: context,
// //           title: AppStrings.selectOrder,
// //         ),
// //         body: isLoading && !isSearching
// //             ? const Center(child: CustomProgressIndicator())
// //             : Padding(
// //                 padding: const EdgeInsets.all(18.0),
// //                 child: Column(
// //                   children: [
// //                     const SizedBox(height: 10),
// //                     CustomSearchField(
// //                         controller: searchController,
// //                         placeholderText: AppStrings.searchOrderNumber),
// //                     const SizedBox(height: 10),
// //                     isError
// //                         ? Expanded(
// //                             child: Container(
// //                               height: displayHeight(context) * 0.65,
// //                               width: displayWidth(context),
// //                               decoration: BoxDecoration(
// //                                   borderRadius: BorderRadius.circular(8),
// //                                   color: ColorManager.white),
// //                               child: Center(
// //                                   child: Column(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 crossAxisAlignment: CrossAxisAlignment.center,
// //                                 children: [
// //                                   const Spacer(),
// //                                   Image.asset(
// //                                       width: displayWidth(context) * 0.5,
// //                                       ImageAssets.noRecordFoundIcon),
// //                                   Text(errorText,
// //                                       style: getRegularStyle(
// //                                           color: ColorManager.lightGrey,
// //                                           fontSize: FontSize.s17)),
// //                                   const Spacer()
// //                                 ],
// //                               )),
// //                             ),
// //                           )
// //                         : Expanded(
// //                             child: Container(
// //                               decoration: BoxDecoration(
// //                                 color: ColorManager.white,
// //                               ),
// //                               child: orderItems.isEmpty &&
// //                                       !isLoading &&
// //                                       !isLoadMore
// //                                   ? Center(
// //                                       child: Text(
// //                                         errorText,
// //                                         style: getRegularStyle(
// //                                             color: ColorManager.black,
// //                                             fontSize: FontSize.s27),
// //                                       ),
// //                                     )
// //                                   : NotificationListener<ScrollNotification>(
// //                                       onNotification:
// //                                           (ScrollNotification notification) {
// //                                         if (notification
// //                                             is ScrollStartNotification) {
// //                                           FocusScope.of(context).unfocus();
// //                                         }
// //                                         return false;
// //                                       },
// //                                       child: ListView.separated(
// //                                         controller: _scrollController,
// //                                         itemCount: orderItems.length + 1,
// //                                         separatorBuilder: (context, index) =>
// //                                             Column(
// //                                           children: [
// //                                             const SizedBox(height: 2),
// //                                             Container(
// //                                               height: 6,
// //                                               color: ColorManager.primary,
// //                                             ),
// //                                             const SizedBox(height: 2),
// //                                           ],
// //                                         ),
// //                                         itemBuilder: (context, index) {
// //                                           if (index == orderItems.length) {
// //                                             if (orderItems.length >=
// //                                                 totalRecords) {
// //                                               return const SizedBox();
// //                                             }
// //                                             return const Center(
// //                                                 child:
// //                                                     CustomProgressIndicator());
// //                                           }
// //                                           return Padding(
// //                                             padding: const EdgeInsets.all(4.0),
// //                                             child: ListTile(
// //                                               title: Row(
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment
// //                                                         .spaceBetween,
// //                                                 crossAxisAlignment:
// //                                                     CrossAxisAlignment.center,
// //                                                 children: [
// //                                                   Expanded(
// //                                                     child: Align(
// //                                                       alignment:
// //                                                           Alignment.centerLeft,
// //                                                       child: Text(
// //                                                         orderItems[index]
// //                                                             .orderNumber,
// //                                                         style: getSemiBoldStyle(
// //                                                           color: ColorManager
// //                                                               .black,
// //                                                           fontSize:
// //                                                               FontSize.s21,
// //                                                         ),
// //                                                       ),
// //                                                     ),
// //                                                   ),
// //                                                   Column(
// //                                                     crossAxisAlignment:
// //                                                         CrossAxisAlignment.end,
// //                                                     children: [
// //                                                       // Date
// //                                                       SizedBox(
// //                                                         width: 100,
// //                                                         child: Align(
// //                                                           alignment: Alignment
// //                                                               .centerRight,
// //                                                           child: Text(
// //                                                             orderItems[index]
// //                                                                     .date ??
// //                                                                 '14-Jan-2025',
// //                                                             style:
// //                                                                 getRegularStyle(
// //                                                               color: ColorManager
// //                                                                   .lightGrey1,
// //                                                               fontSize:
// //                                                                   FontSize.s16,
// //                                                             ),
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                       const SizedBox(height: 4),

// //                                                       // Status
// //                                                       SizedBox(
// //                                                         width: 90,
// //                                                         child: Container(
// //                                                           padding:
// //                                                               const EdgeInsets
// //                                                                   .symmetric(
// //                                                                   horizontal:
// //                                                                       8.0,
// //                                                                   vertical:
// //                                                                       4.0),
// //                                                           decoration:
// //                                                               BoxDecoration(
// //                                                             color: getStatusColor(
// //                                                                 orderItems[
// //                                                                         index]
// //                                                                     .status),
// //                                                             borderRadius:
// //                                                                 BorderRadius
// //                                                                     .circular(
// //                                                                         10),
// //                                                           ),
// //                                                           child: Align(
// //                                                             alignment: Alignment
// //                                                                 .centerRight,
// //                                                             child: Center(
// //                                                               child: Text(
// //                                                                 orderItems[index]
// //                                                                         .status ??
// //                                                                     'REJECTED',
// //                                                                 style:
// //                                                                     getSemiBoldStyle(
// //                                                                   color: Colors
// //                                                                       .white,
// //                                                                   fontSize:
// //                                                                       FontSize
// //                                                                           .s14,
// //                                                                 ),
// //                                                                 textAlign:
// //                                                                     TextAlign
// //                                                                         .right,
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                               onTap: () {
// //                                                 navigateToScreen(
// //                                                   context,
// //                                                   ReceivedItemListView(
// //                                                     orderNumber:
// //                                                         orderItems[index]
// //                                                             .orderNumber,
// //                                                     orderId: orderItems[index]
// //                                                         .orderId,
// //                                                   ),
// //                                                 );
// //                                               },
// //                                             ),
// //                                           );
// //                                         },
// //                                       ),
// //                                     ),
// //                             ),
// //                           ),
// //                   ],
// //                 ),
// //               ),
// //       ),
// //     );
// //   }
// // }
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: ColorManager.primary,
//         appBar: buildCommonAppBar(
//           context: context,
//           title: AppStrings.selectOrder,
//         ),
//         body: isLoading && !isSearching
//             ? const Center(child: CustomProgressIndicator())
//             : Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 8),
//                     CustomSearchField(
//                       controller: searchController,
//                       placeholderText: AppStrings.searchOrderNumber,
//                     ),
//                     const SizedBox(height: 8),
//                     isError
//                         ? Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(18.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: ColorManager.white,
//                                 ),
//                                 child: Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Image.asset(
//                                         ImageAssets.noRecordFoundIcon,
//                                         width: displayWidth(context) * 0.5,
//                                       ),
//                                       Text(
//                                         errorText,
//                                         style: getRegularStyle(
//                                           color: ColorManager.lightGrey,
//                                           fontSize: FontSize.s17,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Expanded(
//                             child: Container(
//                               child: orderItems.isEmpty &&
//                                       !isLoading &&
//                                       !isLoadMore
//                                   ? Center(
//                                       child: Text(
//                                         errorText,
//                                         style: getRegularStyle(
//                                           color: ColorManager.black,
//                                           fontSize: FontSize.s20,
//                                         ),
//                                       ),
//                                     )
//                                   : NotificationListener<ScrollNotification>(
//                                       onNotification:
//                                           (ScrollNotification notification) {
//                                         if (notification
//                                             is ScrollStartNotification) {
//                                           FocusScope.of(context).unfocus();
//                                         }
//                                         return false;
//                                       },
//                                       child: ListView.separated(
//                                         controller: _scrollController,
//                                         itemCount: orderItems.length + 1,
//                                         separatorBuilder: (context, index) =>
//                                             Divider(
//                                           color: ColorManager.primary,
//                                           height: 2,
//                                           thickness: 2,
//                                         ),
//                                         itemBuilder: (context, index) {
//                                           if (index == orderItems.length) {
//                                             if (orderItems.length >=
//                                                 totalRecords) {
//                                               return const SizedBox();
//                                             }
//                                             return const Center(
//                                               child: CustomProgressIndicator(),
//                                             );
//                                           }

//                                           return Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0,
//                                               vertical: 4.0,
//                                             ),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 color: ColorManager.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(6),
//                                               ),
//                                               child: ListTile(
//                                                 dense: true,
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 6),
//                                                 title: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Expanded(
//                                                       child: Align(
//                                                         alignment: Alignment
//                                                             .centerLeft,
//                                                         child: Text(
//                                                           orderItems[index]
//                                                               .orderNumber,
//                                                           style:
//                                                               getSemiBoldStyle(
//                                                             color: ColorManager
//                                                                 .black,
//                                                             fontSize:
//                                                                 FontSize.s16,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .end,
//                                                       children: [
//                                                         // Date
//                                                         SizedBox(
//                                                           width: 90,
//                                                           child: Align(
//                                                             alignment: Alignment
//                                                                 .centerRight,
//                                                             child: Text(
//                                                               orderItems[index]
//                                                                       .date ??
//                                                                   '14-Jan-2025',
//                                                               style:
//                                                                   getRegularStyle(
//                                                                 color: ColorManager
//                                                                     .lightGrey1,
//                                                                 fontSize:
//                                                                     FontSize
//                                                                         .s12,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                             height: 4),

//                                                         // Status
//                                                         SizedBox(
//                                                           width: 75,
//                                                           child: Container(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .symmetric(
//                                                                     horizontal:
//                                                                         6.0,
//                                                                     vertical:
//                                                                         2.0),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: getStatusColor(
//                                                                   orderItems[
//                                                                           index]
//                                                                       .status),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           8),
//                                                             ),
//                                                             child: Center(
//                                                               child: Text(
//                                                                 orderItems[index]
//                                                                         .status ??
//                                                                     'REJECTED',
//                                                                 style:
//                                                                     getSemiBoldStyle(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontSize:
//                                                                       FontSize
//                                                                           .s12,
//                                                                 ),
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .center,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 onTap: () {
//                                                   navigateToScreen(
//                                                     context,
//                                                     ReceivedItemListView(
//                                                       orderNumber:
//                                                           orderItems[index]
//                                                               .orderNumber,
//                                                       orderId: orderItems[index]
//                                                           .orderId,
//                                                     ),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/order_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/constants.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/presentation/received_item_list/received_item_list.dart';
import 'package:flutter/material.dart';

class SelectOrderView extends StatefulWidget {
  const SelectOrderView({super.key});

  @override
  State<SelectOrderView> createState() => _SelectOrderViewState();
}

class _SelectOrderViewState extends State<SelectOrderView> {
  Timer? _debounce;
  late ScrollController _scrollController;
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isLoading = false;
  bool isLoadMore = false;
  String searchText = '';
  final ApiService apiService = ApiService();
  late List<OrderData> orderItems = [];
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  int page = 1;
  int totalRecords = AppConstants.totalRecords;
  int pageSize = AppConstants.pageSize;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _scrollController = ScrollController()..addListener(_scrollListener);
    fetchOrders(false);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchOrders(true);
    }
  }

  void fetchOrders(bool isLoadingMoreItems) async {
    if (isLoading || isLoadMore || orderItems.length >= totalRecords) return;
    setState(() {
      isLoading = !isLoadingMoreItems && !isSearching;
      isLoadMore = isLoadingMoreItems;
    });

    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
      'search': searchController.text,
      'regionid': SharedPrefs().selectedRegionID,
      'pageno': page,
      'pagesize': AppConstants.pageSize
    };

    final jsonResponse = await apiService.postRequest(
        context, ApiService.goodReceiveOrderList, data);

    if (jsonResponse != null) {
      final response = OrderResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          isError = false;
          if (isLoadingMoreItems) {
            orderItems.addAll(response.data ?? []);
          } else {
            orderItems = response.data ?? [];
          }
          totalRecords = response.totalRecords ?? 0;
          page++;
        });
      } else {
        orderItems = [];
        isError = true;
        errorText =
            response.message?.join(', ') ?? AppStrings.somethingWentWrong;
      }
    }

    setState(() {
      isLoading = false;
      isSearching = false;
      isLoadMore = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if ((searchController.text.length >= 3 &&
            searchText != searchController.text &&
            searchController.text.isNotEmpty) ||
        searchText.isNotEmpty) {
      setState(() {
        searchText = searchController.text;
        isSearching = true;
        page = 1;
        totalRecords = 10000000;
      });
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 550), () {
        fetchOrders(false);
      });
    }
  }

  String getNormalizedStatus(String? status) {
    return (status != null && status.trim().isNotEmpty)
        ? status.trim().toUpperCase()
        : 'REJECTED';
  }

  Color getStatusColor(String? status) {
    switch (getNormalizedStatus(status)) {
      case 'UNISSUED':
        return const Color(0xFF09AF00);
      case 'ISSUED':
        return const Color(0xFF1976D2);
      case 'PARTIAL':
        return const Color(0xFF4DD0E1);
      case 'CLOSED':
        return const Color(0xFF8D6E63);
      case 'REJECTED':
        return const Color(0xFFC62809);
      case 'PENDING':
        return const Color(0xFFF57F17);
      case 'APPROVED':
        return const Color(0xFFAFB42B);
      case 'RECEIVED':
        return const Color(0xFFA07C03);
      case 'CANCELLED':
        return const Color(0xFFB0BEC5);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: buildCommonAppBar(
          context: context,
          title: AppStrings.selectOrder,
        ),
        body: isLoading && !isSearching
            ? const Center(child: CustomProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    CustomSearchField(
                      controller: searchController,
                      placeholderText: AppStrings.searchOrderNumber,
                    ),
                    const SizedBox(height: 8),
                    isError
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorManager.white,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageAssets.noRecordFoundIcon,
                                        width: displayWidth(context) * 0.5,
                                      ),
                                      Text(
                                        errorText,
                                        style: getRegularStyle(
                                          color: ColorManager.lightGrey,
                                          fontSize: FontSize.s17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              child: orderItems.isEmpty &&
                                      !isLoading &&
                                      !isLoadMore
                                  ? Center(
                                      child: Text(
                                        errorText,
                                        style: getRegularStyle(
                                          color: ColorManager.black,
                                          fontSize: FontSize.s20,
                                        ),
                                      ),
                                    )
                                  : NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification notification) {
                                        if (notification
                                            is ScrollStartNotification) {
                                          FocusScope.of(context).unfocus();
                                        }
                                        return false;
                                      },
                                      child: ListView.separated(
                                        controller: _scrollController,
                                        itemCount: orderItems.length + 1,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          color: ColorManager.primary,
                                          height: 2,
                                          thickness: 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          if (index == orderItems.length) {
                                            if (orderItems.length >=
                                                totalRecords) {
                                              return const SizedBox();
                                            }
                                            return const Center(
                                              child: CustomProgressIndicator(),
                                            );
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorManager.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: ListTile(
                                                dense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              orderItems[index]
                                                                      .orderNumber ??
                                                                  '',
                                                              style:
                                                                  getSemiBoldStyle(
                                                                color:
                                                                    ColorManager
                                                                        .black,
                                                                fontSize:
                                                                    FontSize
                                                                        .s16,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                            const SizedBox(
                                                                height: 2),
                                                            Text(
                                                              orderItems[index]
                                                                      .supplierName ??
                                                                  '',
                                                              style:
                                                                  getRegularStyle(
                                                                color: ColorManager
                                                                    .lightGrey,
                                                                fontSize:
                                                                    FontSize
                                                                        .s14,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        // Date
                                                        SizedBox(
                                                          width: 90,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              orderItems[index]
                                                                      .orderDate ??
                                                                  '',
                                                              style:
                                                                  getRegularStyle(
                                                                color: ColorManager
                                                                    .lightGrey1,
                                                                fontSize:
                                                                    FontSize
                                                                        .s12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),

                                                        // Status
                                                        SizedBox(
                                                          width: 75,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6.0,
                                                                    vertical:
                                                                        2.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: getStatusColor(
                                                                  orderItems[
                                                                          index]
                                                                      .orderStatus),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                orderItems[index]
                                                                        .orderStatus ??
                                                                    'REJECTED',
                                                                style:
                                                                    getSemiBoldStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      FontSize
                                                                          .s12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  navigateToScreen(
                                                    context,
                                                    ReceivedItemListView(
                                                      orderNumber: orderItems[
                                                                  index]
                                                              .orderNumber ??
                                                          '',
                                                      orderId: orderItems[index]
                                                              .orderId ??
                                                          0,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
