import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/dropdown_response_model.dart';
import 'package:eyvo_v3/api/response_models/note_details_response_model.dart';
import 'package:eyvo_v3/api/response_models/order_header_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
import 'package:eyvo_v3/core/widgets/searchable_dropdown_modal.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';

class BaseHeaderView extends StatefulWidget {
  final int? id;
  final int? number;
  final HeaderType headerType;
  final String appBarTitle;
  final bool? buttonshow;
  final bool? constantFieldshow;
  final String? status;
  final String? date;

  const BaseHeaderView({
    Key? key,
    required this.id,
    required this.number,
    required this.headerType,
    required this.appBarTitle,
    this.buttonshow,
    this.constantFieldshow,
    this.status,
    this.date,
  }) : super(key: key);

  @override
  State<BaseHeaderView> createState() => _BaseHeaderViewState();
}

enum HeaderType {
  order,
  request,
}

class _BaseHeaderViewState extends State<BaseHeaderView> {
  // Text Controllers
  final TextEditingController _refNoController = TextEditingController();
  final TextEditingController _deliverToController = TextEditingController();
  final TextEditingController _deliverIncoterms = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _shipViaController = TextEditingController();
  final TextEditingController _justificationController =
      TextEditingController();
  final TextEditingController _paymentTermsController = TextEditingController();
  final TextEditingController _requestDescriptionController =
      TextEditingController();
  final TextEditingController _requestBudgetController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  CreateHeaderResponse? apiResponse;
  bool isLoading = true;
  List<Datum>? headerData;
  Map<String, bool> fieldVisible = {};
  Map<String, bool> fieldRequired = {};
  Map<String, bool> fieldReadOnly = {};
  Map<String, String> fieldLabels = {};

  // Dropdown Id
  String? _selectedSupplierCodeId;
  String? _selectedDeliveryCodeId;
  String? _selectedBudgetId;
  String? _selectedContactNumberId;
  String? _selectedRestaurentId;
  String? _selectedAccountId;
  String? _selectedInvoiceCodeId;
  String? _selectedDocumentTypeId;
  String? _selectedCategoryCodeId;
  String? _selectedCustomerId;
  String? _selectedSupplierContactId;
  String? _selectedContractNumberId;
  String? _selectDepartmentCodeId;

  // Dropdown Value
  String? _selectedSupplierCodeValue;
  String? _selectedDeliveryCodeValue;
  String? _selectedBudgetValue;
  String? _selectedContactNumberValue;
  String? _selectedRestaurentValue;
  String? _selectedAccountValue;
  String? _selectedInvoiceCodeValue;
  String? _selectedDocumentTypeValue;
  String? _selectedCategoryCodeValue;
  String? _selectedCustomerValue;
  String? _selectedSupplierContactValue;
  String? _selectedContractNumberValue;
  String? _selectDepartmentCodeValue;
  Map<String, bool> fieldErrors = {};
  @override
  void initState() {
    super.initState();
    fetchHeader();
  }

  // Dropdown Data - These can be replaced with API calls

  String _getGroupName() {
    return widget.headerType == HeaderType.order ? 'Order' : 'Request';
  }

  String _getHeaderPrefix() {
    return widget.headerType == HeaderType.order ? 'Order' : 'Request';
  }

  Future<void> fetchHeader() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final jsonResponse = await apiService.postRequest(
        context,
        ApiService.createHeader,
        {
          'uid': SharedPrefs().uID,
          'apptype': AppConstants.apptype,
          'ID': widget.id,
          'LineID': 0,
          'group': _getGroupName(),
          'section': 'Header',
          'apptype': 'mobile',
        },
      );

      if (jsonResponse == null) {
        setState(() {
          isError = true;
          errorText = "No response from server";
          isLoading = false;
        });
        return;
      }

      final resp = CreateHeaderResponse.fromJson(jsonResponse);

