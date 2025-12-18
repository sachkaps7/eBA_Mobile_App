import 'dart:developer';
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/header_response.dart';
import 'package:eyvo_v3/api/response_models/request_approval_details_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/routes_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/alert.dart';
import 'package:eyvo_v3/core/widgets/approval_details_helper.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/button_helper.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/base_header_form_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/base_line_form_view.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';

class RequestDetailsView extends StatefulWidget {
  final int requestId;

  const RequestDetailsView({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  State<RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView>
    with RouteAware {
  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  HeaderLineData? requestHeaderList;
  Data? requestDetails;
  String? expandedSection;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(
      this,
      ModalRoute.of(context)! as PageRoute,
    );
  }

  @override
  void didPopNext() {
    fetchRequestApprovalDetails();
  }

  @override
  void initState() {
    super.initState();
    expandedSection = "Details"; // default expanded section
    fetchRequestApprovalDetails();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> fetchRequestApprovalDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.requestApprovalDetails,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'requestId': widget.requestId
      },
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

  Future<HeaderLineData?> fetchRequestHeaderApprovalList() async {
    Map<String, dynamic> requestData = {
      'uid': SharedPrefs().uID, 'apptype': AppConstants.apptype,
      'Request_ID': widget.requestId, // Use actual requestId
    };

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.requestApprovalList,
      requestData,
    );

    if (jsonResponse != null) {
      final response = HeaderListResponse.fromJson(jsonResponse);

      if (response.code == 200) {
        return response.headerlineData; //return directly
      } else {
        showErrorDialog(context, response.message.join(', '), false);
        return null;
      }
    } else {
      showErrorDialog(
          context, 'Something went wrong. Please try again.', false);
      return null;
    }
  }

  Future<void> requestApprovalApprove() async {
    setState(() => isLoading = true);

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.requestApprovalApproved,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'requestId': widget.requestId
      },
    );

    if (jsonResponse != null) {
      if (jsonResponse['code'] == 200) {
        Navigator.pushReplacementNamed(
          context,
          Routes.thankYouRoute,
          arguments: {
            'message': "Request approved successfully",
            'status': "Request Approved",
            'number': requestDetails?.header.requestNumber ?? "",
          },
        );
      } else {
        showErrorDialog(context, jsonResponse['message'].toString(), false);
      }
    } else {
      showErrorDialog(context, "No response from server", false);
    }

