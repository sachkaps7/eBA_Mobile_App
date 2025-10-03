import 'dart:developer';
import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/request_approval_details_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/approval_details_helper.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class RequestDetailsView extends StatefulWidget {
  final int requestId;

  const RequestDetailsView({Key? key, required this.requestId})
      : super(key: key);

  @override
  State<RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView> {
  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;

  Data? requestDetails;
  String? expandedSection;

  @override
  void initState() {
    super.initState();
    expandedSection = "Details"; // default expanded section
    fetchRequestApprovalDetails();
  }

  Future<void> fetchRequestApprovalDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.requestApprovalDetails,
      {'uid': SharedPrefs().uID, 'requestId': widget.requestId},
    );

    if (jsonResponse != null) {
      final resp = RequestApprovalDetailsResponse.fromJson(jsonResponse);
      if (resp.code == 200 && resp.data != null) {
        setState(() {
          requestDetails = resp.data;
          isLoading = false;
        });
        return;
      } else {
        errorText = resp.message?.join(', ') ?? "Failed to fetch data";
      }
    } else {
      errorText = "No response from server";
    }

    setState(() {
      isError = true;
      isLoading = false;
    });
  }

  // Future<void> requestApprovalApprove() async {
  //   setState(() => isLoading = true);

  //   final jsonResponse = await apiService.postRequest(
  //     context,
  //     ApiService.requestApprovalApprove,
  //     {'uid': SharedPrefs().uID, 'requestId': widget.requestId},
  //   );

  //   if (jsonResponse != null) {
  //     if (jsonResponse['code'] == 200) {
  //       Navigator.pushReplacementNamed(
  //         context,
  //         Routes.thankYouRoute,
  //         arguments: {
  //           'message': "Request approved successfully",
  //           'status': "Request Approved",
  //           'number': requestDetails?.header.requestNumber ?? "",
  //         },
  //       );
  //     } else {
  //       showErrorDialog(context, jsonResponse['message'].toString(), false);
  //     }
  //   } else {
  //     showErrorDialog(context, "No response from server", false);
  //   }

  //   setState(() => isLoading = false);
  // }

  // Future<void> requestApprovalReject(String reason) async {
  //   setState(() => isLoading = true);

  //   final jsonResponse = await apiService.postRequest(
  //     context,
  //     ApiService.requestApprovalReject,
  //     {'uid': SharedPrefs().uID, 'requestId': widget.requestId, 'reason': reason},
  //   );

  //   if (jsonResponse != null) {
  //     if (jsonResponse['code'] == 200) {
  //       Navigator.pushReplacementNamed(
  //         context,
  //         Routes.thankYouRoute,
  //         arguments: {
  //           'message': "Request rejected successfully",
  //           'status': "Request Rejected",
  //           'number': requestDetails?.header.requestNumber ?? "",
  //         },
  //       );
  //     } else {
  //       showErrorDialog(context, jsonResponse['message'].toString(), false);
  //     }
  //   } else {
  //     showErrorDialog(context, "No response from server", false);
  //   }

  //   setState(() => isLoading = false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: "#Request No ${widget.requestId}",
      ),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isError
              ? Center(child: Text(errorText))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // -------------------- DETAILS --------------------
                            ApprovalDetailsHelper.buildSectionForDetails(
                              "Details",
                              Icons.description_outlined,
                              {
                                'Request No':
                                    requestDetails!.header.requestNumber,
                                'Entry Date': requestDetails!.header.entryDate,
                                'Request Status':
                                    requestDetails!.header.requestStatus,
                                'Request Net Total':
                                    '${requestDetails!.header.grossTotal}(${requestDetails!.header.headerCcyCode})',
                                'Approver Name':
                                    requestDetails!.header.originatorName,
                              },
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.genericDetailRoute,
                                  arguments: {
                                    'title': 'Request Header',
                                    'data': {
                                      'Request No': requestDetails!
                                              .header.requestNumber ??
                                          '',
                                      'Entry Date':
                                          requestDetails!.header.entryDate ??
                                              '',
                                      'Request Status': requestDetails!
                                              .header.requestStatus ??
                                          '',
                                      'Ref Num':
                                          requestDetails!.header.referenceNo ??
                                              '',
                                      'Instructions':
                                          requestDetails!.header.instructions ??
                                              '',
                                      'Delivery Code':
                                          requestDetails!.header.deliveryCode ??
                                              '',
                                      requestDetails!.header.expName1:
                                          requestDetails!.header.expCode1 ?? '',
                                    },
                                  },
                                );
                              },
                              isExpanded: expandedSection == "Details",
                              toggleSection: () => setState(() {
                                expandedSection = expandedSection == "Details"
                                    ? null
                                    : "Details";
                              }),
                            ),

                            // -------------------- LINE ITEMS --------------------

                            ApprovalDetailsHelper.buildSection(
                              "Line Items",
                              Icons.list_alt_outlined,
                              (requestDetails?.line?.isEmpty ?? true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No line items")
                                    ]
                                  : requestDetails!.line!.map((lineItem) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCardWithEditIcon({
                                        'Item': lineItem.itemCode,
                                        'Description': lineItem.description,
                                        'Quantity': lineItem.quantity,
                                        'Unit Price':
                                            '${getFormattedPriceString(lineItem.price)}(${lineItem.supplierCcyCode})',
                                        'Net Price':
                                            '${getFormattedPriceString(lineItem.netPrice)}(${lineItem.supplierCcyCode})',
                                      }, () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.genericDetailRoute,
                                          arguments: {
                                            'title': 'Request Line',
                                            'data': {
                                              //  'Item Order': lineItem.itemOrder,
                                              'Item Code': lineItem.itemCode,
                                              'Item Description':
                                                  lineItem.description,
                                              'Suppliers Part No':
                                                  lineItem.suppliersPartNo ??
                                                      'N/A',
                                              'Item Due Date': lineItem.dueDate,
                                              'Quantity': lineItem.quantity,
                                              'Unit': lineItem.unit,
                                              'Pack Size': lineItem.packSize,
                                              'Unit Price':
                                                  '${getFormattedPriceString(lineItem.price)}(${lineItem.supplierCcyCode})',
                                              'Discount': lineItem
                                                          .discountType ==
                                                      1
                                                  ? '${lineItem.discount}(value)'
                                                  : '${lineItem.discount}(%)',
                                              'Tax': lineItem.tax,
                                              'Tax Value': lineItem.taxValue,
                                              // 'Net Price':
                                              //     '${getFormattedPriceString(lineItem.netPrice)}(${lineItem.supplierCcyCode})',
                                              // 'Gross Price':
                                              //     '${getFormattedPriceString(lineItem.grossPrice)}(${lineItem.supplierCcyCode})',
                                              //  '${lineItem.expName4}': lineItem.expCode4,
                                              //'Shipping Charges': ,
                                              //'Supplier Ccy Rate': lineItem.supplierCcyRate,
                                            },
                                          },
                                        );
                                      });
                                    }).toList(),
                              count: requestDetails?.line?.length ?? 0,
                              isExpanded: expandedSection == "Line Items",
                              toggleSection: () => setState(() {
                                expandedSection =
                                    expandedSection == "Line Items"
                                        ? null
                                        : "Line Items";
                              }),
                            ),

