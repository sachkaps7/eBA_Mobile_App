import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/switchboard_response.dart';
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
import 'package:eyvo_v3/core/widgets/custom_card_item.dart';
import 'package:eyvo_v3/core/widgets/custom_list_tile.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:eyvo_v3/core/widgets/setting_page.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/approval_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/create_order_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/create_request_view.dart';
import 'package:eyvo_v3/presentation/change_password/change_password.dart';
import 'package:eyvo_v3/presentation/home/home.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String displayUserName = SharedPrefs().displayUserName;
  List<String> menuItems = [];
  bool isLoginazureAd = SharedPrefs().isLoginazureAd;
  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isError = false;
  bool isRequestEnabled = false;
  bool isOrderEnabled = false;
  bool isExpenseEnabled = false;
  bool isInvoiceEnabled = false;
  bool isInventoryEnabled = false;
  bool isOrderApprovalEnabled = false;
  bool isExpenseApprovalEnabled = false;
  bool isInvoiceApprovalEnabled = false;
  bool isRequestApprovalEnabled = false;
  bool region = false;
  String selectRegionTitle = "";
  bool _isFirstLoad = true;
  String errorText = AppStrings.somethingWentWrong;
  final Map<String, IconData> menuIcons = {
    AppStrings.home: Icons.home_outlined,
    AppStrings.settings: Icons.settings_outlined,
    AppStrings.changePassword: Icons.lock_outlined,
  };

  @override
  void initState() {
    super.initState();
    fetchSwitchboardItems();
    menuItems = [AppStrings.inventory, AppStrings.settings];
    if (!isLoginazureAd) {
      menuItems.add(AppStrings.changePassword);
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_isFirstLoad) {
  //     _isFirstLoad = false;
  //   } else {
  //     fetchSwitchboardItems(); // Called when returning
  //   }
  // }

  // void fetchSwitchboardItems() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   Map<String, dynamic> requestData = {
  //     'uid': SharedPrefs().uID,
  //     'apptype': AppConstants.apptype,
  //   };

  //   final jsonResponse = await apiService.postRequest(
  //     context,
  //     ApiService.switchboard,
  //     requestData,
  //   );

  //   if (jsonResponse != null) {
  //     final response = SwitchboardResponse.fromJson(jsonResponse);

  //     if (response.code == 200) {
  //       final data = response.data;

  //       // Save to SharedPrefs
  //       SharedPrefs().requestFlag = data.request;
  //       SharedPrefs().orderFlag = data.order;
  //       SharedPrefs().expenseFlag = data.expense;
  //       SharedPrefs().invoiceFlag = data.invoice;
  //       SharedPrefs().inventoryFlag = data.inventory;
  //       SharedPrefs().region = data.region;
  //       SharedPrefs().selectRegionTitle = data.regionName!;

  //       // Read from SharedPrefs (to ensure sync with prefs)
  //       setState(() {
  //         isRequestEnabled = SharedPrefs().requestFlag;
  //         isOrderEnabled = SharedPrefs().orderFlag;
  //         isExpenseEnabled = SharedPrefs().expenseFlag;
  //         isInvoiceEnabled = SharedPrefs().invoiceFlag;
  //         isInventoryEnabled = SharedPrefs().inventoryFlag;
  //         region = SharedPrefs().region;
  //         selectRegionTitle = SharedPrefs().selectRegionTitle;
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isError = true;
  //         errorText = response.message.join(', ');
  //         isLoading = false;
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       isError = true;
  //       errorText = 'Something went wrong. Please try again.';
  //       isLoading = false;
  //     });
  //   }
  // }

  void fetchSwitchboardItems() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      'uid': SharedPrefs().uID,
      'apptype': AppConstants.apptype,
    };

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.switchboard,
      requestData,
    );

    if (jsonResponse != null) {
      final response = SwitchboardResponse.fromJson(jsonResponse);

      if (response.code == 200) {
        final data = response.data;

        // --------- Save SystemFunction ---------
        SharedPrefs().sysRequest = data.systemFunction.sysRequest;
        SharedPrefs().sysOrder = data.systemFunction.sysOrder;
        SharedPrefs().sysRFQ = data.systemFunction.sysRfq;
        SharedPrefs().sysExpense = data.systemFunction.sysExpense;
        SharedPrefs().sysRecipe = data.systemFunction.sysRecipe;
        SharedPrefs().sysInventory = data.systemFunction.sysInventory;
        SharedPrefs().sysPayments = data.systemFunction.sysPayments;
        SharedPrefs().sysPaymentApprover =
            data.systemFunction.sysPaymentApprover;
        SharedPrefs().sysRegionFunction = data.systemFunction.sysRegionFunction;
        SharedPrefs().sysRegionFunctionAvailable =
            data.systemFunction.sysRegionFunctionAvailable;
        SharedPrefs().sysRegionName = data.systemFunction.sysRegionName ?? "";
        SharedPrefs().sysRequestApproval =
            data.systemFunction.sysRequestApproval;
        SharedPrefs().sysRuleFunction = data.systemFunction.sysRuleFunction;
        SharedPrefs().sysRuleApproval = data.systemFunction.sysRuleApproval;
        SharedPrefs().sysCostCentreApproval =
            data.systemFunction.sysCostCentreApproval;
        SharedPrefs().sysGroupApproval = data.systemFunction.sysGroupApproval;

        // --------- Save UserPermissions ---------
        SharedPrefs().userRequest = data.userPermissions.userRequest;
        SharedPrefs().userOrder = data.userPermissions.userOrder;
        SharedPrefs().userRFQ = data.userPermissions.userRfq;
        SharedPrefs().userGR = data.userPermissions.userGr;
        SharedPrefs().userPayments = data.userPermissions.userPayments;
        SharedPrefs().userExpense = data.userPermissions.userExpense;
        SharedPrefs().userRecipe = data.userPermissions.userRecipe;
        SharedPrefs().userInventory = data.userPermissions.userInventory;

        // --------- Save UserApprovals ---------
        SharedPrefs().userRequestApproval =
            data.userApprovals.userRequestApproval;
        SharedPrefs().userOrderApproval = data.userApprovals.userOrderApproval;
        SharedPrefs().userInvoiceApproval =
            data.userApprovals.userInvoiceApproval;
        SharedPrefs().userExpenseApproval =
            data.userApprovals.userExpenseApproval;

        setState(() {
          isRequestApprovalEnabled = SharedPrefs().userRequestApproval;
          isOrderApprovalEnabled = SharedPrefs().userOrderApproval;
          isExpenseApprovalEnabled = SharedPrefs().userInvoiceApproval;
          isInvoiceApprovalEnabled = SharedPrefs().userExpenseApproval;
          isInventoryEnabled = SharedPrefs().sysInventory;
          isRequestEnabled = SharedPrefs().sysRequest;
          isOrderEnabled = SharedPrefs().sysOrder;

          //   region = SharedPrefs().sysRegionName;
          // selectRegionTitle = SharedPrefs().sysRegionName;

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
        errorText = 'Something went wrong. Please try again.';
        isLoading = false;
      });
    }
  }

  void navigateFromSideMenuAsPerSelectedTitle(String title) {
    if (title == AppStrings.dashboard) {
      navigateToScreen(context, HomeView());
    }
    if (title == AppStrings.changePassword) {
      navigateToScreen(context, const ChangePasswordView());
    }
    if (title == AppStrings.settings) {
      navigateToScreen(context, const SettingPage());
    }
  }

  void logoutUser() {
    SharedPrefs().isLoggedIn = false;
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.logOutRoute, (Route<dynamic> route) => false);
  }

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
                        style:
                            TextStyle(fontSize: 18, color: ColorManager.blue),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.5),
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
                                  Image.asset(ImageAssets.logoutIcon,
                                      width: 20, height: 20),
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
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    List<Widget> dashboardCards = [];

                    // Check if any approval type enabled
                    bool shouldShowApproval = isRequestApprovalEnabled ||
                        isOrderApprovalEnabled ||
                        isExpenseApprovalEnabled ||
                        isInvoiceApprovalEnabled;

                    if (isInventoryEnabled) {
                      dashboardCards.add(
                        CustomItemCardDashboard(
                          imageString: ImageAssets.inventory,
                          title: AppStrings.inventoryControl,
                          backgroundColor: ColorManager.white,
                          cornerRadius: 12,
                          onTap: () {
                            navigateToScreen(context, const InverntoryView());
                          },
                        ),
                      );
                    }

                    if (isRequestEnabled) {
                      dashboardCards.add(
                        CustomItemCardDashboard(
                          imageString: ImageAssets.requestMenu,
                          title: 'Request',
                          backgroundColor: ColorManager.white,
                          cornerRadius: 12,
                          onTap: () {
                            navigateToScreen(
                                context, const RequestListingPage());
                          },
                        ),
                      );
                    }

                    if (isOrderEnabled) {
                      dashboardCards.add(
                        CustomItemCardDashboard(
                          imageString: ImageAssets.orderMenu,
                          title: 'Order',
                          backgroundColor: ColorManager.white,
                          cornerRadius: 12,
                          onTap: () {
                            navigateToScreen(context, const OrderListingPage());
                          },
                        ),
                      );
                    }

                    if (shouldShowApproval) {
                      dashboardCards.add(
                        CustomItemCardDashboard(
                          imageString: ImageAssets.approval,
                          title: '${AppStrings.approval}\n',
                          backgroundColor: ColorManager.white,
                          cornerRadius: 12,
                          onTap: () {
                            navigateToScreen(context, const ApprovalView());
                          },
                        ),
                      );
                    }

                    if (dashboardCards.isEmpty) {
                      return Center(
                        child: Text(
                          'No dashboard items available.',
                          style: getMediumStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                      );
                    }

                    if (dashboardCards.length == 1) {
                      return SizedBox(
                        width: displayWidth(context),
                        child: dashboardCards[0],
                      );
                    }

                    if (dashboardCards.length == 2) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (displayWidth(context) - 42) / 2,
                            child: dashboardCards[0],
                          ),
                          SizedBox(
                            width: (displayWidth(context) - 42) / 2,
                            child: dashboardCards[1],
                          ),
                        ],
                      );
                    }

                
                    //  MORE THAN 2 → Wrap 2 per row
                
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: dashboardCards
                          .map((card) => SizedBox(
                                width: (displayWidth(context) - 42) / 2,
                                child: card,
                              ))
                          .toList(),
                    );
                  },
                ),
              )

        // body: isLoading
        //     ? const Center(child: CustomProgressIndicator())
        //     : Padding(
        //         padding: const EdgeInsets.all(16.0),
        //         child: Builder(
        //           builder: (context) {
        //             List<Widget> dashboardCards = [];

        //             // Only show Inventory Card
        //             if (isInventoryEnabled) {
        //               dashboardCards.add(
        //                 CustomItemCardDashboard(
        //                   imageString: ImageAssets.inventory,
        //                   title: AppStrings.inventoryControl,
        //                   backgroundColor: ColorManager.white,
        //                   cornerRadius: 12,
        //                   onTap: () {
        //                     navigateToScreen(context, const InverntoryView());
        //                   },
        //                 ),
        //               );
        //             }

        //             // Layout Logic
        //             if (dashboardCards.isEmpty) {
        //               return Center(
        //                 child: Text(
        //                   'No dashboard items available.',
        //                   style: getMediumStyle(
        //                     color: ColorManager.white,
        //                     fontSize: FontSize.s16,
        //                   ),
        //                 ),
        //               );
        //             }

        //             // If only Inventory card exists → full width
        //             return Row(
        //               children: [
        //                 Expanded(child: dashboardCards[0]),
        //               ],
        //             );
        //           },
        //         ),
        //       ),
        );
  }
}
