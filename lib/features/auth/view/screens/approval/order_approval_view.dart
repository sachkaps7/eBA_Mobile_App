import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/order_approval_list_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/custom_card_item.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/features/auth/view/screens/approval/order_details_view.dart';
import 'package:flutter/material.dart';

class OrderApproverPage extends StatefulWidget {
  const OrderApproverPage({super.key});

  @override
  State<OrderApproverPage> createState() => _OrderApproverPageState();
}

class _OrderApproverPageState extends State<OrderApproverPage> with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();

  List<OrderApprovalItem> orderApprovalList = [];
  List<OrderApprovalItem> filteredRequests = [];

  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void initState() {
    super.initState();
    fetchOrderApprovalList();
    _searchController.addListener(_filterRequests);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back from a pushed page
    fetchOrderApprovalList();
  }

  void fetchOrderApprovalList() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      'uid': SharedPrefs().uID,
    };

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.orderApprovalList,
      requestData,
    );

    if (jsonResponse != null) {
      final response = OrderApprovalListResponse.fromJson(jsonResponse);

      if (response.code == 200) {
        setState(() {
          orderApprovalList = response.data;
          filteredRequests = response.data;
          isLoading = false;
          isError = false;
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
        errorText = 'Something went wrong. Please try again.';
        isLoading = false;
      });
    }
  }

  void _filterRequests() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredRequests = orderApprovalList.where((order) {
        return order.orderNumber.toLowerCase().contains(query) ||
            order.orderStatus.toLowerCase().contains(query);
      }).toList();
    });
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
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
          AppStrings.orderApproval,
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
          IconButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                fetchOrderApprovalList();
                filteredRequests = orderApprovalList;
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isError
              ? Center(child: Text(errorText))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: CustomSearchField(
                        controller: _searchController,
                        placeholderText: 'Search by order number or status',
                        inputType: TextInputType.text,
                      ),
                    ),
                    Expanded(
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbColor:
                              WidgetStateProperty.all(ColorManager.darkBlue),
                          trackColor: WidgetStateProperty.all(
                              ColorManager.primary.withOpacity(0.2)),
                          thickness: WidgetStateProperty.all(6),
                          radius: const Radius.circular(8),
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: filteredRequests.length,
                            itemBuilder: (context, index) {
                              final order = filteredRequests[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 0),
                                child: CommonCardWidget(
                                  subtitles: [
                                    {'Order No': order.orderNumber},
                                    {'Status': order.orderStatus},
                                    {'Order Date': order.orderDate},
                                    {
                                      'Order Net Total':
                                          '${getFormattedPriceString(order.orderValue)}'
                                    },
                                  ],
                                  onTap: () {
                                    navigateToScreen(
                                      context,
                                      OrderDetailsView(
                                          orderId: order.orderId,
                                          orderNumber: order.orderNumber),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
