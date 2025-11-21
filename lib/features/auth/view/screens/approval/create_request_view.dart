import 'dart:async';

import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/create_order_request_response.dart';
import 'package:eyvo_v3/api/response_models/request_approval_list_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/app/sizes_helper.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/routes_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/alert.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/custom_card_item.dart';
import 'package:eyvo_v3/core/widgets/custom_field.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/create_order_details.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/create_request_details.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/order_details_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/request_approval_details.dart';
import 'package:flutter/material.dart';

class RequestListingPage extends StatefulWidget {
  const RequestListingPage({super.key});

  @override
  State<RequestListingPage> createState() => _RequestListingPageState();
}

class _RequestListingPageState extends State<RequestListingPage> with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final ApiService apiService = ApiService();

  List<Datum> requestlList = [];
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  String searchText = '';
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    fetchrequestlList();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Trigger search if ≥3 characters or cleared
    if (_searchController.text.length >= 3 || _searchController.text.isEmpty) {
      if (searchText != _searchController.text) {
        searchText = _searchController.text;
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          fetchrequestlList();
        });
      }
    }
  }

  void fetchrequestlList() async {
    setState(() {
      isLoading = true;
      isError = false;
      requestlList.clear();
    });

    Map<String, dynamic> requestData = {
      'uid': SharedPrefs().uID,
      'apptype': AppConstants.apptype,
      'search': _searchController.text,
    };

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.requestList,
      requestData,
    );

    if (jsonResponse != null) {
      final response = RequestApprovalListResponse.fromJson(jsonResponse);

      if (response.code == 200) {
        setState(() {
          requestlList = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          isError = true;
          errorText = response.message.join(', ');
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isError = true;
        errorText = AppStrings.somethingWentWrong;
        isLoading = false;
      });
    }
  }

  Future<void> createRequest() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    Map<String, dynamic> requestData = {
      'uid': SharedPrefs().uID,
      'apptype': AppConstants.apptype,
      "group": "request",
      "regionid": 1,
      "userSession": "",
    };

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.createrequest,
      requestData,
    );

    if (jsonResponse != null) {
      final response = OrderRequestCreateResponse.fromJson(jsonResponse);

      if (response.code == 200) {
        // SUCCESS
        setState(() {
          isLoading = false;
        });

        showSnackBar(context, "Request created successfully");

        navigateToScreen(
          context,
          RequestDetailsView(
            requestId: int.parse(response.data),
          ),
        );
      } else {
        // API returned an error
        setState(() {
          isError = true;
          errorText = response.message.join(", ");
          isLoading = false;
        });
      }
    } else {
      // Null response (server/error)
      setState(() {
        isError = true;
        errorText = AppStrings.somethingWentWrong;
        isLoading = false;
      });
    }
  }

  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          if (_showSearchBar) ...[
            // Expanded search bar
            Expanded(
              child: CustomSearchField(
                controller: _searchController,
                placeholderText: AppStrings.searchOrderNumber,
                inputType: TextInputType.text,
                autoFocus: true,
              ),
            ),
            const SizedBox(width: 8),
            // Close button
            IconButton(
              icon: Icon(Icons.close, color: ColorManager.black),
              onPressed: () {
                setState(() {
                  _showSearchBar = false;
                  _searchController.clear();
                });
              },
            ),
          ] else ...[
            // Compact search field
            Flexible(
              flex: 1,
              child: CustomSearchField(
                controller: _searchController,
                placeholderText: AppStrings.searchItems,
                inputType: TextInputType.text,
                autoFocus: false,
                readOnly: true,
                onTap: () {
                  setState(() => _showSearchBar = true);
                },
              ),
            ),
            const SizedBox(width: 10),

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomImageActionAlert(
                      iconString: '',
                      imageString: ImageAssets.common,
                      titleString: "Requests",
                      subTitleString:
                          "Are you sure you want to create a request?",
                      destructiveActionString: "Yes",
                      normalActionString: "No",
                      onDestructiveActionTap: () {
                        createRequest();
                        Navigator.of(context).pop();
                      },
                      onNormalActionTap: () {
                        Navigator.of(context).pop();
                      },
                      isConfirmationAlert: true,
                      isNormalAlert: true,
                    );
                  },
                );
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: ColorManager.blue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        backgroundColor: ColorManager.darkBlue,
        titleSpacing: -10,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Requests',
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s20,
          ),
        ),
        leading: IconButton(
          icon: SizedBox(
            width: 18,
            height: 18,
            child: Image.asset(ImageAssets.backButton),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Refresh Button
          IconButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                fetchrequestlList();
              });
            },
            icon: Icon(Icons.refresh, color: ColorManager.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildSearchRow(),
          ),

          // Loading
          if (isLoading)
            const Expanded(child: Center(child: CustomProgressIndicator()))

          // Error
          else if (isError)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageAssets.noRecordFoundIcon,
                      width: displayWidth(context) * 0.5,
                    ),
                    const SizedBox(height: 10),
                    Text(errorText),
                  ],
                ),
              ),
            )

          // No Data
          else if (requestlList.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageAssets.noRecordFoundIcon,
                      width: displayWidth(context) * 0.5,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "No Records Found",
                      style: getRegularStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s17,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: requestlList.length,
                itemBuilder: (context, index) {
                  final request = requestlList[index];
                  return GenericCardWidget(
                    titleKey: 'Request #${request.requestNumber}',
                    statusKey: request.requestStatus,
                    // supplierKey: 'Tanuja Patil',
                    dateKey: request.entryDate,
                    valueKey: getFormattedPriceString(request.requestValue),
                    valueNameKey: 'Request Value',
                    itemCountKey: request.itemCount.toString(),
                    onTap: () {
                      navigateToScreen(
                        context,
                        RequestDetailsView(
                          requestId: request.requestId,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
