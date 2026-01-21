import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/attachement_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/cost_center_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/header_response.dart';
import 'package:eyvo_v3/api/response_models/line_item_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/log_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/notes_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/order_approval_details_response.dart';
import 'package:eyvo_v3/api/response_models/request_approval_details_response.dart';
import 'package:eyvo_v3/api/response_models/rule_approval_response_model.dart';
import 'package:eyvo_v3/api/response_models/rule_list_response_model.dart';
import 'package:eyvo_v3/api/response_models/term_list_response_model.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/routes_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as PH;

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
  bool isLineItemsLoading = false;
  bool isLineItemsLoaded = false;
  String? lineItemsError;
  LineItemListResponseData? lineItemListData;
  OrderDetailsResponseData? orderDetails;
  String? ruleListError;
  bool isRuleListLoading = false;
  bool isRuleListLoaded = false;
  List<GetRuleResponseData> ruleListData = [];
  bool isRuleApprovalListLoading = false;
  bool isRuleApprovalListLoaded = false;
  String? ruleApprovalListError;
  List<RuleApprovalResponseData> ruleApprovalListData = [];
  bool isCostCenterListLoading = false;
  bool isCostCenterListLoaded = false;
  String? costCenterListError;
  CostCenterListResponseData? costCenterListData;
  bool isAttachmentListLoading = false;
  bool isAttachmentListLoaded = false;
  String? attachmentListError;
  AttachmentData? attachmentData;
  bool isTermsListLoading = false;
  bool isTermsListLoaded = false;
  String? termsListError;
  TermListResponseData? termListData;
  bool isNotesListLoading = false;
  bool isNotesListLoaded = false;
  String? notesListError;
  NotesData? noteData;
  bool isLogsListLoading = false;
  bool isLogsListLoaded = false;
  String? logsListError;
  List<LogListResponseData>? logsListData;

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
          'ID': requestDetails!.header.requestId,
          'group': 'Request',
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

  void _addNewCostCenterSplit() {
    Navigator.pushNamed(
      context,
      Routes.costCenterSplitRoute,
      arguments: {
        'group': 'Request',
        'ordReqID': requestDetails!.header.requestId,
      },
    ).then((result) {
      if (result == true) {
        fetchCostCenterListWrapper();
      }
    });
    //navigateToScreen(context, BudgetGraphPage());

    // Navigator.pushNamed(
    //   context,
    //   Routes.budgetGraphRoute,
    //   arguments: {
    //     'costCentreId': 0,
    //     'group': 'Request',
    //     'ordReqID': requestDetails!.header.requestId,
    //   },
    // );
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

  void _termsAndCondition() {
    Navigator.pushNamed(
      context,
      Routes.termsAndConditionRoute,
      arguments: {
        'group': 'Request',
        'entityID': requestDetails!.header.requestId,
      },
    ).then((result) {
      if (result == true) {
        fetchTermsListWrapper();
      }
    });
  }

  void _addNewNotes() {
    Navigator.pushNamed(
      context,
      Routes.notesViewRoute,
      arguments: {
        'noteId': 0,
        'group': 'Request',
        'ordReqID': requestDetails!.header.requestId,
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
        'group': 'Request',
        'ordReqID': requestDetails!.header.requestId,
      },
    ).then((result) {
      if (result == true) {
        fetchAttachmentListWrapper();
      }
    });
    LoggerData.dataLog('${requestDetails!.header.requestId}###########');
  }

  void _deleteCostCenterSplit() {
    LoggerData.dataPrint("Delete pressed");
    // Add your API or logic here
  }

  void _deleteAllCostCenterSplit() {
    LoggerData.dataPrint("Delete All pressed");
    // Add your API or logic here
  }

  void _addNewLineItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaseLineView(
          id: widget.requestId,
          lineId: 0,
          lineType: LineType.request,
          appBarTitle: "Request Line",
          buttonshow: true,
        ),
      ),
    ).then((_) {
      // Refresh after adding
      fetchLineItemsWrapper();
    });
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
                                                      const EdgeInsets.all(16),
                                                  child: Text(
                                                    lineItemsError!,
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              )
                                            ]
                                          : lineItemListData == null ||
                                                  lineItemListData!.list.isEmpty
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
                                                      'Item No':
                                                          lineItem.itemOrder,
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
                                                    },
                                                            showDelete:
                                                                lineItemListData!
                                                                        .permission
                                                                        .mode ==
                                                                    "RW",
                                                            onDelete: () =>
                                                                _deleteCostCenterSplit(),
                                                            () {
                                                      navigateToScreen(
                                                        context,
                                                        BaseLineView(
                                                          id: widget.requestId,
                                                          lineId: lineItem
                                                              .orderLineId,
                                                          lineType:
                                                              LineType.request,
                                                          appBarTitle:
                                                              "Request Line",
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
                                                        'Request Total Summary',
                                                    netTotalLabel:
                                                        'Total Net Amount',
                                                    salesTaxLabel: 'Total Tax',
                                                    grossTotalLabel:
                                                        'Request Gross Amount',
                                                    currencyLabel:
                                                        'Request Currency',
                                                  ),
                                                ])
                                  : [],

                              //  PASS isExpanded HERE
                              isExpanded: expandedSection == "Line Items",

                              // Count
                              //count: int.tryParse(orderDetails!.lineItemsCount),

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
                              trailing: (lineItemListData != null &&
                                      lineItemListData!.permission.mode == "RW")
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// ADD
                                        InkWell(
                                          onTap: _addNewLineItem,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.blue,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),

                                        /// DELETE ALL
                                        InkWell(
                                          onTap: _deleteAllCostCenterSplit,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            // margin:
                                            //     const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),

// ---------------------------------------------------------------------- RULES -------------------------------------------------------------------

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
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Text(
                                                      ruleListError!,
                                                      style: const TextStyle(
                                                          color: Colors.red),
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
                                                    ...ruleListData!.map((r) {
                                                      return ApprovalDetailsHelper
                                                          .buildMiniCard({
                                                        'Rule Name': r.ruleName,
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
                                //count: int.tryParse(orderDetails!.ruleCount),

                                // Toggle Section
                                toggleSection: () async {
                                  final willExpand = expandedSection != "Rules";

                                  setState(() {
                                    expandedSection =
                                        willExpand ? "Rules" : null;
                                  });

                                  if (willExpand && !isRuleListLoaded) {
                                    await fetchRulelistWrapper();
                                  }
                                },
                              ),

// ---------------------------------------------- RULE APPROVERS ----------------------------------------------------------

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
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Text(
                                                        ruleApprovalListError!,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              : ruleApprovalListData == null ||
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
                                                            'Approval Status': ra
                                                                .approvalStatus,
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
                                                            Navigator.pushNamed(
                                                              context,
                                                              Routes
                                                                  .showGroupApprovalListRoute,
                                                              arguments: {
                                                                'id':
                                                                    ra.uidGroup,
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
                                  // count: int.tryParse(orderDetails!.ruleApproversCount),

                                  // Toggle
                                  toggleSection: () async {
                                final willExpand =
                                    expandedSection != "Rule Approvers";

                                setState(() {
                                  expandedSection =
                                      willExpand ? "Rule Approvers" : null;
                                });

                                if (willExpand && !isRuleApprovalListLoaded) {
                                  await fetchRuleApprovalListWrapper();
                                }
                              },
                                  trailing:
                                      //(ruleApprovalListData != null &&
                                      //         ruleApprovalListData!.permission.mode ==
                                      //             "RW")
                                      //?
                                      Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /// ADD
                                      InkWell(
                                        onTap: _addNewCostCenterSplit,
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: ColorManager.blue,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: ColorManager.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),

                                      /// DELETE ALL
                                      InkWell(
                                        onTap: _deleteAllCostCenterSplit,
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          // margin:
                                          //     const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: ColorManager.red,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.trashCan,
                                            color: ColorManager.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  // : null,
                                  ),

//-------------------------------------------------------------------- COST CENTERS ------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
                                              costCenterListError!.isNotEmpty
                                          ? [
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Text(
                                                    costCenterListError!,
                                                    style: const TextStyle(
                                                        color: Colors.red),
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
                                                    showDelete:
                                                        (costCenterListData!
                                                                .permission
                                                                .mode ==
                                                            "RW"),
                                                    onTapMap: {
                                                      'Code': () async {
                                                        // await Navigator
                                                        //     .pushNamed(
                                                        //   context,
                                                        //   Routes
                                                        //       .ccSplitGrapghViewRoute,
                                                        //   arguments: {
                                                        //     'group': 'Order',
                                                        //     'ordReqID':
                                                        //         orderDetails!
                                                        //             .header
                                                        //             .orderNumber,
                                                        //     'cCId': c.costCode
                                                        //   },
                                                        // );
                                                      },
                                                      'Split Percent': () {
                                                        _showSplitPercentDialog(
                                                            context, c);
                                                      },
                                                    },
                                                    onDelete: () =>
                                                        _deleteCostCenterSplit(),
                                                  );
                                                }).toList())
                                  : [],

                              // COUNT
                              // count:int.tryParse(orderDetails!.costcenterCount),

                              // EXPANDED STATE
                              isExpanded:
                                  expandedSection == "Cost Center Split",

                              // TOGGLE
                              toggleSection: () async {
                                final willExpand =
                                    expandedSection != "Cost Center Split";

                                setState(() {
                                  expandedSection =
                                      willExpand ? "Cost Center Split" : null;
                                });

                                if (willExpand && !isCostCenterListLoaded) {
                                  await fetchCostCenterListWrapper();
                                }
                              },

                              trailing: (costCenterListData != null &&
                                      costCenterListData!.permission.mode ==
                                          "RW")
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// ADD
                                        InkWell(
                                          onTap: _addNewCostCenterSplit,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.blue,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),

                                        /// DELETE ALL
                                        InkWell(
                                          onTap: _deleteAllCostCenterSplit,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            // margin:
                                            //     const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),

// -------------------- ATTACHMENTS --------------------

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
                                              attachmentListError!.isNotEmpty
                                          ? [
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Text(
                                                    attachmentListError!,
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              )
                                            ]
                                          : attachmentData == null ||
                                                  attachmentData!.list.isEmpty
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
                                                      'File privacy':
                                                          attach.docPrivacyText,
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
                                                        attach.documentFileName,
                                                        attach.documentImg),
                                                    showDelete: (attachmentData!
                                                            .permission.mode ==
                                                        "RW"),
                                                    onDelete: () =>
                                                        _deleteCostCenterSplit(),
                                                  );
                                                }).toList())
                                  : [],

                              // COUNT
                              //count: int.tryParse(orderDetails!.attachdocCount),

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
                              trailing: (attachmentData != null &&
                                      attachmentData!.permission.mode == "RW")
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// ADD
                                        InkWell(
                                          onTap: _addNewAttachment,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.blue,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),

                                        /// DELETE ALL
                                        InkWell(
                                          onTap: _deleteAllCostCenterSplit,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            // margin:
                                            //     const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
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
                                                      const EdgeInsets.all(16),
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
                                                    showDelete: (termListData!
                                                            .permission.mode ==
                                                        "RW"),
                                                    onDelete: () =>
                                                        _deleteCostCenterSplit(),
                                                  );
                                                }).toList())
                                  : [],

                              // COUNT
                              //count: int.tryParse(orderDetails!.termsCount),

                              // CURRENT EXPANDED STATUS
                              isExpanded:
                                  expandedSection == "Terms & Condition",

                              // TOGGLE + API CALL
                              toggleSection: () async {
                                final willExpand =
                                    expandedSection != "Terms & Condition";

                                setState(() {
                                  expandedSection =
                                      willExpand ? "Terms & Condition" : null;
                                });

                                // Call API only once
                                if (willExpand && !isTermsListLoaded) {
                                  await fetchTermsListWrapper();
                                }
                              },
                              trailing: (termListData != null &&
                                      termListData!.permission.mode == "RW")
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// ADD
                                        InkWell(
                                          onTap: _termsAndCondition,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.blue,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),

                                        /// DELETE ALL
                                        InkWell(
                                          onTap: _deleteAllCostCenterSplit,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            // margin:
                                            //     const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),

                            //----------------------------------Notes------------------------------------------------------

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
                                                      const EdgeInsets.all(16),
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
                                                      'Notes': n.notes.length >
                                                              50
                                                          ? '${n.notes.substring(0, 50)}...'
                                                          : n.notes,
                                                      'Entry Date': n.entryDate,
                                                      'Entered By': n.enteredBy,
                                                      'Note Privacy':
                                                          n.notePrivacyText,
                                                    },
                                                    showDelete: (noteData!
                                                            .permission.mode ==
                                                        "RW"),
                                                    onTap: () async {
                                                      final result =
                                                          await Navigator
                                                              .pushNamed(
                                                        context,
                                                        Routes.notesViewRoute,
                                                        arguments: {
                                                          'noteId': n.notesId,
                                                          'group': 'Request',
                                                          'ordReqID':
                                                              requestDetails!
                                                                  .header
                                                                  .requestId,
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
                              // count: int.tryParse(orderDetails!.notesCount),

                              // CURRENT EXPANDED STATUS
                              isExpanded: expandedSection == "Notes",

                              // TOGGLE + API CALL
                              toggleSection: () async {
                                final willExpand = expandedSection != "Notes";

                                setState(() {
                                  expandedSection = willExpand ? "Notes" : null;
                                });

                                // Call API only once
                                if (willExpand && !isNotesListLoaded) {
                                  await fetchNotesListWrapper();
                                }
                              },
                              trailing: (noteData != null &&
                                      noteData!.permission.mode == "RW")
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// ADD
                                        InkWell(
                                          onTap: _addNewNotes,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.blue,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),

                                        /// DELETE ALL
                                        InkWell(
                                          onTap: _deleteAllCostCenterSplit,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            // margin:
                                            //     const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: ColorManager.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: ColorManager.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),

// -------------------- EVENT LOG --------------------
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
                                                      const EdgeInsets.all(16),
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
                                                    'Event Date': e.eventDate,
                                                    'User': e.eventUser,
                                                    'Event': e.event,
                                                  });
                                                }).toList())
                                  : [],

                              // Expanded
                              isExpanded: expandedSection == "Event Log",

                              // Count
                              //count: int.tryParse(orderDetails!.logCount),

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