    setState(() => isLoading = false);
  }

  Future<void> requestApprovalReject(String reason) async {
    setState(() => isLoading = true);

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.requestApprovalReject,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'requestId': widget.requestId,
        'reason': reason
      },
    );

    if (jsonResponse != null) {
      if (jsonResponse['code'] == 200) {
        Navigator.pushReplacementNamed(
          context,
          Routes.thankYouRoute,
          arguments: {
            'message': "Request rejected successfully",
            'status': "Request Rejected",
            'number': requestDetails?.header.requestNumber ?? "",
          },
        );
      } else {
        showErrorDialog(context, jsonResponse['message'].toString(), false);
      }
    } else {
      showErrorDialog(context, "No response from server", false);
    }

    setState(() => isLoading = false);
  }

  Future<void> _editRequest() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
  }

  Future<void> _submitForApproval() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
  }

  Future<void> _takeOwnership() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
  }

  Future<void> _createOrderFromRequest() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      Routes.thankYouRoute,
      arguments: {
        'message': "Request submitted for approval successfully",
        'approverName': 'requestApproval',
        'status': 'Submitted',
        'requestName': 'Request Number',
        'number': requestDetails!.header.requestNumber,
      },
    );

    setState(() {
      isLoading = false;
      isError = true;
    });
  }

  Future<void> _issueOrder() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      Routes.thankYouRoute,
      arguments: {
        'message': "Order issued successfully",
        'approverName': 'orderApproval',
        'status': 'Order Issued',
        'requestName': 'Order Number',
        'number': requestDetails!.header.requestNumber,
      },
    );

    setState(() {
      isLoading = false;
      isError = true;
    });
  }

  Future<void> _reIssueOrder() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      Routes.thankYouRoute,
      arguments: {
        'message': "Request re-issued successfully",
        'approverName': 'orderApproval',
        'status': 'Request Re-Issued',
        'requestName': 'Request Number',
        'number': requestDetails!.header.requestNumber,
      },
    );

    setState(() {
      isLoading = false;
      isError = true;
    });
  }

  bool _shouldShowAddItem() {
    if (requestDetails?.header?.requestStatus == null) return false;

    final status = requestDetails?.header?.requestStatus.toUpperCase();

    bool isValidStatus = status == 'DORMANT' ||
        status == 'REJECTED' ||
        status == 'TEMPLATE' ||
        status == 'REJECTED';

    return isValidStatus && SharedPrefs().userRequest == "RW";
  }

  void _addNewNotes() {
    Navigator.pushNamed(context, Routes.notesViewRoute);
  }

  void _addNewAttachment() {
    Navigator.pushNamed(context, Routes.attachmentPageRoute);
  }

  void _deleteCostCenterSplit() {
    LoggerData.dataPrint("Delete pressed");
    // Add your API or logic here
  }

  void _addNewLineItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaseLineView(
          id: widget.requestId,
          lineId: 0,
          lineType: LineType.order,
          appBarTitle: "Request Line",
          buttonshow: true,
        ),
      ),
    ).then((_) {
      // Refresh after adding
      fetchRequestApprovalDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: requestDetails == null
            ? "Request Details"
            : "Request #${requestDetails!.header.requestNumber}",
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
// --------------------------------------------------------------- DETAILS ---------------------------------------------------------------
                            ApprovalDetailsHelper
                                .buildSectionForDetailsWithEditIcon(
                              "Details",
                              Icons.description_outlined,
                              {
                                'Request No':
                                    requestDetails!.header.requestNumber,
                                'Entry Date': requestDetails!.header.entryDate,
                                'Request Status':
                                    requestDetails!.header.requestStatus,
                                'Request Net Total':
                                    '${requestDetails!.header.grossTotal} (${requestDetails!.header.headerCcyCode})',
                                'Approver Name':
                                    requestDetails!.header.originatorName,
                              },
                              // onTap: () {
                              //   Navigator.pushNamed(
                              //     context,
                              //     Routes.genericDetailRoute,
                              //     arguments: {
                              //       'title': 'Request Header',
                              //       'data': {
                              //         'Request No': requestDetails!
                              //                 .header.requestNumber ??
                              //             '',
                              //         'Entry Date':
                              //             requestDetails!.header.entryDate ??
                              //                 '',
                              //         'Request Status': requestDetails!
                              //                 .header.requestStatus ??
                              //             '',
                              //         'Ref Num':
                              //             requestDetails!.header.referenceNo ??
                              //                 '',
                              //         'Instructions':
                              //             requestDetails!.header.instructions ??
                              //                 '',
                              //         'Delivery To':
                              //             requestDetails!.header.fao ?? '',
                              //         'Document Type':
                              //             requestDetails!.header.orderTypeId ??
                              //                 '',
                              //         'Delivery Code':
                              //             requestDetails!.header.deliveryCode ??
                              //                 '',
                              //         requestDetails!.header.expName1:
                              //             requestDetails!.header.expCode1 ?? '',
                              //         'Incoterms':
                              //             requestDetails!.header.fob ?? '',
                              //       },
                              //     },
                              //   );
                              // },

                              onTap: () {
                                navigateToScreen(
                                  context,
                                  BaseHeaderView(
                                      id: widget.requestId,
                                      headerType: HeaderType.request,
                                      appBarTitle: "Request Header",
                                      constantFieldshow: false,
                                      number: int.tryParse(requestDetails!
                                              .header.requestNumber) ??
                                          0,
                                      status:
                                          requestDetails!.header.requestStatus,
                                      date: requestDetails!.header.entryDate),
                                );
                              },

                              isExpanded: expandedSection == "Details",
                              toggleSection: () => setState(() {
                                expandedSection = expandedSection == "Details"
                                    ? null
                                    : "Details";
                              }),
                            ),

// ---------------------------------------------------------------------------- LINE ITEMS ------------------------------------------------------------------------------------

                            ApprovalDetailsHelper.buildSection(
                              "Line Items",
                              Icons.list_alt_outlined,
                              (requestDetails?.line?.isEmpty ?? true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No line items")
                                    ]
                                  : [
                                      ...requestDetails!.line!.map((lineItem) {
                                        return ApprovalDetailsHelper
                                            .buildMiniCardWithEditIcon({
                                          'Item No.': lineItem.itemOrder,
                                          // 'Item': lineItem.itemCode,
                                          'Description': lineItem.description,
                                          'Quantity': lineItem.quantity,
                                          'Unit Price':
                                              '${getFormattedPriceString(lineItem.price)} (${lineItem.supplierCcyCode})',
                                          'Net Price':
                                              '${getFormattedPriceString(lineItem.netPrice)} (${lineItem.supplierCcyCode})',
                                        }, () {
                                          //     Navigator.pushNamed(
                                          //       context,
                                          //       Routes.genericDetailRoute,
                                          //       arguments: {
                                          //         'title': 'Request Line',
                                          //         'data': {
                                          //           //  'Item Order': lineItem.itemOrder,
                                          //           'Item Code': lineItem.itemCode,
                                          //           'Item Description': lineItem
                                          //                       .description
                                          //                       .length >
                                          //                   100
                                          //               ? '${lineItem.description.substring(0, 100)}...'
                                          //               : lineItem.description,
                                          //           'Item Due Date':
                                          //               lineItem.dueDate,
                                          //           'Quantity': lineItem.quantity,
                                          //           'Unit': lineItem.unit,
                                          //           'Pack Size': lineItem.packSize,
                                          //           'Unit Price':
                                          //               '${getFormattedPriceString(lineItem.price)} (${lineItem.supplierCcyCode})',
                                          //           'Discount': lineItem
                                          //                       .discountType ==
                                          //                   1
                                          //               ? '${lineItem.discount}(value)'
                                          //               : '${lineItem.discount}(%)',
                                          //           'Tax':
                                          //               '${lineItem.tax.toStringAsFixed(3)}%',
                                          //           'Tax Value': lineItem.taxValue
                                          //               .toStringAsFixed(3),
                                          //         },
                                          //       },
                                          //     );
                                          //   });
                                          // }).toList(),

                                          // Navigator.pushNamed(
                                          //   context,
                                          //   Routes.genericDetailAPIRoute,
                                          //   arguments: {
                                          //     'title': 'Request Header',
                                          //     'type': 'header',
                                          //     'id': widget.requestId,
                                          //     'lineId': lineItem.requestLineId
                                          //   },
                                          // );
                                          navigateToScreen(
                                            context,
                                            BaseLineView(
                                              id: widget.requestId,
                                              lineId: lineItem.requestLineId,
                                              lineType: LineType.request,
                                              appBarTitle: "Request Line",
                                              buttonshow: false,
                                            ),
                                          );
                                        });
                                      }).toList(),
                                      ApprovalDetailsHelper
                                          .buildNetGrossTotalWidget(
                                              context, requestDetails!.line,
                                              dialogTitle:
                                                  'Request Total Summary',
                                              netTotalLabel: 'Total Net Amount',
                                              salesTaxLabel: 'Total Tax',
                                              grossTotalLabel:
                                                  'Request Gross Amount',
                                              currencyLabel:
                                                  'Request Currency'),
                                    ],
                              count: requestDetails?.line?.length ?? 0,
                              isExpanded: expandedSection == "Line Items",
                              toggleSection: () => setState(() {
                                expandedSection =
                                    expandedSection == "Line Items"
                                        ? null
                                        : "Line Items";
                              }),
                              trailing: _shouldShowAddItem()
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: ColorManager.blue,
                                        // .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: ColorManager.white,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  : null,
                              onTrailingTap:
                                  _shouldShowAddItem() ? _addNewLineItem : null,
                            ),

// ---------------------------------------------------------------------- RULES -------------------------------------------------------------------
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
                              trailing: _shouldShowAddItem()
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: ColorManager.blue,
                                        // .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: ColorManager.white,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  : null,
                              onTrailingTap:
                                  _shouldShowAddItem() ? _addNewLineItem : null,
                            ),

// ---------------------------------------------- RULE APPROVERS ----------------------------------------------------------
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
                                          .buildMiniCardForApproval(
                                        {
                                          'Approval Order': ra.approvalOrder,
                                          'User Name': ra.userName,
                                          'Group': ra.userGroupName,
                                          'Status': ra.approvalStatus,
                                          'Proxy User': ra.proxyUserName,
                                          'UID Group': ra.uidGroup.toString(),
                                        },
                                        () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.showGroupApprovalListRoute,
                                            arguments: {
                                              'id': ra.uidGroup,
                                              'from': 'rulegroup',
                                            },
                                          );
                                        },
                                        showIconCondition: (data) =>
                                            data['UID Group']?.toString() !=
                                            "0",
                                      );
                                    }).toList(),
                              count: requestDetails?.ruleApprovers?.length ?? 0,
                              isExpanded: expandedSection == "Rule Approvers",
                              toggleSection: () => setState(() {
                                expandedSection =
                                    expandedSection == "Rule Approvers"
                                        ? null
                                        : "Rule Approvers";
                              }),
                              trailing: _shouldShowAddItem()
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: ColorManager.blue,
                                        // .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: ColorManager.white,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  : null,
                              onTrailingTap:
                                  _shouldShowAddItem() ? _addNewLineItem : null,
                            ),

