import 'dart:developer';

import 'package:eyvo_inventory/api/response_models/order_approval_approved_response.dart';
import 'package:eyvo_inventory/api/response_models/order_approval_reject_response.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/alert.dart';
import 'package:eyvo_inventory/core/widgets/approval_details_helper.dart';
import 'package:eyvo_inventory/core/widgets/approver_detailed_page.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/thankYouPage.dart';
import 'package:eyvo_inventory/features/auth/view/screens/approval/show_group_approver_list.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/order_approval_details_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestDetailsView extends StatefulWidget {
  const RequestDetailsView({Key? key}) : super(key: key);

  @override
  State<RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView> {
  String? expandedSection;

  @override
  void initState() {
    super.initState();
    expandedSection = "Details"; // Default expanded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: "#Request No",
      ),
      backgroundColor: ColorManager.primary,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ApprovalDetailsHelper.buildSectionForDetails(
                    "Details",
                    Icons.description_outlined,
                    {
                      "Info": "No details available",
                    },
                    onTap: () {},
                    isExpanded: expandedSection == "Details",
                    toggleSection: () {
                      setState(() {
                        expandedSection =
                            expandedSection == "Details" ? null : "Details";
                      });
                    },
                  ),
                  ApprovalDetailsHelper.buildSection(
                    "Line Items",
                    Icons.list_alt_outlined,
                    [
                      ApprovalDetailsHelper.buildEmptyView("No line items"),
                    ],
                    count: 0,
                    isExpanded: expandedSection == "Line Items",
                    toggleSection: () {
                      setState(() {
                        expandedSection = expandedSection == "Line Items"
                            ? null
                            : "Line Items";
                      });
                    },
                  ),
                  ApprovalDetailsHelper.buildSection(
                    "Rules",
                    Icons.rule,
                    [
                      ApprovalDetailsHelper.buildEmptyView("No rules"),
                    ],
                    count: 0,
                    isExpanded: expandedSection == "Rules",
                    toggleSection: () {
                      setState(() {
                        expandedSection =
                            expandedSection == "Rules" ? null : "Rules";
                      });
                    },
                  ),
                  ApprovalDetailsHelper.buildSection(
                    "Rule Approvers",
                    FontAwesomeIcons.userCheck,
                    [
                      ApprovalDetailsHelper.buildEmptyView("No rule approvers"),
                    ],
                    count: 0,
                    isExpanded: expandedSection == "Rule Approvers",
                    toggleSection: () {
                      setState(() {
                        expandedSection = expandedSection == "Rule Approvers"
                            ? null
                            : "Rule Approvers";
                      });
                    },
                  ),
                  ApprovalDetailsHelper.buildSection(
                    "Cost Center Split",
                    Icons.share,
                    [
                      ApprovalDetailsHelper.buildEmptyView(
                          "No cost center data"),
                    ],
                    count: 0,
                    isExpanded: expandedSection == "Cost Center",
                    toggleSection: () {
                      setState(() {
                        expandedSection = expandedSection == "Cost Center"
                            ? null
                            : "Cost Center";
                      });
                    },
                  ),
                  // ApprovalDetailsHelper.buildSection(
                  //   "Cost center Approvers",
                  //   FontAwesomeIcons.userCheck,
                  //   [
                  //     ApprovalDetailsHelper.buildEmptyView("No approvers"),
                  //   ],
                  //   count: 0,
                  //   isExpanded: expandedSection == "Cost center Approvers",
                  //   toggleSection: () {
                  //     setState(() {
                  //       expandedSection =
                  //           expandedSection == "Cost center Approvers"
                  //               ? null
                  //               : "Cost center Approvers";
                  //     });
                  //   },
                  // ),
                  ApprovalDetailsHelper.buildSection(
                    "Group Approvers",
                    Icons.groups,
                    [
                      ApprovalDetailsHelper.buildEmptyView(
                          "No group approvers"),
                    ],
                    count: 0,
                    isExpanded: expandedSection == "Group Approvers",
                    toggleSection: () {
                      setState(() {
                        expandedSection = expandedSection == "Group Approvers"
                            ? null
                            : "Group Approvers";
                      });
                    },
                  ),
                  ApprovalDetailsHelper.buildSection(
                    "Attachments",
                    Icons.attach_file,
                    [
                      ApprovalDetailsHelper.buildEmptyView("No attachments"),
                    ],
                    count: 0,
                    isExpanded: expandedSection == "Attachments",
                    toggleSection: () {
                      setState(() {
                        expandedSection = expandedSection == "Attachments"
                            ? null
                            : "Attachments";
                      });
                    },
                  ),
                  ApprovalDetailsHelper.buildSection(
                    "Event Log",
                    Icons.history,
                    [
                      ApprovalDetailsHelper.buildEmptyView("No events"),
                    ],
                    count: 0,
                    isExpanded: expandedSection == "Event Log",
                    toggleSection: () {
                      setState(() {
                        expandedSection =
                            expandedSection == "Event Log" ? null : "Event Log";
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