// -------------------- RULES --------------------
                            ApprovalDetailsHelper.buildSection(
                              "Rules",
                              Icons.rule,
                              (requestDetails?.rule?.isEmpty ?? true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No rules")
                                    ]
                                  : requestDetails!.rule!.map((r) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCard({
                                        'Rule Name': r.ruleName,
                                        'Rule Description': r.ruleDescription,
                                        'Rule Selected':
                                            r.ruleSelected ? 'Yes' : 'No',
                                      });
                                    }).toList(),
                              count: requestDetails?.rule?.length ?? 0,
                              isExpanded: expandedSection == "Rules",
                              toggleSection: () => setState(() {
                                expandedSection =
                                    expandedSection == "Rules" ? null : "Rules";
                              }),
                            ),

// -------------------- RULE APPROVERS --------------------
                            ApprovalDetailsHelper.buildSection(
                              "Rule Approvers",
                              Icons.person_outline,
                              (requestDetails?.ruleApprovers?.isEmpty ?? true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No rule approvers")
                                    ]
                                  : requestDetails!.ruleApprovers!.map((ra) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCard({
                                        'Approval Order': ra.approvalOrder,
                                        'User Name': ra.userName,
                                        'Group': ra.userGroupName,
                                        'Status': ra.approvalStatus,
                                        'Proxy User': ra.proxyUserName,
                                      });
                                    }).toList(),
                              count: requestDetails?.ruleApprovers?.length ?? 0,
                              isExpanded: expandedSection == "Rule Approvers",
                              toggleSection: () => setState(() {
                                expandedSection =
                                    expandedSection == "Rule Approvers"
                                        ? null
                                        : "Rule Approvers";
                              }),
                            ),

                            // -------------------- COST CENTERS --------------------
                            ApprovalDetailsHelper.buildSection(
                              "Cost Center Split",
                              Icons.account_balance_wallet_outlined,
                              (requestDetails?.costCenter?.isEmpty ?? true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No cost center data"),
                                    ]
                                  : requestDetails!.costCenter!.map((cc) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCard({
                                        'Cost Center Code': cc.costCode,
                                        'Description': cc.costDescription,
                                        'Split Percentage':
                                            '${cc.splitPercentage}%',
                                        'Split Value': getFormattedPriceString(
                                            cc.splitValue),
                                      });
                                    }).toList(),
                              count: requestDetails?.costCenter?.length ?? 0,
                              isExpanded: expandedSection == "Cost Centers",
                              toggleSection: () => setState(() {
                                expandedSection =
                                    expandedSection == "Cost Centers"
                                        ? null
                                        : "Cost Centers";
                              }),
                            ),