//-------------------------------------------------------------------- COST CENTERS ------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ApprovalDetailsHelper.buildSection(
                              "Cost Center Split",
                              Icons.account_balance_wallet_outlined,
                              (requestDetails?.costCenter?.isEmpty ?? true)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No cost center data"),
                                    ]
                                  //  : requestDetails!.costCenter!.map((cc) {
                                  : requestDetails!.costCenter
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                      int index = entry.key;
                                      var cc = entry.value;
                                      return ApprovalDetailsHelper
                                          .buildMiniCard1(
                                        {
                                          'Cost Center Code': cc.costCode,
                                          'Description': cc.costDescription,
                                          'Split Percentage':
                                              '${cc.splitPercentage}%',
                                          'Split Value':
                                              getFormattedPriceString(
                                                  cc.splitValue),
                                        },
                                        showDelete: (requestDetails!
                                                    .header.requestStatus ==
                                                "DORMANT" ||
                                            requestDetails!
                                                    .header.requestStatus ==
                                                "PENDING"),
                                        onDelete: () =>
                                            _deleteCostCenterSplit(),
                                      );
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
                                  : requestDetails!.attachedDocument!.map((d) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCard({
                                        'File Name': d.documentFileName,
                                        'File Privacy': d.docPrivacyText,
                                        'Deascription': d.documentDescription,
                                        'Entry Date': d.docStamp,
                                        'Entered By': d.enteredBy,
                                      }, onTap: () {});
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
                              trailing: _shouldShowAddItem()
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: ColorManager.blue,
                                        // .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: ColorManager.white,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  : null,
                              onTrailingTap: _shouldShowAddItem()
                                  ? _addNewAttachment
                                  : null,
                            ),
                            //----------------------------------Notes------------------------------------------------------
                            ApprovalDetailsHelper.buildSection(
                              "Notes",
                              Icons.attach_file,
                              (requestDetails!.notes == null ||
                                      requestDetails!.notes!.isEmpty)
                                  ? [
                                      ApprovalDetailsHelper.buildEmptyView(
                                          "No Notes found"),
                                    ]
                                  : requestDetails!.notes!.map((d) {
                                      return ApprovalDetailsHelper
                                          .buildMiniCard({
                                        'File Name': d.documentFileName,
                                        'File Privacy': d.docPrivacyText,
                                        'Deascription': d.documentDescription,
                                        'Entry Date': d.docStamp,
                                        'Entered By': d.enteredBy,
                                      }, onTap: () {});
                                    }).toList(),
                              count: requestDetails!.notes?.length ?? 0,
                              isExpanded: expandedSection == "Notes",
                              toggleSection: () {
                                setState(() {
                                  expandedSection = expandedSection == "Notes"
                                      ? null
                                      : "Notes";
                                });
                              },
                              trailing: _shouldShowAddItem()
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: ColorManager.blue,
                                        // .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: ColorManager.white,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  : null,
                              onTrailingTap:
                                  _shouldShowAddItem() ? _addNewNotes : null,
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

                    // -------------------- BUTTONS --------------------

                    // Container(
                    //     color: ColorManager.white,
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 16, vertical: 12),
                    //     child: RequestActionButtonsHelper.buildButtons(
                    //       context: context,
                    //       status: requestDetails!.header.requestStatus,
                    //       onSubmitForApproval: _submitForApproval,
                    //       onApprove: requestApprovalApprove,
                    //       onReject: (reason) => requestApprovalReject(reason),
                    //       onTakeOwnership: _takeOwnership,
                    //       onCreateOrder: _createOrderFromRequest,
                    //       onEditRequest: _editRequest,
                    //     )),
                  ],
                ),
    );
  }
}
