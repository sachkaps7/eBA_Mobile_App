import 'dart:async';

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/item_list_response.dart';
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
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/custom_list_tile.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/presentation/item_details/item_details.dart';
import 'package:flutter/material.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> with RouteAware {
  late ScrollController _scrollController;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  late List<ListItem> listItems = [];
  bool isListViewSelected = true;
  bool isSearching = false;
  bool isLoading = false;
  bool isLoadMore = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  final ApiService apiService = ApiService();
  int page = 1;
  int totalRecords = AppConstants.totalRecords;
  int pageSize = AppConstants.pageSize;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController = ScrollController()..addListener(_scrollListener);
    fetchListItems(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    page = 1;
    listItems = [];
    fetchListItems(false);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchListItems(true);
    }
  }

  _onSearchChanged() {
    if ((_searchController.text.length >= 3 &&
            searchText != _searchController.text &&
            _searchController.text.isNotEmpty) ||
        searchText.isNotEmpty) {
      setState(() {
        searchText = _searchController.text;
        isSearching = true;
        page = 1;
        totalRecords = 100;
      });
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 550), () {
        fetchListItems(false);
      });
    }
  }

  void fetchListItems(bool isLoadingMoreItems) async {
    if (isLoading || isLoadMore || listItems.length >= totalRecords) return;
    setState(() {
      isLoading = !isLoadingMoreItems && !isSearching;
      isLoadMore = isLoadingMoreItems;
    });
    Map<String, dynamic> data = {
      "regionid": SharedPrefs().selectedRegionID,
      "locationid": SharedPrefs().selectedLocationID,
      "search": _searchController.text,
      'pageno': page,
      'pagesize': AppConstants.pageSize
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.itemsListing, data);
    if (jsonResponse != null) {
      final response = ItemListResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          isError = false;
          if (isLoadingMoreItems) {
            listItems.addAll(response.data);
          } else {
            listItems = response.data;
          }
          totalRecords = response.totalRecords;
          page++;
        } else {
          isError = true;
          errorText = response.message.join(', ');
        }
      });
    }

    // var res = await globalBloc.doFetchItemList(
    //   context,
    //   regionId: SharedPrefs().selectedRegionID,
    //   locationId: SharedPrefs().selectedLocationID,
    //   search: _searchController.text,
    //   pageNo: page,
    //   pageSize: AppConstants.pageSize,
    // );
    // setState(() {
    //   if (res.code == '200') {
    //     isError = false;
    //     if (isLoadingMoreItems) {
    //       listItems.addAll(res.data);
    //     } else {
    //       listItems = res.data;
    //     }
    //     totalRecords = res.totalRecords;
    //     page++;
    //   } else {
    //     isError = true;
    //     errorText = res.message.join(', ');
    //   }
    // });

    setState(() {
      isLoading = false;
      isSearching = false;
      isLoadMore = false;
    });
  }

  void navigateToItemDetails(ListItem selectedItem) {
    navigateToScreen(context, ItemDetailsView(itemId: selectedItem.itemId));
  }

  @override
  Widget build(BuildContext context) {
    const double sidePadding = 18;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: buildCommonAppBar(
          context: context,
          title: AppStrings.itemListing,
        ),
        body: SafeArea(
          child: isLoading && !isSearching
              ? const Center(child: CustomProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomSearchField(
                              controller: _searchController,
                              placeholderText: AppStrings.searchItems,
                              inputType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              IconButton(
                                icon: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(isListViewSelected
                                      ? ImageAssets.boxSelectedIcon
                                      : ImageAssets.boxIcon),
                                ),
                                onPressed: () {
                                  setState(() => isListViewSelected = true);
                                },
                              ),
                              const SizedBox(width: 5),
                              Container(
                                color: ColorManager.lightBlue2,
                                height: 35,
                                width: 2,
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                icon: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(isListViewSelected
                                      ? ImageAssets.gridIcon
                                      : ImageAssets.gridSelectedIcon),
                                ),
                                onPressed: () {
                                  setState(() => isListViewSelected = false);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: sidePadding, vertical: 8),
                              child: listItems.isEmpty &&
                                      !isLoading &&
                                      !isLoadMore
                                  ? Center(
                                      child: Text(
                                        errorText,
                                        style: getRegularStyle(
                                          color: ColorManager.black,
                                          fontSize: FontSize.s27,
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
                                      child: isListViewSelected
                                          ? ListView.builder(
                                              controller: _scrollController,
                                              itemCount: listItems.length +
                                                  (isLoading ||
                                                          listItems.length >=
                                                              totalRecords
                                                      ? 0
                                                      : 1),
                                              itemBuilder: (context, index) {
                                                if (index == listItems.length) {
                                                  return const Center(
                                                      child:
                                                          CustomProgressIndicator());
                                                }
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      navigateToItemDetails(
                                                          listItems[index]);
                                                    },
                                                    child: ItemListTile(
                                                      title: listItems[index]
                                                          .outline,
                                                      subtitle1:
                                                          listItems[index]
                                                              .itemCode,
                                                      subtitle2:
                                                          listItems[index]
                                                              .categoryCode,
                                                      subtitle3:
                                                          getFormattedPriceString(
                                                              listItems[index]
                                                                  .stockCount),
                                                      imageString:
                                                          listItems[index]
                                                              .itemImage,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : GridView.builder(
                                              controller: _scrollController,
                                              itemCount: listItems.length +
                                                  (isLoading ||
                                                          listItems.length >=
                                                              totalRecords
                                                      ? 0
                                                      : 1),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 8.0,
                                                mainAxisSpacing: 8.0,
                                                childAspectRatio: 0.9,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              itemBuilder: (context, index) {
                                                if (index == listItems.length) {
                                                  return const SizedBox(
                                                    height:
                                                        100, // or match the height of a grid item
                                                    width: double.infinity,
                                                    child: Center(
                                                      child:
                                                          CustomProgressIndicator(),
                                                    ),
                                                  );
                                                }

                                                return GestureDetector(
                                                  onTap: () {
                                                    navigateToItemDetails(
                                                        listItems[index]);
                                                  },
                                                  child: ItemGridTile(
                                                    title: listItems[index]
                                                        .outline,
                                                    subtitle1: listItems[index]
                                                        .itemCode,
                                                    subtitle2: listItems[index]
                                                        .categoryCode,
                                                    subtitle3:
                                                        getFormattedPriceString(
                                                            listItems[index]
                                                                .stockCount),
                                                    imageString:
                                                        listItems[index]
                                                            .itemImage,
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
