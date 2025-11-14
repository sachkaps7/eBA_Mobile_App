import 'package:eyvo_v3/core/widgets/approver_detailed_page.dart';
import 'package:eyvo_v3/core/widgets/generic_detail_api_page.dart';
import 'package:eyvo_v3/core/widgets/thankYouPage.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/approval_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/order_approval_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/order_details_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/request_approval_details.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/request_approval_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/show_group_approver_list.dart';
import 'package:eyvo_v3/features/auth/view/screens/dashboard/dashbord.dart';
import 'package:eyvo_v3/features/auth/view/screens/company_code/company_code.dart';
import 'package:eyvo_v3/features/logout/logout_page.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:eyvo_v3/presentation/change_password/change_password.dart';
import 'package:eyvo_v3/presentation/create_pin/create_pin.dart';
import 'package:eyvo_v3/presentation/pdf_view/pdf_view.dart';
import 'package:eyvo_v3/presentation/email_sent/email_sent.dart';
import 'package:eyvo_v3/presentation/enter_pin/enter_pin.dart';
import 'package:eyvo_v3/presentation/enter_user_id/enter_user_id.dart';
import 'package:eyvo_v3/presentation/forgot_password/forgot_password.dart';
import 'package:eyvo_v3/presentation/forgot_user_id/forgot_user_id.dart';
import 'package:eyvo_v3/presentation/home/home.dart';
import 'package:eyvo_v3/presentation/item_details/item_details.dart';
import 'package:eyvo_v3/presentation/item_list/item_list.dart';
import 'package:eyvo_v3/features/auth/view/screens/login/login.dart';
import 'package:eyvo_v3/presentation/location_list/location_list.dart';
import 'package:eyvo_v3/presentation/password_changed/password_changed.dart';
import 'package:eyvo_v3/presentation/pin_changed/pin_changed.dart';
import 'package:eyvo_v3/presentation/received_item_list/received_item_list.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/presentation/reset_password/reset_password.dart';
import 'package:eyvo_v3/presentation/select_order/select_order.dart';
import 'package:eyvo_v3/presentation/set_pin/set_pin.dart';
import 'package:eyvo_v3/presentation/site_list/region_list.dart';
import 'package:eyvo_v3/presentation/splash/splash.dart';
import 'package:eyvo_v3/presentation/verify_email/verify_email.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Routes {
  static const String splashRoute = "/";
  static const String companyCodeRoute = "/companyCode";
  static const String loginRoute = "/login";
  static const String forgotUserIDRoute = "/forgotUserID";
  static const String emailSentRoute = "/emailSent";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String enterUserIDRoute = "/enterUserID";
  static const String verifyEmailRoute = "/verifyEmail";
  static const String resetPasswordRoute = "/resetPassword";
  static const String passwordChangedRoute = "/passwordChanged";
  static const String pinChangedRoute = "/pinChanged";
  static const String createPINRoute = "/createPIN";
  static const String enterPINRoute = "/enterPIN";
  static const String setPINRoute = "/setPIN";
  static const String homeRoute = "/home";
  static const String inventoryRoute = "/inventory";
  static const String changePasswordRoute = "/changePassword";
  static const String regionListRoute = "/regionList";
  static const String locationListRoute = "/locationList";
  static const String itemDetailsRoute = "/itemDetails";
  static const String itemsInOutRoute = "/itemsInOut";
  static const String itemListRoute = "/itemList";
  static const String selectOrderRoute = "/selectOrder";
  static const String searchOrderRoute = "/searchOrder";
  static const String receivedItemListRoute = "/receivedItemList";
  static const String pdfViewRoute = "/pdfView";
  static const String approvalRoute = "/approvalView";
  static const String requestApprovalRoute = "/requestApprovalView";
  static const String requestApprovalDetailsRoute = "/RequestDetailsView";
  static const String orderApproverPage = "/orderApproverPage";
  static const String orderDetailsView = "/orderDetailsView";
  static const String genericDetailRoute = "/genericDetailPage";
  static const String genericDetailAPIRoute = "/genericDetailAPIPage";
  static const String thankYouRoute = "/thankYou";
  static const String showGroupApprovalListRoute = "/showGroupApprovalList";
  static const String logOutRoute = "/logOutPage";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    LoggerData.dataLog('Navigate Screen : $routeSettings');
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.companyCodeRoute:
        return MaterialPageRoute(builder: (_) => const CompanyCodeView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginViewPage());
      case Routes.forgotUserIDRoute:
        return MaterialPageRoute(
            builder: (_) => const ForgotUserIDView(), fullscreenDialog: true);
      case Routes.emailSentRoute:
        return MaterialPageRoute(
            builder: (_) => const EmailSentView(), fullscreenDialog: true);
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(
            builder: (_) => const ForgotPasswordView(), fullscreenDialog: true);
      case Routes.enterUserIDRoute:
        return MaterialPageRoute(
            builder: (_) => const EnterUserIDView(), fullscreenDialog: true);
      case Routes.verifyEmailRoute:
        return MaterialPageRoute(
            builder: (_) => const VerifyEmailView(userName: ''),
            fullscreenDialog: true);
      case Routes.resetPasswordRoute:
        return MaterialPageRoute(
            builder: (_) => const ResetPasswordView(), fullscreenDialog: true);
      case Routes.passwordChangedRoute:
        return MaterialPageRoute(builder: (_) => const PasswordChangedView());
      case Routes.pinChangedRoute:
        return MaterialPageRoute(builder: (_) => const PinChangedView());
      case Routes.createPINRoute:
        return MaterialPageRoute(builder: (_) => const CreatePINView());
      case Routes.enterPINRoute:
        return MaterialPageRoute(builder: (_) => const EnterPINView());
      case Routes.setPINRoute:
        return MaterialPageRoute(builder: (_) => const SetPINView());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case Routes.inventoryRoute:
        return MaterialPageRoute(builder: (_) => const InverntoryView());
      case Routes.approvalRoute:
        return MaterialPageRoute(builder: (_) => const ApprovalView());
      case Routes.requestApprovalRoute:
        return MaterialPageRoute(builder: (_) => const RequestApprovalPage());
      case Routes.requestApprovalDetailsRoute:
        return MaterialPageRoute(
            builder: (_) => const RequestDetailsView(
                  requestId: 0,
                  requestNumber: '',
                ));
      case Routes.orderApproverPage:
        return MaterialPageRoute(builder: (_) => const OrderApproverPage());
      case Routes.orderDetailsView:
        return MaterialPageRoute(
          builder: (_) => const OrderDetailsView(
            orderId: 0,
            orderNumber: '0',
          ),
        );
      case Routes.genericDetailRoute:
        final args = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => GenericDetailPage(
            title: args['title'],
            data: args['data'],
          ),
        );

      case Routes.thankYouRoute:
        final args = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ThankYouPage(
              message: args['message'] ?? '',
              approverName: args['approverName'] ?? '',
              status: args['status'] ?? '',
              requestName: args['requestName'] ?? '',
              number: args['number'] ?? ''),
        );

      case Routes.showGroupApprovalListRoute:
        final args = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ShowGroupApprovalList(
            id: args['id'],
            from: args['from'],
          ),
        );

      case Routes.changePasswordRoute:
        return MaterialPageRoute(builder: (_) => const ChangePasswordView());
      case Routes.regionListRoute:
        return MaterialPageRoute(
            builder: (_) =>
                const RegionListView(selectedItem: '', selectedTitle: ''));
      case Routes.locationListRoute:
        return MaterialPageRoute(
            builder: (_) => const LocationListView(
                  selectedItem: '',
                  selectedTitle: '',
                  selectedRegioId: 0,
                ));
      case Routes.itemDetailsRoute:
        return MaterialPageRoute(
            builder: (_) => const ItemDetailsView(itemId: 0));
      case Routes.itemListRoute:
        return MaterialPageRoute(builder: (_) => const ItemListView());
      case Routes.selectOrderRoute:
        return MaterialPageRoute(builder: (_) => const SelectOrderView());
      case Routes.receivedItemListRoute:
        return MaterialPageRoute(
            builder: (_) => const ReceivedItemListView(
                  orderNumber: '',
                  orderId: 0,
                ));
      case Routes.pdfViewRoute:
        return MaterialPageRoute(
            builder: (_) => const PDFViewScreen(
                  orderNumber: '',
                  orderId: 0,
                  itemId: 0,
                  grNo: "",
                ));
      case Routes.logOutRoute:
        return MaterialPageRoute(builder: (_) => LogOutPage());
      case Routes.genericDetailAPIRoute:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => GenericDetailAPIPage(
            title: args['title'] ?? '',
            id: args['id'],
            type: args['type'],
            lineId: args['lineId'],
          ),
        );
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(
                child: Text(AppStrings.noRouteFound),
              ),
            ));
  }
}
