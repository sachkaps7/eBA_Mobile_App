import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eyvo_v3/app/sizes_helper.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/cost_center_split_details.dart';
import 'package:permission_handler/permission_handler.dart' as PH;
import 'package:eyvo_v3/api/response_models/attachement_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/cost_center_approval_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/cost_center_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/log_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/term_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/view_group_approval_response_model.dart';
import 'package:eyvo_v3/api/response_models/line_item_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/notes_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/order_approval_approved_response.dart';
import 'package:eyvo_v3/api/response_models/order_approval_reject_response.dart';
import 'package:eyvo_v3/api/response_models/order_header_response.dart';
import 'package:eyvo_v3/api/response_models/rule_approval_response_model.dart';
import 'package:eyvo_v3/api/response_models/rule_list_response_model.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/routes_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/alert.dart';
import 'package:eyvo_v3/core/widgets/approval_details_helper.dart';
import 'package:eyvo_v3/core/widgets/approver_detailed_page.dart';
import 'package:eyvo_v3/core/widgets/button_helper.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:eyvo_v3/core/widgets/thankYouPage.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/base_header_form_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/base_line_form_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/note_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/show_group_approver_list.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/order_approval_details_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

class OrderDetailsView extends StatefulWidget {
  final int orderId;
  final bool? constantFieldshow;

  const OrderDetailsView(
      {Key? key, required this.orderId, this.constantFieldshow})
      : super(key: key);

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> with RouteAware {
  final ApiService apiService = ApiService();
  bool isLoading = false, isError = false;
  String errorText = AppStrings.somethingWentWrong;
  OrderDetailsResponseData? orderDetails;
  LineItemListResponseData? lineItemListData;
  List<GetRuleResponseData> ruleListData = [];
  List<RuleApprovalResponseData> ruleApprovalListData = [];
  CostCenterListResponseData? costCenterListData;
  GroupApprovalListResponseData? groupApproversListData;

  List<LogListResponseData>? logsListData;
  CostCenterApprovalResponseData? ccApprovalData;
  NotesData? noteData;
  TermListResponseData? termListData;
  AttachmentData? attachmentData;

  String? expandedSection;
  bool isLineItemsLoading = false;
  bool isLineItemsLoaded = false;
  String? lineItemsError;
  String? ruleListError;
  bool isRuleListLoading = false;
  bool isRuleListLoaded = false;
  bool isRuleApprovalListLoading = false;
  bool isRuleApprovalListLoaded = false;
  String? ruleApprovalListError;
  bool isCostCenterListLoading = false;
  bool isCostCenterListLoaded = false;
  String? costCenterListError;
  bool isCostCenterApproversListLoading = false;
  bool isCostCenterApproversListLoaded = false;
  String? costCenterApproversListError;
  bool isGroupApproversListLoading = false;
  bool isGroupApproversListLoaded = false;
  String? groupApproversListError;
  bool isAttachmentListLoading = false;
  bool isAttachmentListLoaded = false;
  String? attachmentListError;
  bool isTermsListLoading = false;
  bool isTermsListLoaded = false;
  String? termsListError;
  bool isNotesListLoading = false;
  bool isNotesListLoaded = false;
  String? notesListError;
  bool isLogsListLoading = false;
  bool isLogsListLoaded = false;
  String? logsListError;

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
    fetchOrderDetails();
  }

  @override
  void initState() {
    super.initState();
    expandedSection = "Details"; // Default expanded
    fetchOrderDetails();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> downloadFile(String fileName, String base64Data) async {
    try {
      final bytes = base64Decode(base64Data);

      if (Platform.isAndroid) {
        bool allowed = await requestStoragePermission();
        if (!allowed) {
          debugPrint("Storage permission denied.");
          return;
        }
      }

      String savePath;

      if (Platform.isAndroid) {
        final directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        savePath = "${directory.path}/$fileName";
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = "${dir.path}/$fileName";
      }

      final file = File(savePath);
      await file.writeAsBytes(bytes);

      debugPrint("File saved at: $savePath");

      showSnackBar(
        context,
        "Downloaded to: $savePath",
      );
    } catch (e) {
      debugPrint("Download error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 11+ (API 30+) All-files access
      if (await PH.Permission.manageExternalStorage.isGranted) {
        return true;
      }

      var status = await PH.Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      }

      // Fallback for Android 10 and below
      status = await PH.Permission.storage.request();
      return status.isGranted;
    }

    return true; // iOS
  }

  Future<dynamic> fetchCommonData({
    required String endpoint,
  }) async {
    try {
      final jsonResponse = await apiService.postRequest(
        context,
        endpoint,
        {
          'uid': SharedPrefs().uID,
          'apptype': AppConstants.apptype,
          'ID': orderDetails!.header.orderId,
          'group': 'Order',
          "regionid": "",
          "search": "",
        },
      );

      return jsonResponse;
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>?> commonWrapper({
    required void Function(bool) setLoading,
    required void Function(String?) setError,
    required void Function(bool) setLoaded,
    required String endpoint,
  }) async {
    setLoading(true);
    setError(null);
    setLoaded(false);

    try {
      final result = await fetchCommonData(endpoint: endpoint);

      if (result is Map && result["error"] != null) {
        setError(result["error"]);
        return null;
      }

      setLoaded(true);
      return Map<String, dynamic>.from(result);
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchRulelistWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isRuleListLoading = v),
      setError: (msg) => setState(() => ruleListError = msg),
      setLoaded: (v) => setState(() => isRuleListLoaded = v),
      endpoint: ApiService.getRuleList,
    );

    if (json == null) return;

    final resp = GetRuleResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => ruleListData = resp.data);
    } else {
      setState(() => ruleListError = resp.message.join(", "));
    }
  }