      if (resp.code == 200 && resp.data != null) {
        setState(() {
          apiResponse = resp;
          headerData = resp.data;
          isLoading = false;

          // Reset old data
          fieldVisible.clear();
          fieldRequired.clear();
          fieldReadOnly.clear();

          // Parse each field dynamically
          for (var field in resp.data!) {
            // Store field-level properties
            fieldVisible[field.fieldId] = field.visible;
            fieldRequired[field.fieldId] = field.required;
            fieldReadOnly[field.fieldId] = !field.readWrite;
            fieldLabels[field.fieldId] = field.labelName;

            // Assign values and handle visibility
            _assignFieldValue(field);
          }
        });
      } else {
        setState(() {
          isError = true;
          errorText = resp.message?.join(', ') ?? "Failed to fetch data";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        errorText = "Something went wrong: $e";
        isLoading = false;
      });
    }
  }

  // for fetching dropdown data
  Future<List<DropdownItem>> _fetchDropdownData(
    String group, {
    String search = "",
    int id = 0,
  }) async {
    try {
      final response = await apiService.getDropdownData(
        context: context,
        group: group,
        search: search,
        id: id ?? 0,
      );

      if (response != null) {
        final dropdownResponse = DropdownDataResponse.fromJson(response);
        if (dropdownResponse.code == 200 && dropdownResponse.data != null) {
          return dropdownResponse.data!
              .map((item) => item.toDropdownItem())
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching $group dropdown: $e');
    }

    // Return empty list if API fails
    return [];
  }

// Map field IDs to their respective API groups
  String _getGroupForField(String fieldId) {
    switch (fieldId) {
      case "CategoryID":
        return "Category";
      case "SupplierID":
        return "Supplier";
      case "DeliveryID":
        return "Delivery";
      case "OrderTypeID":
        return "OrderType";
      case "InvoicePtID":
        return "InvoicePt";
      case "ExpCode1_ID":
        return "ExpCode1";
      case "ExpCode2_ID":
        return "ExpCode2";
      case "ExpCode3_ID":
        return "ExpCode3";
      case "Cust_ID":
        return "Customer";
      case "ContractID":
        return "contracts";
      case "Order_Budget_Header":
        return "Budgets";
      case "Supp_Cont_ID":
        return "contacts";
      default:
        return "";
    }
  }

  Future<List<DropdownItem>> getCategoryCodes({String search = ""}) async {
    return await _fetchDropdownData("Category", search: search);
  }

  Future<List<DropdownItem>> getDeliveryCodes({String search = ""}) async {
    return await _fetchDropdownData("Delivery", search: search);
  }

  Future<List<DropdownItem>> getOrderTypeCodes({String search = ""}) async {
    return await _fetchDropdownData("OrderType", search: search);
  }

  Future<List<DropdownItem>> getInvoiceCodes({String search = ""}) async {
    return await _fetchDropdownData("InvoicePt", search: search);
  }

  Future<List<DropdownItem>> getExpenseCode1({String search = ""}) async {
    return await _fetchDropdownData("ExpCode1", search: search);
  }

  Future<List<DropdownItem>> getExpenseCode2({String search = ""}) async {
    return await _fetchDropdownData("ExpCode2", search: search);
  }

  Future<List<DropdownItem>> getSupplierContacts({String search = ""}) async {
    final id =
        _selectedSupplierCodeId == null || _selectedSupplierCodeId!.isEmpty
            ? 0
            : int.tryParse(_selectedSupplierCodeId!) ?? 0;

    return await _fetchDropdownData(
      "contacts",
      search: search,
      id: id,
    );
  }

  Future<List<DropdownItem>> getBudget({String search = ""}) async {
    return await _fetchDropdownData("Budget", search: search);
  }

  Future<List<DropdownItem>> getCustomerCodes({String search = ""}) async {
    return await _fetchDropdownData("Customer", search: search);
  }

  Future<List<DropdownItem>> getContractCodes({String search = ""}) async {
    final id =
        _selectedSupplierCodeId == null || _selectedSupplierCodeId!.isEmpty
            ? 0
            : int.tryParse(_selectedSupplierCodeId!) ?? 0;

    return await _fetchDropdownData(
      "Contract",
      search: search,
      id: id,
    );
  }

  Future<List<DropdownItem>> getDepartmentCodes({String search = ""}) async {
    return await _fetchDropdownData("ExpCode3", search: search);
  }

  Future<List<DropdownItem>> getSupplierCodes({String search = ""}) async {
    return await _fetchDropdownData("Supplier", search: search);
  }

  void _assignFieldValue(Datum field) {
    if (field.visible && field.value.isNotEmpty) {
      switch (field.fieldId) {
        case "ExpCode1_ID":
          _selectedAccountId = field.id.toString();
          _selectedAccountValue = field.value;
          break;
        case "ExpCode2_ID":
          _selectedRestaurentId = field.id.toString();
          _selectedRestaurentValue = field.value;
          break;
        case "ExpCode3_ID":
          _selectDepartmentCodeId = field.id.toString();
          _selectDepartmentCodeValue = field.value;
          break;
        case "InvoicePtID":
          _selectedInvoiceCodeId = field.id.toString();
          _selectedInvoiceCodeValue = field.value;
          break;
        case "OrderTypeID":
          _selectedDocumentTypeId = field.id.toString();
          _selectedDocumentTypeValue = field.value;
          break;
        case "ReferenceNo":
          _refNoController.text = field.value;
          break;
        case "DeliveryID":
          _selectedDeliveryCodeId = field.id.toString();
          _selectedDeliveryCodeValue = field.value;
          break;
        case "Instructions":
          _instructionsController.text = field.value;
          break;
        case "CategoryID":
          _selectedCategoryCodeId = field.id.toString();
          _selectedCategoryCodeValue = field.value;
          break;
        case "Cust_ID":
          _selectedCustomerId = field.id.toString();
          _selectedCustomerValue = field.value;
          break;
        case "FOB":
          _deliverIncoterms.text = field.value;
          break;
        case "Ship_Via":
          _shipViaController.text = field.value;
          break;
        case "Justification":
          _justificationController.text = field.value;
          break;
        case "Order_Budget_Header":
          _selectedBudgetId = field.id.toString();
          _selectedBudgetValue = field.value;
          break;
        case "FAO":
          _deliverToController.text = field.value;
          break;
        case "Payment_Terms":
          _paymentTermsController.text = field.value;
          break;
        case "Supp_Cont_ID":
          _selectedSupplierContactId = field.id.toString();
          _selectedSupplierContactValue = field.value;
          break;
        case "ContractID":
          _selectedContractNumberId = field.id.toString();
          _selectedContractNumberValue = field.value;
          break;
        case "SupplierID":
          _selectedSupplierCodeId = field.id.toString();
          _selectedSupplierCodeValue = field.value;
          break;
      }
    } else if (field.visible) {
      // Handle text fields without values
      switch (field.fieldId) {
        case "ReferenceNo":
          _refNoController.text = field.value;
          break;
        case "Instructions":
          _instructionsController.text = field.value;
          break;
        case "FOB":
          _deliverIncoterms.text = field.value;
          break;
        case "Ship_Via":
          _shipViaController.text = field.value;
          break;
        case "Justification":
          _justificationController.text = field.value;
          break;
        case "FAO":
          _deliverToController.text = field.value;
          break;
        case "Payment_Terms":
          _paymentTermsController.text = field.value;
          break;
      }
    }
  }

  @override
  void dispose() {
    _refNoController.dispose();
    _deliverToController.dispose();
    _deliverIncoterms.dispose();
    _instructionsController.dispose();
    _shipViaController.dispose();
    _justificationController.dispose();
    _paymentTermsController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Map<String, dynamic> fieldValueMap() {
    return {
      // -------- TEXT FIELDS --------
      "ReferenceNo": _refNoController.text.trim(),
      "FAO": _deliverToController.text.trim(),
      "FOB": _deliverIncoterms.text.trim(),
      "Instructions": _instructionsController.text.trim(),
      "Ship_Via": _shipViaController.text.trim(),
      "Justification": _justificationController.text.trim(),
      "Payment_Terms": _paymentTermsController.text.trim(),

      // -------- DROPDOWNS --------
      "SupplierID": _selectedSupplierCodeId,
      "DeliveryID": _selectedDeliveryCodeId,
      "CategoryID": _selectedCategoryCodeId,
      "OrderTypeID": _selectedDocumentTypeId,
      "InvoicePtID": _selectedInvoiceCodeId,
      "ExpCode1_ID": _selectedAccountId,
      "ExpCode2_ID": _selectedRestaurentId,
      "ExpCode3_ID": _selectDepartmentCodeId,
      "Cust_ID": _selectedCustomerId,
      "ContractID": _selectedContractNumberId,
      "Order_Budget_Header": _selectedBudgetId,
      "Supp_Cont_ID": _selectedSupplierContactId,
    };
  }

  bool isEmptyValue(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.trim().isEmpty;
    return false;
  }

  bool validateRequiredFields() {
    bool hasError = false;
    final values = fieldValueMap();

    setState(() {
      fieldErrors.clear();

      fieldRequired.forEach((fieldId, isRequired) {
        if (isRequired == true &&
            fieldVisible[fieldId] == true &&
            isEmptyValue(values[fieldId])) {
          fieldErrors[fieldId] = true;
          hasError = true;

          LoggerData.dataLog("Required field missing => $fieldId");
        }
      });
    });

    return !hasError;
  }

  Future<void> saveHeader() async {
    if (!validateRequiredFields()) {
      LoggerData.dataLog("API stopped due to validation error");
      return;
    }

    // ---------- API BODY ----------
    final Map<String, dynamic> body = {
      "Order_ID": widget.id,
      "ReferenceNo": _refNoController.text.trim(),
      "SupplierID": int.tryParse(_selectedSupplierCodeId ?? "0"),
      "DeliveryID": int.tryParse(_selectedDeliveryCodeId ?? "0"),
      "CategoryID": int.tryParse(_selectedCategoryCodeId ?? "0"),
      "OrderTypeID": int.tryParse(_selectedDocumentTypeId ?? "0"),
      "InvoicePtID": int.tryParse(_selectedInvoiceCodeId ?? "0"),
      "ExpCode1_ID": int.tryParse(_selectedAccountId ?? "0"),
      "ExpCode2_ID": int.tryParse(_selectedRestaurentId ?? "0"),
      "ExpCode3_ID": int.tryParse(_selectDepartmentCodeId ?? "0"),
      "Instructions": _instructionsController.text.trim(),
      "Justification": _justificationController.text.trim(),
      "FOB": _deliverIncoterms.text.trim(),
      "Ship_Via": _shipViaController.text.trim(),
      "Payment_Terms": _paymentTermsController.text.trim(),
      "Order_Budget_Header": _selectedBudgetValue,
      "Supp_Cont_ID": int.tryParse(_selectedSupplierContactId ?? "0"),
      "ContractID": int.tryParse(_selectedContractNumberId ?? "0"),
      "IsSupplierTaxChanged": false,
      "OrderTotalTax": 0,
      "IsSupplierCurrencyChanged": false,
      "CcyID": 0,
      "Sup_CcyID": 0,
      "apptype": AppConstants.apptype,
      "userSession": DateTime.now().toIso8601String(),
      "uid": SharedPrefs().uID,
    };

    LoggerData.dataLog("Save Header Body => $body");

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.saveOrderHeader,
      body,
    );

    if (jsonResponse != null) {
      final resp = NotesResponse.fromJson(jsonResponse);

      if (resp.code == 200) {
        showSnackBar(
          context,
          resp.message.isNotEmpty
              ? resp.message.first
              : "Header saved successfully",
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resp.message.isNotEmpty
                ? resp.message.join(', ')
                : AppStrings.somethingWentWrong),
            backgroundColor: ColorManager.red,
          ),
        );
      }
    }
  }

  // Future<void> saveHeader() async {
  //   setState(() {
  //     if (fieldRequired["Ship_Via"] == true &&
  //         _shipViaController.text.trim().isEmpty) {
  //       fieldErrors["Ship_Via"] = true;
  //     }
  //   });

  //   final Map<String, dynamic> body = {
  //     "Order_ID": widget.id,
  //     "ReferenceNo": _refNoController.text.trim(),
  //     "SupplierID": int.tryParse(_selectedSupplierCodeId ?? "0"),
  //     "DeliveryID": int.tryParse(_selectedDeliveryCodeId ?? "0"),
  //     "CategoryID": int.tryParse(_selectedCategoryCodeId ?? "0"),
  //     "OrderTypeID": int.tryParse(_selectedDocumentTypeId ?? "0"),
  //     "InvoicePtID": int.tryParse(_selectedInvoiceCodeId ?? "0"),
  //     "ExpCode1_ID": int.tryParse(_selectedAccountId ?? "0"),
  //     "ExpCode2_ID": int.tryParse(_selectedRestaurentId ?? "0"),
  //     "ExpCode3_ID": int.tryParse(_selectDepartmentCodeId ?? "0"),
  //     "Instructions": _instructionsController.text.trim(),
  //     "Justification": _justificationController.text.trim(),
  //     "FOB": _deliverIncoterms.text.trim(),
  //     "Ship_Via": _shipViaController.text.trim(),
  //     "Payment_Terms": _paymentTermsController.text.trim(),
  //     "Order_Budget_Header": _selectedBudgetValue,
  //     "Supp_Cont_ID": int.tryParse(_selectedSupplierContactId ?? "0"),
  //     "ContractID": int.tryParse(_selectedContractNumberId ?? "0"),
  //     "IsSupplierTaxChanged": false,
  //     "OrderTotalTax": 0,
  //     "IsSupplierCurrencyChanged": false,
  //     "CcyID": 0,
  //     "Sup_CcyID": 0,
  //     "apptype": AppConstants.apptype,
  //     "userSession": DateTime.now().toIso8601String(),
  //     "uid": SharedPrefs().uID,
  //   };

  //   LoggerData.dataLog("Save Header Body => $body");

  //   final jsonResponse = await apiService.postRequest(
  //     context,
  //     ApiService.saveOrderHeader,
  //     body,
  //   );

  //   setState(() {});

  //   if (jsonResponse != null) {
  //     final resp = NotesResponse.fromJson(jsonResponse);

  //     if (resp.code == 200) {
  //       showSnackBar(
  //         context,
  //         resp.message.isNotEmpty
  //             ? resp.message.first
  //             : "Header saved successfully",
  //       );
  //       Navigator.pop(context, true);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(resp.message.isNotEmpty
  //               ? resp.message.join(', ')
  //               : AppStrings.somethingWentWrong),
  //           backgroundColor: ColorManager.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: buildCommonAppBar(
          context: context,
          title: widget.appBarTitle,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: widget.appBarTitle,
      ),

      // BOTTOM SAVE BUTTON
      bottomNavigationBar:
          (SharedPrefs().userOrder == "RW" || SharedPrefs().userRequest == "RW")
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: 50,
                      child: CustomButton(
                        buttonText: 'Save',
                        onTap: saveHeader,
                      ),
                    ),
                  ),
                )
              : null,

      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(ColorManager.blue),
          radius: const Radius.circular(8),
          thickness: WidgetStateProperty.all(6),
          trackColor:
              WidgetStateProperty.all(ColorManager.lightGrey.withOpacity(0.3)),
          trackBorderColor: WidgetStateProperty.all(ColorManager.grey),
          minThumbLength: 50,
          crossAxisMargin: 2,
          mainAxisMargin: 20,
        ),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),

            // add bottom padding so content not hidden by button
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Card(
                color: ColorManager.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.constantFieldshow ?? false)
                        _buildConstantFieldsSection(),
                      const SizedBox(height: 16),
                      ..._buildDynamicFields(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//  Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         backgroundColor: ColorManager.primary,
//         appBar: buildCommonAppBar(
//           context: context,
//           title: widget.appBarTitle,
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: ColorManager.primary,
//       appBar: buildCommonAppBar(
//         context: context,
//         title: widget.appBarTitle,
//       ),
//       body: ScrollbarTheme(
//         data: ScrollbarThemeData(
//           thumbColor: WidgetStateProperty.all(ColorManager.blue),
//           radius: const Radius.circular(8),
//           thickness: WidgetStateProperty.all(6),
//           trackColor:
//               WidgetStateProperty.all(ColorManager.lightGrey.withOpacity(0.3)),
//           trackBorderColor: WidgetStateProperty.all(ColorManager.grey),
//           minThumbLength: 50,
//           crossAxisMargin: 2,
//           mainAxisMargin: 20,
//         ),
//         child: Scrollbar(
//           thumbVisibility: true,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(8),
//             child: Card(
//               color: ColorManager.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (widget.constantFieldshow ?? false)
//                       // Constant Fields
//                       _buildConstantFieldsSection(),
//                     const SizedBox(height: 16),

//                     // Dynamic Fields
//                     ..._buildDynamicFields(),

//                     const SizedBox(height: 30),

//                     if (SharedPrefs().userOrder == "RW" ||
//                         SharedPrefs().userRequest == "RW")
//                       //  if (widget.buttonshow ?? true)
//                       SizedBox(
//                         height: 50,
//                         child: CustomButton(
//                           buttonText: 'Save',
//                           onTap: () => saveHeader(),
//                         ),
//                       )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
  Widget _buildConstantFieldsSection() {
    final prefix = _getHeaderPrefix();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorManager.darkBlue.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConstantField("$prefix No", "${widget.number}"),
          const SizedBox(height: 8),
          _buildConstantField("$prefix Date", "${widget.date}"),
          const SizedBox(height: 8),
          _buildConstantField("$prefix Status", "${widget.status}"),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
  }

  List<Widget> _buildDynamicFields() {
    List<Widget> fields = [];

    void addFieldIfVisible(String fieldId, Widget fieldWidget) {
      if (fieldVisible[fieldId] ?? false) {
        fields.add(fieldWidget);
        fields.add(const SizedBox(height: 10));
      }
    }

    // ---------------- TEXT FIELDS ----------------

    if (fieldVisible["ReferenceNo"] ?? false) {
      addFieldIfVisible(
        "ReferenceNo",
        FormFieldHelper.buildTextField(
            label: fieldLabels["ReferenceNo"] ?? "",
            controller: _refNoController,
            hintText: 'Enter ${fieldLabels["ReferenceNo"] ?? ""}',
            isRequired: fieldRequired["ReferenceNo"] ?? false,
            readOnly: fieldReadOnly["ReferenceNo"] ?? false,
            showError: fieldErrors["ReferenceNo"] == true,
            onChanged: () {
              setState(() => fieldErrors["ReferenceNo"] = false);
            }),
      );
    }

    if (fieldVisible["FAO"] ?? false) {
      addFieldIfVisible(
        "FAO",
        FormFieldHelper.buildTextField(
          label: fieldLabels["FAO"] ?? "",
          controller: _deliverToController,
          hintText: 'Enter ${fieldLabels["FAO"] ?? ""}',
          isRequired: fieldRequired["FAO"] ?? false,
          readOnly: fieldReadOnly["FAO"] ?? false,
          showError: fieldErrors["FAO"] == true,
          onChanged: () {
            setState(() => fieldErrors["FAO"] = false);
          },
        ),
      );
    }

    if (fieldVisible["FOB"] ?? false) {
      addFieldIfVisible(
        "FOB",
        FormFieldHelper.buildTextField(
          label: fieldLabels["FOB"] ?? "",
          controller: _deliverIncoterms,
          hintText: 'Enter ${fieldLabels["FOB"] ?? ""}',
          isRequired: fieldRequired["FOB"] ?? false,
          readOnly: fieldReadOnly["FOB"] ?? false,
          showError: fieldErrors["FOB"] == true,
          onChanged: () {
            setState(() => fieldErrors["FOB"] = false);
          },
        ),
      );
    }

    if (fieldVisible["Instructions"] ?? false) {
      addFieldIfVisible(
        "Instructions",
        FormFieldHelper.buildTextField(
          label: fieldLabels["Instructions"] ?? "",
          controller: _instructionsController,
          hintText: 'Enter ${fieldLabels["Instructions"] ?? ""}',
          isRequired: fieldRequired["Instructions"] ?? false,
          readOnly: fieldReadOnly["Instructions"] ?? false,
          showError: fieldErrors["Instructions"] == true,
          onChanged: () {
            setState(() => fieldErrors["Instructions"] = false);
          },
        ),
      );
    }

    if (fieldVisible["Ship_Via"] ?? false) {
      addFieldIfVisible(
        "Ship_Via",
        FormFieldHelper.buildTextField(
          label: fieldLabels["Ship_Via"] ?? "Ship Via",
          controller: _shipViaController,
          hintText: 'Enter ${fieldLabels["Ship_Via"] ?? "Ship Via"}',
          isRequired: fieldRequired["Ship_Via"] ?? false,
          readOnly: fieldReadOnly["Ship_Via"] ?? false,
          showError: fieldErrors["Ship_Via"] == true,
          onChanged: () {
            setState(() => fieldErrors["Ship_Via"] = false);
          },
        ),
      );
    }

    if (fieldVisible["Justification"] ?? false) {
      addFieldIfVisible(
        "Justification",
        FormFieldHelper.buildTextField(
          label: fieldLabels["Justification"] ?? "",
          controller: _justificationController,
          hintText: 'Enter ${fieldLabels["Justification"] ?? ""}',
          isRequired: fieldRequired["Justification"] ?? false,
          readOnly: fieldReadOnly["Justification"] ?? false,
          showError: fieldErrors["Justification"] == true,
          onChanged: () {
            setState(() => fieldErrors["Justification"] = false);
          },
        ),
      );
    }

    if (fieldVisible["Payment_Terms"] ?? false) {
      addFieldIfVisible(
        "Payment_Terms",
        FormFieldHelper.buildTextField(
          label: fieldLabels["Payment_Terms"] ?? "",
          controller: _paymentTermsController,
          hintText: 'Enter ${fieldLabels["Payment_Terms"] ?? ""}',
          isRequired: fieldRequired["Payment_Terms"] ?? false,
          readOnly: fieldReadOnly["Payment_Terms"] ?? false,
          showError: fieldErrors["Payment_Terms"] == true,
          onChanged: () {
            setState(() => fieldErrors["Payment_Terms"] = false);
          },
        ),
      );
    }

    // ---------------- DROPDOWNS ----------------

    if (fieldVisible["SupplierID"] ?? false) {
      addFieldIfVisible(
        "SupplierID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["SupplierID"] ?? "",
          value: _selectedSupplierCodeId,
          apiDisplayValue: _selectedSupplierCodeValue,
          fetchItems: getSupplierCodes,
          showError: fieldErrors["SupplierID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["SupplierID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedSupplierCodeId = value;
              if (value == null) {
                _selectedSupplierCodeValue = null;
              }
            });
          },
          isRequired: fieldRequired["SupplierID"] ?? false,
          readOnly: fieldReadOnly["SupplierID"] ?? false,
        ),
      );
    }

    if (fieldVisible["DeliveryID"] ?? false) {
      addFieldIfVisible(
        "DeliveryID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["DeliveryID"] ?? "",
          value: _selectedDeliveryCodeId,
          apiDisplayValue: _selectedDeliveryCodeValue,
          fetchItems: getDeliveryCodes,
          showError: fieldErrors["DeliveryID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["DeliveryID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedDeliveryCodeId = value;
              if (value == null) {
                _selectedDeliveryCodeValue = null;
              }
            });
          },
          isRequired: fieldRequired["DeliveryID"] ?? false,
          readOnly: fieldReadOnly["DeliveryID"] ?? false,
        ),
      );
    }

    if (fieldVisible["CategoryID"] ?? false) {
      addFieldIfVisible(
        "CategoryID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["CategoryID"] ?? "",
          value: _selectedCategoryCodeId,
          apiDisplayValue: _selectedCategoryCodeValue,
          fetchItems: getCategoryCodes,
          showError: fieldErrors["CategoryID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["CategoryID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedCategoryCodeId = value;
              if (value == null) {
                _selectedCategoryCodeValue = null;
              }
            });
          },
          isRequired: fieldRequired["CategoryID"] ?? false,
          readOnly: fieldReadOnly["CategoryID"] ?? false,
        ),
      );
    }

    if (fieldVisible["OrderTypeID"] ?? false) {
      addFieldIfVisible(
        "OrderTypeID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["OrderTypeID"] ?? "",
          value: _selectedDocumentTypeId,
          apiDisplayValue: _selectedDocumentTypeValue,
          fetchItems: getOrderTypeCodes,
          showError: fieldErrors["OrderTypeID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["OrderTypeID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedDocumentTypeId = value;
              if (value == null) {
                _selectedDocumentTypeValue = null;
              }
            });
          },
          isRequired: fieldRequired["OrderTypeID"] ?? false,
          readOnly: fieldReadOnly["OrderTypeID"] ?? false,
        ),
      );
    }

    if (fieldVisible["InvoicePtID"] ?? false) {
      addFieldIfVisible(
        "InvoicePtID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["InvoicePtID"] ?? "",
          value: _selectedInvoiceCodeId,
          apiDisplayValue: _selectedInvoiceCodeValue,
          fetchItems: getInvoiceCodes,
          showError: fieldErrors["InvoicePtID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["InvoicePtID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedInvoiceCodeId = value;
              if (value == null) {
                _selectedInvoiceCodeValue = null;
              }
            });
          },
          isRequired: fieldRequired["InvoicePtID"] ?? false,
          readOnly: fieldReadOnly["InvoicePtID"] ?? false,
        ),
      );
    }

    if (fieldVisible["ExpCode1_ID"] ?? false) {
      addFieldIfVisible(
        "ExpCode1_ID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["ExpCode1_ID"] ?? "",
          value: _selectedAccountId,
          apiDisplayValue: _selectedAccountValue,
          fetchItems: getExpenseCode1,
          showError: fieldErrors["ExpCode1_ID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["ExpCode1_ID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedAccountId = value;
              if (value == null) {
                _selectedAccountValue = null;
              }
            });
          },
          isRequired: fieldRequired["ExpCode1_ID"] ?? false,
          readOnly: fieldReadOnly["ExpCode1_ID"] ?? false,
        ),
      );
    }

    if (fieldVisible["ExpCode2_ID"] ?? false) {
      addFieldIfVisible(
        "ExpCode2_ID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["ExpCode2_ID"] ?? "",
          value: _selectedRestaurentId,
          apiDisplayValue: _selectedRestaurentValue,
          fetchItems: getExpenseCode2,
          showError: fieldErrors["ExpCode2_ID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["ExpCode2_ID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedRestaurentId = value;
              if (value == null) {
                _selectedRestaurentValue = null;
              }
            });
          },
          isRequired: fieldRequired["ExpCode2_ID"] ?? false,
          readOnly: fieldReadOnly["ExpCode2_ID"] ?? false,
        ),
      );
    }

    if (fieldVisible["Supp_Cont_ID"] ?? false) {
      addFieldIfVisible(
        "Supp_Cont_ID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["Supp_Cont_ID"] ?? "",
          value: _selectedSupplierContactId,
          apiDisplayValue: _selectedSupplierContactValue,
          fetchItems: getSupplierContacts,
          showError: fieldErrors["Supp_Cont_ID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["Supp_Cont_ID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedSupplierContactId = value;
              if (value == null) {
                _selectedSupplierContactValue = null;
              }
            });
          },
          isRequired: fieldRequired["Supp_Cont_ID"] ?? false,
          readOnly: fieldReadOnly["Supp_Cont_ID"] ?? false,
        ),
      );
    }

    if (fieldVisible["Order_Budget_Header"] ?? false) {
      addFieldIfVisible(
        "Order_Budget_Header",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["Order_Budget_Header"] ?? "",
          value: _selectedBudgetId,
          apiDisplayValue: _selectedBudgetValue,
          fetchItems: getBudget,
          showError: fieldErrors["Order_Budget_Header"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["Order_Budget_Header"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedBudgetId = value;
              if (value == null) {
                _selectedBudgetValue = null;
              }
            });
          },
          isRequired: fieldRequired["Order_Budget_Header"] ?? false,
          readOnly: fieldReadOnly["Order_Budget_Header"] ?? false,
        ),
      );
    }

    if (fieldVisible["Cust_ID"] ?? false) {
      addFieldIfVisible(
        "Cust_ID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["Cust_ID"] ?? "",
          value: _selectedCustomerId,
          apiDisplayValue: _selectedCustomerValue,
          fetchItems: getCustomerCodes,
          showError: fieldErrors["Cust_ID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["Cust_ID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedCustomerId = value;
              if (value == null) {
                _selectedCustomerValue = null;
              }
            });
          },
          isRequired: fieldRequired["Cust_ID"] ?? false,
          readOnly: fieldReadOnly["Cust_ID"] ?? false,
        ),
      );
    }

    if (fieldVisible["ContractID"] ?? false) {
      addFieldIfVisible(
        "ContractID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["ContractID"] ?? "",
          value: _selectedContractNumberId,
          apiDisplayValue: _selectedContractNumberValue,
          fetchItems: getContractCodes,
          showError: fieldErrors["ContractID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["ContractID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectedContractNumberId = value;
              if (value == null) {
                _selectedContractNumberValue = null;
              }
            });
          },
          isRequired: fieldRequired["ContractID"] ?? false,
          readOnly: fieldReadOnly["ContractID"] ?? false,
        ),
      );
    }

    if (fieldVisible["ExpCode3_ID"] ?? false) {
      addFieldIfVisible(
        "ExpCode3_ID",
        AsyncDropdownField(
          context: context,
          label: fieldLabels["ExpCode3_ID"] ?? "",
          value: _selectDepartmentCodeId,
          apiDisplayValue: _selectDepartmentCodeValue,
          fetchItems: getDepartmentCodes,
          showError: fieldErrors["ExpCode3_ID"] ?? false,
          onChangedClearError: () {
            setState(() => fieldErrors["ExpCode3_ID"] = false);
          },
          onChanged: (value) {
            setState(() {
              _selectDepartmentCodeId = value;
              if (value == null) {
                _selectDepartmentCodeValue = null;
              }
            });
          },
          isRequired: fieldRequired["ExpCode3_ID"] ?? false,
          readOnly: fieldReadOnly["ExpCode3_ID"] ?? false,
        ),
      );
    }

    return fields;
  }

  Widget _buildConstantField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FontSize.s16,
              ),
            ),
          ),
          const Text(
            ' : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: TextStyle(
                fontSize: FontSize.s16,
                color: ColorManager.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
