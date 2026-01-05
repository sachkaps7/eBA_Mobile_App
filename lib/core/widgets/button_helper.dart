// import 'package:eyvo_v3/core/resources/assets_manager.dart';
// import 'package:eyvo_v3/core/resources/color_manager.dart';
// import 'package:eyvo_v3/core/resources/font_manager.dart';
// import 'package:eyvo_v3/core/widgets/alert.dart';
// import 'package:eyvo_v3/core/widgets/button.dart';
// import 'package:flutter/material.dart';

// class ActionButtonsBase {
//   static Widget singleButton({
//     required BuildContext context,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       color: ColorManager.white,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: CustomTextActionButton(
//         buttonText: label,
//         backgroundColor: color,
//         borderColor: ColorManager.white,
//         fontColor: ColorManager.white,
//         fontSize: FontSize.s18,
//         buttonWidth: MediaQuery.of(context).size.width,
//         isBoldFont: true,
//         onTap: onTap,
//       ),
//     );
//   }

//   static Widget approveRejectButtons({
//     required BuildContext context,
//     required VoidCallback onApprove,
//     required Function(String reason) onReject,
//   }) {
//     return Container(
//       color: ColorManager.white,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: CustomTextActionButton(
//               buttonText: "Approve",
//               icon: Icons.thumb_up_outlined,
//               backgroundColor: ColorManager.green,
//               borderColor: ColorManager.white,
//               fontColor: ColorManager.white,
//               fontSize: FontSize.s18,
//               isBoldFont: true,
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) => CustomImageActionAlert(
//                     iconString: '',
//                     imageString: ImageAssets.common,
//                     titleString: "Confirm Approval",
//                     subTitleString: "Are you sure you want to approve?",
//                     destructiveActionString: "Yes",
//                     normalActionString: "No",
//                     onDestructiveActionTap: () {
//                       Navigator.pop(context);
//                       onApprove();
//                     },
//                     onNormalActionTap: () => Navigator.pop(context),
//                     isConfirmationAlert: true,
//                     isNormalAlert: true,
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: CustomTextActionButton(
//               buttonText: "Reject",
//               icon: Icons.thumb_down_outlined,
//               backgroundColor: ColorManager.red,
//               borderColor: ColorManager.white,
//               fontColor: ColorManager.white,
//               fontSize: FontSize.s18,
//               isBoldFont: true,
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) => CustomRejectReasonAlert(
//                     iconString: '',
//                     imageString: ImageAssets.rejection,
//                     titleString: "Please Add Reject Reason",
//                     rejectActionString: "Reject",
//                     cancelActionString: "Cancel",
//                     onCancelTap: () => Navigator.pop(context),
//                     onRejectTap: (reason) {
//                       Navigator.pop(context);
//                       onReject(reason);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderActionButtonsHelper {
//   static Widget buildButtons({
//     required BuildContext context,
//     required String status,
//     required String orderNumber,
//     required VoidCallback onApprove,
//     required Function(String reason) onReject,
//     required VoidCallback onSubmitForApproval,
//     required VoidCallback onIssueOrder,
//     required VoidCallback onReIssueOrder,
//   }) {
//     switch (status.toUpperCase()) {
//       case "TEMPLATE":
//       case "UNISSUED":
//       case "REJECTED":
//         return ActionButtonsBase.singleButton(
//           context: context,
//           label: "Submit For Approval",
//           color: ColorManager.blue,
//           onTap: onSubmitForApproval,
//         );

//       case "APPROVED":
//         return ActionButtonsBase.singleButton(
//           context: context,
//           label: "Issue Order",
//           color: ColorManager.blue,
//           onTap: onIssueOrder,
//         );

//       case "AMENDED":
//         return ActionButtonsBase.singleButton(
//           context: context,
//           label: "Re-Issue Order",
//           color: ColorManager.blue,
//           onTap: onReIssueOrder,
//         );

//       case "PENDING":
//         return ActionButtonsBase.approveRejectButtons(
//           context: context,
//           onApprove: onApprove,
//           onReject: onReject,
//         );

//       default:
//         return const SizedBox.shrink();
//     }
//   }
// }

// class RequestActionButtonsHelper {
//   static Widget buildButtons({
//     required BuildContext context,
//     required String status,
//     required VoidCallback onSubmitForApproval,
//     required VoidCallback onApprove,
//     required Function(String reason) onReject,
//     required VoidCallback onTakeOwnership,
//     required VoidCallback onCreateOrder,
//     required VoidCallback onEditRequest,
//   }) {
//     switch (status.toUpperCase()) {
//       case "DORMANT":
//         return ActionButtonsBase.singleButton(
//           context: context,
//           label: "Submit For Approval",
//           color: ColorManager.blue,
//           onTap: onSubmitForApproval,
//         );

//       case "UNAPPROVED":
//         return ActionButtonsBase.approveRejectButtons(
//           context: context,
//           onApprove: onApprove,
//           onReject: onReject,
//         );

//       case "PENDING BUYER":
//         return ActionButtonsBase.singleButton(
//           context: context,
//           label: "Take Ownership",
//           color: ColorManager.blue,
//           onTap: onTakeOwnership,
//         );

//       case "ASSIGNED":
//         return ActionButtonsBase.singleButton(
//           context: context,
//           label: "Create Order",
//           color: ColorManager.blue,
//           onTap: onCreateOrder,
//         );

//       case "REJECTED":
//         return ActionButtonsBase.singleButton(
//           context: context,
//           label: "Edit Request",
//           color: ColorManager.blue,
//           onTap: onEditRequest,
//         );

//       default:
//         return const SizedBox.shrink();
//     }
//   }
// }
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/widgets/alert.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:flutter/material.dart';

class DynamicOrderButtonBuilder {
  static Widget build({
    required BuildContext context,

    /// API values
    required String buttonName,
    required String buttonAction,
    required String buttonAlert,

    /// Action callbacks
    required VoidCallback onApprove,
    required Function(String reason) onReject,
    required VoidCallback onSubmitForApproval,
    required VoidCallback onIssueOrder,
    required VoidCallback onReIssueOrder,
  }) {
    final name = buttonName.trim().toUpperCase();
    final action = buttonAction.trim();

    // -------------------------------------------------------
    // CASE 1 — For APPROVE → Show two buttons: Approve + Reject
    // -------------------------------------------------------
    if (name == "APPROVE") {
      return Row(
        children: [
          Expanded(
            child: CustomTextActionButton(
              buttonText: "Approve",
              backgroundColor: ColorManager.green,
              fontColor: Colors.white,
              onTap: () {
                _showConfirmAlert(
                  context: context,
                  alertMessage: buttonAlert,
                  onYes: onApprove,
                );
              },
              borderColor: ColorManager.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomTextActionButton(
              buttonText: "Reject",
              backgroundColor: ColorManager.red,
              fontColor: Colors.white,
              onTap: () {
                _showRejectAlert(context, onReject);
              },
              borderColor: ColorManager.red,
            ),
          ),
        ],
      );
    }

    // -------------------------------------------------------
    // CASE 2 — For all other buttons → Single dynamic button
    // -------------------------------------------------------
    return CustomTextActionButton(
      buttonText: buttonName,
      backgroundColor: ColorManager.blue,
      fontColor: Colors.white,
      buttonWidth: MediaQuery.of(context).size.width,
      onTap: () {
        _showConfirmAlert(
          context: context,
          alertMessage: buttonAlert,
          onYes: () {
            _handleAction(
              action: action,
              onSubmitForApproval: onSubmitForApproval,
              onIssueOrder: onIssueOrder,
              onReIssueOrder: onReIssueOrder,
            );
          },
        );
      },
      borderColor: ColorManager.blue,
    );
  }

  // -------------------------------------------------------
  // SHOW NORMAL CONFIRMATION DIALOG (Yes / No)
  // -------------------------------------------------------
  static void _showConfirmAlert({
    required BuildContext context,
    required String alertMessage,
    required VoidCallback onYes,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomImageActionAlert(
          iconString: '',
          imageString: ImageAssets.common,
          titleString: "Orders",
          subTitleString: alertMessage,
          destructiveActionString: "Yes",
          normalActionString: "No",
          onDestructiveActionTap: () {
            Navigator.pop(context);
            onYes();
          },
          onNormalActionTap: () => Navigator.pop(context),
          isConfirmationAlert: true,
          isNormalAlert: true,
        );
      },
    );
  }

  // -------------------------------------------------------
  // SHOW REJECT DIALOG
  // -------------------------------------------------------
  static void _showRejectAlert(
      BuildContext context, Function(String reason) onReject) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomRejectReasonAlert(
          iconString: '',
          imageString: ImageAssets.rejection,
          titleString: "Please Add Reject Reason",
          rejectActionString: "Reject",
          cancelActionString: "Cancel",
          onCancelTap: () => Navigator.pop(context),
          onRejectTap: (reason) {
            Navigator.pop(context);
            onReject(reason);
          },
        );
      },
    );
  }

  // -------------------------------------------------------
  // ACTION HANDLER — Calls your callback based on API field
  // -------------------------------------------------------
  static void _handleAction({
    required String action,
    required VoidCallback onSubmitForApproval,
    required VoidCallback onIssueOrder,
    required VoidCallback onReIssueOrder,
  }) {
    switch (action) {
      case "SubmitForApproval":
        onSubmitForApproval();
        break;

      case "IssueOrder":
        onIssueOrder();
        break;

      case "ReIssueOrder":
        onReIssueOrder();
        break;

      default:
        // No action or unknown action
        break;
    }
  }
}