  Future<void> fetchLineItemsWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isLineItemsLoading = v),
      setError: (msg) => setState(() => lineItemsError = msg),
      setLoaded: (v) => setState(() => isLineItemsLoaded = v),
      endpoint: ApiService.getLineItems,
    );

    if (json == null) return;

    final resp = LineItemListResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => lineItemListData = resp.data);
    } else {
      setState(() => lineItemsError = resp.message.join(", "));
    }
  }

  Future<void> fetchRuleApprovalListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isRuleApprovalListLoading = v),
      setError: (msg) => setState(() => ruleApprovalListError = msg),
      setLoaded: (v) => setState(() => isRuleApprovalListLoaded = v),
      endpoint: ApiService.getRuleApproversList,
    );

    if (json == null) return;

    final resp = RuleApprovalResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => ruleApprovalListData = resp.data);
    } else {
      setState(() => ruleApprovalListError = resp.message.join(", "));
    }
  }

  Future<void> fetchCostCenterListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isCostCenterListLoading = v),
      setError: (msg) => setState(() => costCenterListError = msg ?? ""),
      setLoaded: (v) => setState(() => isCostCenterListLoaded = v),
      endpoint: ApiService.getCostCenterList,
    );

    if (json == null) return;

    final resp = CostCenterListResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => costCenterListData = resp.data);
    } else {
      setState(() => costCenterListError = resp.message.join(", ") ?? "");
    }
  }

  Future<void> fetchCostCenterApproversListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isCostCenterApproversListLoading = v),
      setError: (msg) =>
          setState(() => costCenterApproversListError = msg ?? ""),
      setLoaded: (v) => setState(() => isCostCenterApproversListLoaded = v),
      endpoint: ApiService.getCostCenterApproversList,
    );

    if (json == null) return;

    final resp = CostCenterApprovalResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => ccApprovalData = resp.data);
    } else {
      setState(
          () => costCenterApproversListError = resp.message.join(", ") ?? "");
    }
  }

  Future<void> fetchGroupApproversListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isGroupApproversListLoading = v),
      setError: (msg) => setState(() => groupApproversListError = msg ?? ""),
      setLoaded: (v) => setState(() => isGroupApproversListLoaded = v),
      endpoint: ApiService.getGroupApproversList,
    );

    if (json == null) return;

    final resp = GroupApprovalListResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => groupApproversListData = resp.data);
    } else {
      setState(() => groupApproversListError = resp.message.join(", ") ?? "");
    }
  }

  Future<void> fetchAttachmentListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isAttachmentListLoading = v),
      setError: (msg) => setState(() => attachmentListError = msg ?? ""),
      setLoaded: (v) => setState(() => isAttachmentListLoaded = v),
      endpoint: ApiService.getAttachmentList,
    );

    if (json == null) return;

    final resp = AttachmentListResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => attachmentData = resp.data);
    } else {
      setState(() => attachmentListError = resp.message.join(", "));
    }
  }

  Future<void> fetchTermsListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isTermsListLoading = v),
      setError: (msg) => setState(() => termsListError = msg ?? ""),
      setLoaded: (v) => setState(() => isTermsListLoaded = v),
      endpoint: ApiService.getTermsList,
    );

    if (json == null) return;

    final resp = TermListResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => termListData = resp.data);
    } else {
      setState(() => termsListError = resp.message.join(", ") ?? "");
    }
  }

  Future<void> fetchNotesListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isNotesListLoading = v),
      setError: (msg) => setState(() => notesListError = msg ?? ""),
      setLoaded: (v) => setState(() => isNotesListLoaded = v),
      endpoint: ApiService.getNotesList,
    );

    if (json == null) return;

    final resp = NotesListResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => noteData = resp.data);
    } else {
      setState(() => notesListError = resp.message.join(", "));
    }
  }

  Future<void> fetchLogsListWrapper() async {
    final json = await commonWrapper(
      setLoading: (v) => setState(() => isLogsListLoading = v),
      setError: (msg) => setState(() => logsListError = msg ?? ""),
      setLoaded: (v) => setState(() => isLogsListLoaded = v),
      endpoint: ApiService.getLogsList,
    );

    if (json == null) return;

    final resp = LogListResponse.fromJson(json);

    if (resp.code == 200) {
      setState(() => logsListData = resp.data);
    } else {
      setState(() => logsListError = resp.message.join(", "));
    }
  }

  Future<void> fetchOrderDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.orderDetails,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'orderId': widget.orderId
      },
    );

    if (jsonResponse != null) {
      final resp = OrderDetailsResponse.fromJson(jsonResponse);
      if (resp.code == 200) {
        setState(() {
          orderDetails = resp.data;
          isLoading = false;
        });
        return;
      } else {
        errorText = resp.message.join(', ');
      }
    }
    setState(() {
      isError = true;
      isLoading = false;
    });
  }

  Future<void> orderApprovalApproved() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.orderApprovalApproved,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'orderId': widget.orderId,
      },
    );

    if (!mounted) return;

    if (jsonResponse != null) {
      final resp = OrderApprovalApprovedResponse.fromJson(jsonResponse);
      if (resp.code == 200) {
        final message = resp.message ?? "Approved successfully";

        Navigator.pushReplacementNamed(
          context,
          Routes.thankYouRoute,
          arguments: {
            'message': message,
            'approverName': 'orderApproval',
            'status': 'Order Approved',
            'requestName': 'Order Number',
            'number': orderDetails!.header.orderNumber
          },
        );
      } else {
        errorText = resp.message ?? "Something went wrong";
        showErrorDialog(context, errorText, false);
      }
    } else {
      errorText = "No response from server";
      showErrorDialog(context, errorText, false);
    }

    setState(() {
      isLoading = false;
      isError = true;
    });
  }

  Future<void> orderApprovalReject(String reason) async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.orderApprovalReject,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'orderId': widget.orderId,
        'reason': reason,
      },
    );

    if (!mounted) return;

    if (jsonResponse != null) {
      final resp = OrderApprovalRejectResponse.fromJson(jsonResponse);
      if (resp.code == 200) {
        final message = resp.message.isNotEmpty
            ? resp.message.first
            : "Rejected successfully";

        Navigator.pushReplacementNamed(
          context,
          Routes.thankYouRoute,
          arguments: {
            'message': message,
            'approverName': 'orderApproval',
            'status': 'Order Rejected',
            'requestName': 'Order Number',
            'number': orderDetails!.header.orderNumber,
          },
        );
      } else {
        errorText = resp.message.isNotEmpty
            ? resp.message.first
            : "Something went wrong";
        showErrorDialog(context, errorText, false);
      }
    } else {
      errorText = "No response from server";
      showErrorDialog(context, errorText, false);
    }

    setState(() {
      isLoading = false;
      isError = true;
    });
  }

  Future<void> _submitForApproval() async {
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
        'message': "Order submitted for approval successfully",
        'approverName': 'orderApproval',
        'status': 'Submitted',
        'requestName': 'Order Number',
        'number': orderDetails!.header.orderNumber,
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
        'number': orderDetails!.header.orderNumber,
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
        'message': "Order re-issued successfully",
        'approverName': 'orderApproval',
        'status': 'Order Re-Issued',
        'requestName': 'Order Number',
        'number': orderDetails!.header.orderNumber,
      },
    );

    setState(() {
      isLoading = false;
      isError = true;
    });
  }

  void _addNewLineItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaseLineView(
          id: widget.orderId,
          lineId: 0,
          lineType: LineType.order,
          appBarTitle: "Order Line",
          buttonshow: true,
        ),
      ),
    ).then((_) {
      fetchLineItemsWrapper();
    });
  }

  void _addNewNotes() {
    Navigator.pushNamed(
      context,
      Routes.notesViewRoute,
      arguments: {
        'noteId': 0,
        'group': 'Order',
        'ordReqID': orderDetails!.header.orderId,
      },
    ).then((result) {
      if (result == true) {
        fetchNotesListWrapper();
      }
    });
  }

  void _addNewAttachment() {
    Navigator.pushNamed(
      context,
      Routes.attachmentPageRoute,
      arguments: {
        'group': 'Order',
        'ordReqID': orderDetails!.header.orderId,
      },
    ).then((result) {
      if (result == true) {
        fetchAttachmentListWrapper();
      }
    });
    LoggerData.dataLog('${orderDetails!.header.orderId}###########');
  }

  void _addNewCostCenterSplit() {
    Navigator.pushNamed(
      context,
      Routes.costCenterSplitRoute,
      arguments: {
        'group': 'Order',
        'ordReqID': orderDetails!.header.orderId,
      },
    ).then((result) {
      if (result == true) {
        fetchCostCenterListWrapper();
      }
    });
    // navigateToScreen(context, BudgetGraphPage());
  }

  void _addNewCCApproval() {
    Navigator.pushNamed(
      context,
      Routes.createCostCenterApproverView,
      arguments: {
        'group': 'Order',
        'ordReqID': orderDetails!.header.orderId,
      },
    ).then((result) {
      if (result == true) {
        fetchGroupApproversListWrapper();
      }
    });
  }

  void _addNewGroupApproval() {
    Navigator.pushNamed(
      context,
      Routes.groupApprovalRoute,
      arguments: {
        'group': 'Order',
        'ordReqID': orderDetails!.header.orderId,
      },
    ).then((result) {
      if (result == true) {
        fetchGroupApproversListWrapper();
      }
    });
  }

  void _termsAndCondition() {
    Navigator.pushNamed(
      context,
      Routes.termsAndConditionRoute,
      arguments: {
        'group': 'Order',
        'ordReqID': orderDetails!.header.orderId,
      },
    ).then((result) {
      if (result == true) {
        fetchTermsListWrapper();
      }
    });
  }

  void _deleteCostCenterSplit() {
    //   print("Delete pressed");
    // Add your API or logic here
  }
  Widget _roundButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.cCSplitBG,
          border: Border.all(
            color: onTap != null ? ColorManager.white : ColorManager.white,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 30,
          color: onTap != null ? ColorManager.darkBlue2 : ColorManager.grey,
        ),
      ),
    );
  }

  void _showSplitPercentDialog(BuildContext context, dynamic c) {
    final TextEditingController splitController =
        TextEditingController(text: "100");

    bool resetOtherValue = false;
    bool resetApproval = false;
    int splitValue = 100;

    String allocationType = "Percentage";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final height = MediaQuery.of(context).size.height;
            return SizedBox(
              height: height * 0.7,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: ColorManager.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Center(
                        child: Text(
                          "Split Percentage",
                          style: getBoldStyle(
                            fontSize: FontSize.s21,
                            color: ColorManager.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Cost Center
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.cCSplitBG,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Cost Center Code: ${c.costCode}",
                            style: getSemiBoldStyle(
                              color: ColorManager.darkBlue2,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //PLUS BUTTON (LEFT)
                          _roundButton(
                            icon: Icons.add,
                            onTap: splitValue < 100
                                ? () {
                                    setState(() {
                                      splitValue++;
                                      splitController.text =
                                          splitValue.toString();
                                    });
                                  }
                                : null,
                          ),

                          const SizedBox(width: 12),

                          //NUMBER + %
                          Container(
                            height: 65,
                            width: 180,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: ColorManager.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //NUMBER + %
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 110,
                                      child: TextField(
                                        controller: splitController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: getBoldStyle(
                                          fontSize: FontSize.s40,
                                          color: ColorManager.darkBlue,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (value) {
                                          final v = int.tryParse(value);
                                          if (v != null && v >= 0 && v <= 100) {
                                            setState(() => splitValue = v);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '%',
                                      style: getBoldStyle(
                                        fontSize: FontSize.s20,
                                        color: ColorManager.darkBlue2,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 2),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // MINUS BUTTON (RIGHT)
                          _roundButton(
                            icon: Icons.remove,
                            onTap: splitValue > 0
                                ? () {
                                    setState(() {
                                      splitValue--;
                                      splitController.text =
                                          splitValue.toString();
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Checkboxes
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                        decoration: BoxDecoration(
                          color: ColorManager.boxBG,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Allocation Type
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Allocation Type",
                                      style: getBoldStyle(
                                        color: ColorManager.darkBlue2,
                                        fontSize: FontSize.s18,
                                      ),
                                    ),
                                    Text(
                                      "basis of split",
                                      style: getSemiBoldStyle(
                                        color: ColorManager.grey,
                                        fontSize: FontSize.s14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: DropdownButtonFormField<String>(
                                    value: allocationType,
                                    dropdownColor: ColorManager.white,
                                    style: getSemiBoldStyle(
                                      color: ColorManager.darkBlue2,
                                      fontSize: FontSize.s18,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: ColorManager.white,
                                      iconColor: ColorManager.darkBlue2,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: ColorManager.boxBG,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: ColorManager.boxBG,
                                          // width: 1.5,
                                        ),
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Percentage",
                                        child: Text("%"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Value",
                                        child: Text("Value"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        allocationType = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Divider(
                              color: ColorManager.lightGrey.withOpacity(0.3),
                              thickness: 1,
                              height: 16,
                            ),

                            // Re-set other value
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reset others",
                                  style: getBoldStyle(
                                    color: ColorManager.darkBlue2,
                                    fontSize: FontSize.s18,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 1.25,
                                  child: Switch(
                                    value: resetOtherValue,
                                    onChanged: (value) {
                                      setState(() => resetOtherValue = value);
                                    },
                                    activeTrackColor: ColorManager.darkBlue2,
                                    inactiveTrackColor: ColorManager.lightGrey4,
                                    activeColor: ColorManager.white,
                                    inactiveThumbColor: ColorManager.white,
                                    trackOutlineColor:
                                        MaterialStateProperty.all(
                                            ColorManager.boxBG),
                                  ),
                                )
                              ],
                            ),

                            // Divider
                            Divider(
                              color: ColorManager.lightGrey.withOpacity(0.3),
                              thickness: 1,
                              height: 8,
                            ),

                            // Reset approval
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reset approval",
                                      style: getBoldStyle(
                                        color: ColorManager.darkBlue2,
                                        fontSize: FontSize.s18,
                                      ),
                                    ),
                                    Text(
                                      "Restart workflow",
                                      style: getSemiBoldStyle(
                                        color: ColorManager.grey,
                                        fontSize: FontSize.s14,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 1.25,
                                  child: Switch(
                                    value: resetApproval,
                                    onChanged: (value) {
                                      setState(() => resetApproval = value);
                                    },
                                    activeTrackColor: ColorManager.darkBlue,
                                    inactiveTrackColor: ColorManager.lightGrey4,
                                    activeColor: ColorManager.white,
                                    inactiveThumbColor: ColorManager.white,
                                    trackOutlineColor:
                                        MaterialStateProperty.all(
                                            ColorManager.boxBG),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// BUTTONS (SAFE)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: CustomTextActionButton(
                              buttonText: "Update Changes",
                              backgroundColor: ColorManager.darkBlue,
                              fontColor: ColorManager.white,
                              onTap: () {},
                              borderColor: ColorManager.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: CustomTextActionButton(
                              buttonText: "Cancel",
                              backgroundColor: ColorManager.white,
                              fontColor: ColorManager.darkBlue,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderColor: ColorManager.darkBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: orderDetails == null
            ? "Order Details"
            : "Order #${orderDetails!.header.orderNumber}",
      ),
      backgroundColor: ColorManager.primary,
      bottomNavigationBar: orderDetails == null
          ? null
          : Container(
              color: ColorManager.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: DynamicOrderButtonBuilder.build(
                context: context,
                buttonName: orderDetails!.buttonName,
                buttonAction: orderDetails!.buttonAction,
                buttonAlert: orderDetails!.buttonAlert,
                onApprove: orderApprovalApproved,
                onReject: (reason) => orderApprovalReject(reason),
                onSubmitForApproval: _submitForApproval,
                onIssueOrder: _issueOrder,
                onReIssueOrder: _reIssueOrder,
              ),
            ),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isError
              ? Center(child: Text(errorText))
              : Column(
                  children: [
                    Expanded(
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          trackColor:
                              MaterialStateProperty.all(ColorManager.grey),
                          trackVisibility: const WidgetStatePropertyAll(true),
                          thumbColor: MaterialStateProperty.all(
                              ColorManager.lightBlue1),
                          radius: const Radius.circular(8),
                          thickness: MaterialStateProperty.all(3),
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
//------------------------------------ order header--------------------------
                                ApprovalDetailsHelper
                                    .buildSectionForDetailsWithEditIcon(
                                  "Details",
                                  Icons.description_outlined,
                                  {
                                    'Order Number':
                                        orderDetails!.header.orderNumber,
                                    'Order Date':
                                        orderDetails!.header.orderDate,
                                    'Order Status':
                                        orderDetails!.header.orderStatus,
                                    'Supplier Name':
                                        orderDetails!.header.supplierName,
                                    'Order ${capitalizeFirstLetter(orderDetails!.header.orderValueLabel)} Total':
                                        '${getFormattedPriceString(orderDetails!.header.orderValue)} (${orderDetails!.header.ccyCode})',
                                    'Rule Approval':
                                        orderDetails!.header.ruleStatus,
                                    'Cost Center Approver':
                                        orderDetails!.header.ccApproverStatus,
                                    'Group Approver': orderDetails!
                                        .header.groupApproverStatus,
                                  },
                                  onTap: () {
                                    navigateToScreen(
                                      context,
                                      BaseHeaderView(
                                        id: widget.orderId,
                                        number: int.tryParse(orderDetails!
                                                .header.orderNumber) ??
                                            0,
                                        headerType: HeaderType.order,
                                        appBarTitle: "Order Header",
                                        buttonshow: true,
                                        constantFieldshow:
                                            widget.constantFieldshow,
                                        status:
                                            orderDetails!.header.orderStatus,
                                        date: orderDetails!.header.orderDate,
                                      ),
                                    );
                                  },
                                  isExpanded: expandedSection == "Details",
                                  toggleSection: () {
                                    setState(() {
                                      expandedSection =
                                          expandedSection == "Details"
                                              ? null
                                              : "Details";
                                    });
                                  },
                                ),
                                //------------------------------------------ Line Item ----------------------------------
                                ApprovalDetailsHelper.buildSection(
                                  "Line Items",
                                  Icons.list_alt_outlined,

                                  // CHILDREN
                                  expandedSection == "Line Items"
                                      ? (isLineItemsLoading
                                          ? [
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]
                                          : lineItemsError != null
                                              ? [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Text(
                                                        lineItemsError!,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              : lineItemListData == null ||
                                                      lineItemListData!
                                                          .list.isEmpty
                                                  ? [
                                                      ApprovalDetailsHelper
                                                          .buildEmptyView(
                                                        "No line items Added",
                                                      ),
                                                    ]
                                                  : [
                                                      ...lineItemListData!.list
                                                          .map((lineItem) {
                                                        return ApprovalDetailsHelper
                                                            .buildMiniCardWithEditIcon({
                                                          'Item No': lineItem
                                                              .itemOrder,
                                                          'Description': lineItem
                                                                      .description
                                                                      .length >
                                                                  50
                                                              ? '${lineItem.description.substring(0, 50)}...'
                                                              : lineItem
                                                                  .description,
                                                          'Quantity':
                                                              '${getFormattedPriceString(lineItem.quantity)}',
                                                          'Unit Price':
                                                              '${getFormattedPriceString(lineItem.price)} (${lineItem.supplierCcyCode})',
                                                          'Net Price':
                                                              '${getFormattedPriceString(lineItem.netPrice)} (${lineItem.supplierCcyCode})',
                                                        }, () {
                                                          navigateToScreen(
                                                            context,
                                                            BaseLineView(
                                                              id: widget
                                                                  .orderId,
                                                              lineId: lineItem
                                                                  .orderLineId,
                                                              lineType: LineType
                                                                  .order,
                                                              appBarTitle:
                                                                  "Order Line",
                                                              buttonshow: false,
                                                            ),
                                                          );
                                                        });
                                                      }).toList(),

                                                      // Summary
                                                      ApprovalDetailsHelper
                                                          .buildNetGrossTotalWidget(
                                                        context,
                                                        lineItemListData!.list,
                                                        dialogTitle:
                                                            'Order Total Summary',
                                                        netTotalLabel:
                                                            'Order Net Total',
                                                        shippingChargesLabel:
                                                            'Shipping Charges',
                                                        salesTaxLabel:
                                                            'Sales Tax',
                                                        grossTotalLabel:
                                                            'Order Gross Total',
                                                        currencyLabel:
                                                            'Order Currency',
                                                      ),
                                                    ])
                                      : [],

                                  //  PASS isExpanded HERE
                                  isExpanded: expandedSection == "Line Items",

                                  // Count
                                  count: int.tryParse(
                                      orderDetails!.lineItemsCount),

                                  // Toggle
                                  toggleSection: () async {
                                    final willExpand =
                                        expandedSection != "Line Items";

                                    setState(() {
                                      expandedSection =
                                          willExpand ? "Line Items" : null;
                                    });

                                    if (willExpand && !isLineItemsLoaded) {
                                      await fetchLineItemsWrapper();
                                    }
                                  },

                                  // Add button
                                  trailing: (lineItemListData != null &&
                                          lineItemListData!.permission.mode ==
                                              "RW")
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: ColorManager.blue,
                                            // borderRadius:
                                            //     BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Icon(Icons.add,
                                                color: ColorManager.white,
                                                size: 22),
                                          ),
                                        )
                                      : null,
                                  onTrailingTap: (lineItemListData != null &&
                                          lineItemListData!.permission.mode ==
                                              "RW")
                                      ? _addNewLineItem
                                      : null,
                                ),
                                //------------------------------------ RULES -----------------------------------------
                                if (SharedPrefs().sysRuleFunction == true &&
                                    SharedPrefs().sysRuleApproval == true)
                                  ApprovalDetailsHelper.buildSection(
                                    "Rules",
                                    Icons.rule,

                                    // CHILDREN
                                    expandedSection == "Rules"
                                        ? (isRuleListLoading
                                            ? [
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ]
                                            : ruleListError != null
                                                ? [
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Text(
                                                          ruleListError!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                : ruleListData == null ||
                                                        ruleListData!.isEmpty
                                                    ? [
                                                        ApprovalDetailsHelper
                                                            .buildEmptyView(
                                                          "No rules Added",
                                                        ),
                                                      ]
                                                    : [
                                                        ...ruleListData!
                                                            .map((r) {
                                                          return ApprovalDetailsHelper
                                                              .buildMiniCard({
                                                            'Rule Name':
                                                                r.ruleName,
                                                            'Rule Description':
                                                                r.ruleDescription,
                                                            'Rule Selected':
                                                                r.ruleSelected
                                                                    ? 'true'
                                                                    : 'false',
                                                          });
                                                        }).toList(),
                                                      ])
                                        : [],

                                    // Expanded
                                    isExpanded: expandedSection == "Rules",

                                    // Count (safe)
                                    count:
                                        int.tryParse(orderDetails!.ruleCount),

                                    // Toggle Section
                                    toggleSection: () async {
                                      final willExpand =
                                          expandedSection != "Rules";

                                      setState(() {
                                        expandedSection =
                                            willExpand ? "Rules" : null;
                                      });

                                      if (willExpand && !isRuleListLoaded) {
                                        await fetchRulelistWrapper();
                                      }
                                    },
                                  ),
                                //--------------------------------- Rule Approvers---------------------------------------
                                if (SharedPrefs().sysRuleFunction == true &&
                                    SharedPrefs().sysRuleApproval == true)
                                  ApprovalDetailsHelper.buildSection(
                                    "Rule Approvers",
                                    FontAwesomeIcons.userCheck,

                                    // CHILDREN
                                    expandedSection == "Rule Approvers"
                                        ? (isRuleApprovalListLoading
                                            ? [
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ]
                                            : ruleApprovalListError != null
                                                ? [
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Text(
                                                          ruleApprovalListError!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                : ruleApprovalListData ==
                                                            null ||
                                                        ruleApprovalListData!
                                                            .isEmpty
                                                    ? [
                                                        ApprovalDetailsHelper
                                                            .buildEmptyView(
                                                          "No rule approvers Added",
                                                        ),
                                                      ]
                                                    : [
                                                        ...ruleApprovalListData!
                                                            .map((ra) {
                                                          return ApprovalDetailsHelper
                                                              .buildMiniCardForApproval(
                                                            {
                                                              'Approval Order': ra
                                                                  .approvalOrder
                                                                  .toString(),
                                                              'Approval Status':
                                                                  ra.approvalStatus,
                                                              'User Name':
                                                                  ra.userName,
                                                              'Group Name': ra
                                                                  .userGroupName,
                                                              'Proxy User': ra
                                                                  .proxyUserName,
                                                              'UID Group': ra
                                                                  .uidGroup
                                                                  .toString(),
                                                              'Email': ra.email,
                                                            },
                                                            () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                Routes
                                                                    .showGroupApprovalListRoute,
                                                                arguments: {
                                                                  'id': ra
                                                                      .uidGroup,
                                                                  'from':
                                                                      'rulegroup',
                                                                },
                                                              );
                                                            },
                                                            showIconCondition: (data) =>
                                                                data['UID Group']
                                                                    ?.toString() !=
                                                                "0",
                                                          );
                                                        }).toList(),
                                                      ])
                                        : [],

                                    // PASS isExpanded HERE
                                    isExpanded:
                                        expandedSection == "Rule Approvers",

                                    // Count
                                    count: int.tryParse(
                                        orderDetails!.ruleApproversCount),

                                    // Toggle
                                    toggleSection: () async {
                                      final willExpand =
                                          expandedSection != "Rule Approvers";

                                      setState(() {
                                        expandedSection = willExpand
                                            ? "Rule Approvers"
                                            : null;
                                      });

                                      if (willExpand &&
                                          !isRuleApprovalListLoaded) {
                                        await fetchRuleApprovalListWrapper();
                                      }
                                    },
                                  ),

                                //------------------------ Cost Center Split -----------------------------------------
                                ApprovalDetailsHelper.buildSection(
                                  "Cost Center Split",
                                  Icons.share,

                                  // CHILDREN
                                  expandedSection == "Cost Center Split"
                                      ? (isCostCenterListLoading
                                          ? [
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]
                                          : costCenterListError != null &&
                                                  costCenterListError!
                                                      .isNotEmpty
                                              ? [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Text(
                                                        costCenterListError!,
                                                        style: TextStyle(
                                                            color: ColorManager
                                                                .red),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              : costCenterListData == null ||
                                                      costCenterListData!
                                                          .list.isEmpty
                                                  ? [
                                                      ApprovalDetailsHelper
                                                          .buildEmptyView(
                                                        "No cost center Added",
                                                      ),
                                                    ]
                                                  : costCenterListData!.list
                                                      .map((c) {
                                                      return ApprovalDetailsHelper
                                                          .buildMiniCardForCC(
                                                        {
                                                          'Code': c.costCode,
                                                          'Description':
                                                              c.costDescription,
                                                          'Split Percent':
                                                              "${getFormattedString(c.splitPercentage)}%",
                                                          'Split Value':
                                                              "${getFormattedPriceString(c.splitValue)}",
                                                        },
                                                        onTapMap: {
                                                          'Code': () async {
                                                            await Navigator
                                                                .pushNamed(
                                                              context,
                                                              Routes
                                                                  .ccSplitGrapghViewRoute,
                                                              arguments: {
                                                                'group':
                                                                    'Order',
                                                                'ordReqID':
                                                                    orderDetails!
                                                                        .header
                                                                        .orderNumber,
                                                                'cCId':
                                                                    c.costCode
                                                              },
                                                            );
                                                          },
                                                          'Split Percent': () {
                                                            _showSplitPercentDialog(
                                                                context, c);
                                                          },
                                                        },
                                                        showDelete:
                                                            (costCenterListData!
                                                                    .permission
                                                                    .mode ==
                                                                "RW"),
                                                        onDelete: () =>
                                                            _deleteCostCenterSplit(),
                                                      );
                                                    }).toList())
                                      : [],

                                  // COUNT
                                  count: int.tryParse(
                                      orderDetails!.costcenterCount),

                                  // EXPANDED STATE
                                  isExpanded:
                                      expandedSection == "Cost Center Split",

                                  // TOGGLE
                                  toggleSection: () async {
                                    final willExpand =
                                        expandedSection != "Cost Center Split";

                                    setState(() {
                                      expandedSection = willExpand
                                          ? "Cost Center Split"
                                          : null;
                                    });

                                    if (willExpand && !isCostCenterListLoaded) {
                                      await fetchCostCenterListWrapper();
                                    }
                                  },

                                  // ADD BUTTON
                                  trailing: (costCenterListData != null &&
                                          costCenterListData!.permission.mode ==
                                              "RW")
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: ColorManager.blue,
                                            // borderRadius:
                                            //     BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add,
                                                color: Colors.white, size: 22),
                                          ),
                                        )
                                      : null,

                                  onTrailingTap: (costCenterListData != null &&
                                          costCenterListData!.permission.mode ==
                                              "RW")
                                      ? _addNewCostCenterSplit
                                      : null,
                                ),
                                //----------------------------------------------------- Cost Center Approvers --------------------------------------------------------------

                                if (SharedPrefs().sysCostCentreApproval == true)
                                  ApprovalDetailsHelper.buildSection(
                                    "Cost Center Approvers",
                                    FontAwesomeIcons.userCheck,

                                    // CHILDREN
                                    expandedSection == "Cost Center Approvers"
                                        ? (isCostCenterApproversListLoading
                                            ? [
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ]
                                            : (costCenterApproversListError !=
                                                        null &&
                                                    costCenterApproversListError!
                                                        .isNotEmpty)
                                                ? [
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Text(
                                                          costCenterApproversListError!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                : (ccApprovalData == null ||
                                                        ccApprovalData!
                                                            .list.isEmpty)
                                                    ? [
                                                        ApprovalDetailsHelper
                                                            .buildEmptyView(
                                                          "No cost center Added",
                                                        ),
                                                      ]
                                                    : ccApprovalData!.list
                                                        .map((cc) {
                                                        return ApprovalDetailsHelper
                                                            .buildMiniCard1(
                                                          {
                                                            'Rank': cc.rank,
                                                            'Approval':
                                                                cc.approval,
                                                            'Name': cc.userName,
                                                            'Telephone':
                                                                cc.telephone,
                                                            'Extensions':
                                                                cc.extension,
                                                            'Email': cc.email,
                                                            'Proxy For':
                                                                cc.uidProxy,
                                                          },
                                                          // DELETE SHOW ONLY WHEN permission.mode = RW
                                                          showDelete:
                                                              (ccApprovalData !=
                                                                      null &&
                                                                  ccApprovalData!
                                                                          .permission
                                                                          .mode ==
                                                                      "RW"),
                                                          onDelete: () =>
                                                              _deleteCostCenterSplit(),
                                                        );
                                                      }).toList())
                                        : [],

                                    // COUNT
                                    count: int.tryParse(
                                        orderDetails!.approverCount),

                                    // EXPANDED STATE
                                    isExpanded: expandedSection ==
                                        "Cost Center Approvers",

                                    // TOGGLE
                                    toggleSection: () async {
                                      final willExpand = expandedSection !=
                                          "Cost Center Approvers";

                                      setState(() {
                                        expandedSection = willExpand
                                            ? "Cost Center Approvers"
                                            : null;
                                      });

                                      if (willExpand &&
                                          !isCostCenterApproversListLoaded) {
                                        await fetchCostCenterApproversListWrapper();
                                      }
                                    },

                                    // TRAILING (+ BUTTON) — SAFE CHECK
                                    trailing: (ccApprovalData != null &&
                                            ccApprovalData!.permission.mode ==
                                                "RW")
                                        ? Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: ColorManager.blue,
                                              // borderRadius:
                                              //     BorderRadius.circular(20),
                                            ),
                                            child: const Center(
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 22),
                                            ),
                                          )
                                        : null,

                                    // TAP HANDLER WHEN BUTTON VISIBLE
                                    onTrailingTap: (ccApprovalData != null &&
                                            ccApprovalData!.permission.mode ==
                                                "RW")
                                        ? _addNewCCApproval
                                        : null,
                                  ),

                                //----------------------------------------------- Group Approvers ----------------------------------------------
                                if (SharedPrefs().sysGroupApproval == true)
                                  ApprovalDetailsHelper.buildSection(
                                    "Group Approvers",
                                    Icons.groups,

                                    // CHILDREN (show only when expanded)
                                    expandedSection == "Group Approvers"
                                        ? (isGroupApproversListLoading
                                            ? [
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ]
                                            : groupApproversListError != null &&
                                                    groupApproversListError!
                                                        .isNotEmpty
                                                ? [
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Text(
                                                          groupApproversListError!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                : groupApproversListData ==
                                                            null ||
                                                        groupApproversListData!
                                                            .list.isEmpty
                                                    ? [
                                                        ApprovalDetailsHelper
                                                            .buildEmptyView(
                                                                "No Group Approvers Added"),
                                                      ]
                                                    : groupApproversListData!
                                                        .list
                                                        .map((g) {
                                                        return ApprovalDetailsHelper
                                                            .buildMiniCardForApproval1(
                                                          {
                                                            'UserGroup':
                                                                g.groupCode,
                                                            'Approval':
                                                                g.approval,
                                                            'Mandatory':
                                                                g.mandatory,
                                                          },
                                                          () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    ShowGroupApprovalList(
                                                                  id: g
                                                                      .userGroupId,
                                                                  from: 'group',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          showDelete:
                                                              (groupApproversListData!
                                                                      .permission
                                                                      .mode ==
                                                                  "RW"),
                                                          onDelete: () =>
                                                              _deleteCostCenterSplit(),
                                                        );
                                                      }).toList())
                                        : [],

                                    // COUNT
                                    count: int.tryParse(
                                        orderDetails!.grpapproverCount),

                                    // CURRENT EXPANDED STATUS
                                    isExpanded:
                                        expandedSection == "Group Approvers",

                                    // TOGGLE + API CALL
                                    toggleSection: () async {
                                      final willExpand =
                                          expandedSection != "Group Approvers";

                                      setState(() {
                                        expandedSection = willExpand
                                            ? "Group Approvers"
                                            : null;
                                      });

                                      // Call API only once
                                      if (willExpand &&
                                          !isGroupApproversListLoaded) {
                                        await fetchGroupApproversListWrapper();
                                      }
                                    },

                                    // TRAILING (+ BUTTON)
                                    trailing: (groupApproversListData != null &&
                                            groupApproversListData!
                                                    .permission.mode ==
                                                "RW")
                                        ? Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: ColorManager.blue,
                                              // borderRadius:
                                              //     BorderRadius.circular(20),
                                            ),
                                            child: const Center(
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 22),
                                            ),
                                          )
                                        : null,

                                    onTrailingTap:
                                        (groupApproversListData != null &&
                                                groupApproversListData!
                                                        .permission.mode ==
                                                    "RW")
                                            ? _addNewGroupApproval
                                            : null,
                                  ),
                                //----------------------------------------------------------------------------------Attachment------------------------------------------------------------------------------------
                                ApprovalDetailsHelper.buildSection(
                                  "Attachments",
                                  FontAwesomeIcons.link,

                                  // CHILDREN (show only when expanded)
                                  expandedSection == "Attachments"
                                      ? (isAttachmentListLoading
                                          ? [
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]
                                          : attachmentListError != null &&
                                                  attachmentListError!
                                                      .isNotEmpty
                                              ? [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Text(
                                                        attachmentListError!,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              : attachmentData == null ||
                                                      attachmentData!
                                                          .list.isEmpty
                                                  ? [
                                                      ApprovalDetailsHelper
                                                          .buildEmptyView(
                                                              "No Attachments Added"),
                                                    ]
                                                  : attachmentData!.list
                                                      .map((attach) {
                                                      return ApprovalDetailsHelper
                                                          .buildMiniCardForAttachment(
                                                        {
                                                          'File Name': attach
                                                              .documentFileName,
                                                          'File privacy': attach
                                                              .docPrivacyText,
                                                          'Discription': attach
                                                                      .documentDescription
                                                                      .length >
                                                                  50
                                                              ? '${attach.documentDescription.substring(0, 50)}...'
                                                              : attach
                                                                  .documentDescription,
                                                          'Entry Date':
                                                              attach.docStamp,
                                                          'Entered By':
                                                              attach.enteredBy,
                                                        },
                                                        onFileTap: () => downloadFile(
                                                            attach
                                                                .documentFileName,
                                                            attach.documentImg),
                                                        showDelete:
                                                            (attachmentData!
                                                                    .permission
                                                                    .mode ==
                                                                "RW"),
                                                        onDelete: () =>
                                                            _deleteCostCenterSplit(),
                                                      );
                                                    }).toList())
                                      : [],

                                  // COUNT
                                  count: int.tryParse(
                                      orderDetails!.attachdocCount),

                                  // CURRENT EXPANDED STATUS
                                  isExpanded: expandedSection == "Attachments",

                                  // TOGGLE + API CALL
                                  toggleSection: () async {
                                    final willExpand =
                                        expandedSection != "Attachments";

                                    setState(() {
                                      expandedSection =
                                          willExpand ? "Attachments" : null;
                                    });

                                    // Call API only once
                                    if (willExpand && !isAttachmentListLoaded) {
                                      await fetchAttachmentListWrapper();
                                    }
                                  },

                                  // TRAILING (+ BUTTON)
                                  trailing: (attachmentData != null &&
                                          attachmentData!.permission.mode ==
                                              "RW")
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: ColorManager.blue,
                                            // borderRadius:
                                            //     BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add,
                                                color: Colors.white, size: 22),
                                          ),
                                        )
                                      : null,

                                  onTrailingTap: (attachmentData != null &&
                                          attachmentData!.permission.mode ==
                                              "RW")
                                      ? _addNewAttachment
                                      : null,
                                ),

                                //---------------------------------------------------------------------------Terms and conditions--------------------------------------------------------
                                ApprovalDetailsHelper.buildSection(
                                  "Terms & Condition",
                                  FontAwesomeIcons.file,

                                  // CHILDREN (show only when expanded)
                                  expandedSection == "Terms & Condition"
                                      ? (isTermsListLoading
                                          ? [
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]
                                          : termsListError != null &&
                                                  termsListError!.isNotEmpty
                                              ? [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Text(
                                                        termsListError!,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              : termListData == null ||
                                                      termListData!.list.isEmpty
                                                  ? [
                                                      ApprovalDetailsHelper
                                                          .buildEmptyView(
                                                              "No Terms & Condition Added"),
                                                    ]
                                                  : termListData!.list.map((t) {
                                                      return ApprovalDetailsHelper
                                                          .buildMiniCard1(
                                                        {
                                                          'Item': t.itemIndex,
                                                          'Code': t.textCode,
                                                          'Outline': t.textOutline
                                                                      .length >
                                                                  50
                                                              ? '${t.textOutline.substring(0, 50)}...'
                                                              : t.textOutline,
                                                          'Entry Date':
                                                              t.orderStamp,
                                                        },
                                                        showDelete:
                                                            (termListData!
                                                                    .permission
                                                                    .mode ==
                                                                "RW"),
                                                        onDelete: () =>
                                                            _deleteCostCenterSplit(),
                                                      );
                                                    }).toList())
                                      : [],

                                  // COUNT
                                  count: int.tryParse(orderDetails!.termsCount),

                                  // CURRENT EXPANDED STATUS
                                  isExpanded:
                                      expandedSection == "Terms & Condition",

                                  // TOGGLE + API CALL
                                  toggleSection: () async {
                                    final willExpand =
                                        expandedSection != "Terms & Condition";

                                    setState(() {
                                      expandedSection = willExpand
                                          ? "Terms & Condition"
                                          : null;
                                    });

                                    // Call API only once
                                    if (willExpand && !isTermsListLoaded) {
                                      await fetchTermsListWrapper();
                                    }
                                  },

                                  // TRAILING (+ BUTTON)
                                  trailing: (termListData != null &&
                                          termListData!.permission.mode == "RW")
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: ColorManager.blue,
                                            // borderRadius:
                                            //     BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add,
                                                color: Colors.white, size: 22),
                                          ),
                                        )
                                      : null,

                                  onTrailingTap: (termListData != null &&
                                          termListData!.permission.mode == "RW")
                                      ? _termsAndCondition
                                      : null,
                                ),
                                //---------------------------------------------------------------------------Notes--------------------------------------------------------
                                ApprovalDetailsHelper.buildSection(
                                  "Notes",
                                  Icons.attach_file,

                                  // CHILDREN (show only when expanded)
                                  expandedSection == "Notes"
                                      ? (isNotesListLoading
                                          ? [
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]
                                          : notesListError != null &&
                                                  notesListError!.isNotEmpty
                                              ? [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Text(
                                                        notesListError!,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              : noteData == null ||
                                                      noteData!.list.isEmpty
                                                  ? [
                                                      ApprovalDetailsHelper
                                                          .buildEmptyView(
                                                              "No Notes Added"),
                                                    ]
                                                  : noteData!.list.map((n) {
                                                      return ApprovalDetailsHelper
                                                          .buildMiniCard1(
                                                        {
                                                          'Notes': n.notes
                                                                      .length >
                                                                  50
                                                              ? '${n.notes.substring(0, 50)}...'
                                                              : n.notes,
                                                          'Entry Date':
                                                              n.entryDate,
                                                          'Entered By':
                                                              n.enteredBy,
                                                          'Note Privacy':
                                                              n.notePrivacyText,
                                                        },
                                                        showDelete: (noteData!
                                                                .permission
                                                                .mode ==
                                                            "RW"),
                                                        onTap: () async {
                                                          final result =
                                                              await Navigator
                                                                  .pushNamed(
                                                            context,
                                                            Routes
                                                                .notesViewRoute,
                                                            arguments: {
                                                              'noteId':
                                                                  n.notesId,
                                                              'group': 'Order',
                                                              'ordReqID':
                                                                  orderDetails!
                                                                      .header
                                                                      .orderId,
                                                            },
                                                          );

                                                          // Refresh notes list ONLY if note was saved
                                                          if (result == true) {
                                                            fetchNotesListWrapper();
                                                          }
                                                        },
                                                        onDelete: () =>
                                                            _deleteCostCenterSplit(),
                                                      );
                                                    }).toList())
                                      : [],

                                  // COUNT
                                  count: int.tryParse(orderDetails!.notesCount),

                                  // CURRENT EXPANDED STATUS
                                  isExpanded: expandedSection == "Notes",

                                  // TOGGLE + API CALL
                                  toggleSection: () async {
                                    final willExpand =
                                        expandedSection != "Notes";

                                    setState(() {
                                      expandedSection =
                                          willExpand ? "Notes" : null;
                                    });

                                    // Call API only once
                                    if (willExpand && !isNotesListLoaded) {
                                      await fetchNotesListWrapper();
                                    }
                                  },

                                  // TRAILING (+ BUTTON)
                                  trailing: (noteData != null &&
                                          noteData!.permission.mode == "RW")
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: ColorManager.blue,
                                            // borderRadius:
                                            //     BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add,
                                                color: Colors.white, size: 22),
                                          ),
                                        )
                                      : null,

                                  onTrailingTap: (noteData != null &&
                                          noteData!.permission.mode == "RW")
                                      ? _addNewNotes
                                      : null,
                                ),
                                //---------------------------------------------Event Log-------------------------------------------------------------------------------
                                ApprovalDetailsHelper.buildSection(
                                  "Event Log",
                                  Icons.history,

                                  // CHILDREN
                                  expandedSection == "Event Log"
                                      ? (isLogsListLoading
                                          ? [
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]
                                          : (logsListError != null &&
                                                  logsListError!.isNotEmpty)
                                              ? [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Text(
                                                        logsListError!,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              : logsListData == null ||
                                                      logsListData!.isEmpty
                                                  ? [
                                                      ApprovalDetailsHelper
                                                          .buildEmptyView(
                                                        "No events Added",
                                                      ),
                                                    ]
                                                  : logsListData!
                                                      .asMap()
                                                      .entries
                                                      .map((entry) {
                                                      final index = entry.key;
                                                      final e = entry.value;

                                                      return ApprovalDetailsHelper
                                                          .buildMiniCard({
                                                        'Event Date':
                                                            e.eventDate,
                                                        'User': e.eventUser,
                                                        'Event': e.event,
                                                      });
                                                    }).toList())
                                      : [],

                                  // Expanded
                                  isExpanded: expandedSection == "Event Log",

                                  // Count
                                  count: int.tryParse(orderDetails!.logCount),

                                  // Toggle
                                  toggleSection: () async {
                                    final willExpand =
                                        expandedSection != "Event Log";

                                    setState(() {
                                      expandedSection =
                                          willExpand ? "Event Log" : null;
                                    });

                                    if (willExpand && !isLogsListLoaded) {
                                      await fetchLogsListWrapper();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

//---------------------------------Buttons----------------------------------------------------
                    // Container(
                    //   color: ColorManager.white,
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 16, vertical: 12),
                    //   child:
                    //       // OrderActionButtonsHelper.buildButtons(
                    //       //   context: context,
                    //       //   status: orderDetails!.header.orderStatus,
                    //       //   orderNumber: orderDetails!.header.orderNumber,
                    //       //   onApprove: orderApprovalApproved,
                    //       //   onReject: (reason) => orderApprovalReject(reason),
                    //       //   onSubmitForApproval: _submitForApproval,
                    //       //   onIssueOrder: _issueOrder,
                    //       //   onReIssueOrder: _reIssueOrder,
                    //       // ),
                    //       DynamicOrderButtonBuilder.build(
                    //     context: context,
                    //     buttonName: orderDetails!.buttonName,
                    //     buttonAction: orderDetails!.buttonAction,
                    //     buttonAlert: orderDetails!.buttonAlert,
                    //     onApprove: orderApprovalApproved,
                    //     onReject: (reason) => orderApprovalReject(reason),
                    //     onSubmitForApproval: _submitForApproval,
                    //     onIssueOrder: _issueOrder,
                    //     onReIssueOrder: _reIssueOrder,
                    //   ),
                    // ),
                  ],
                ),
    );
  }
}