// -------------------- ATTACHMENTS --------------------
                            ApprovalDetailsHelper.buildSection(
                              "Attachments",
                              Icons.attach_file,
                              (requestDetails?.attachedDocument?.isEmpty ??
                                      true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No attachments")
                                    ]
                                  : requestDetails!.attachedDocument!
                                      .map((doc) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCard(doc);
                                    }).toList(),
                              count:
                                  requestDetails?.attachedDocument?.length ?? 0,
                              isExpanded: expandedSection == "Attachments",
                              toggleSection: () => setState(() {
                                expandedSection =
                                    expandedSection == "Attachments"
                                        ? null
                                        : "Attachments";
                              }),
                            ),
// -------------------- EVENT LOG --------------------
                            ApprovalDetailsHelper.buildSection(
                              "Event Log",
                              Icons.event_note,
                              (requestDetails?.log?.isEmpty ?? true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No logs")
                                    ]
                                  : requestDetails!.log!.map((log) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCard({
                                        'Event Date': log.eventDate,
                                        'User': log.eventUser,
                                        'Event': log.event,
                                      });
                                    }).toList(),
                              count: requestDetails?.log?.length ?? 0,
                              isExpanded: expandedSection == "Event Log",
                              toggleSection: () => setState(() {
                                expandedSection = expandedSection == "Event Log"
                                    ? null
                                    : "Event Log";
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // -------------------- APPROVE / REJECT BUTTONS --------------------
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: CustomTextActionButton(
                    //           buttonText: "Approve",
                    //           icon: Icons.thumb_up,
                    //           backgroundColor: ColorManager.green,
                    //           onTap: () => requestApprovalApprove(),
                    //           borderColor: null,
                    //           fontColor: null,
                    //         ),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       Expanded(
                    //         child: CustomTextActionButton(
                    //           buttonText: "Reject",
                    //           icon: Icons.thumb_down,
                    //           backgroundColor: ColorManager.red,
                    //           onTap: () {
                    //             showDialog(
                    //               context: context,
                    //               builder: (_) => CustomRejectReasonAlert(
                    //                 titleString: "Enter reject reason",
                    //                 rejectActionString: "Reject",
                    //                 cancelActionString: "Cancel",
                    //                 onRejectTap: (reason) {
                    //                   Navigator.pop(context);
                    //                   requestApprovalReject(reason);
                    //                 },
                    //                 onCancelTap: () => Navigator.pop(context),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
    );
  }
}
