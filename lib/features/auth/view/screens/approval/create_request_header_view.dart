import 'package:eyvo_inventory/api/response_models/order_header_response.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/form_field_helper.dart';
import 'package:eyvo_inventory/core/widgets/searchable_dropdown_modal.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';

class CreateRequestHeaderView extends StatefulWidget {
  const CreateRequestHeaderView({Key? key}) : super(key: key);

  @override
  State<CreateRequestHeaderView> createState() =>
      _CreateRequestHeaderViewState();
}

class _CreateRequestHeaderViewState extends State<CreateRequestHeaderView> {
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
  String? _selectRequestBudgetId;
  // Dropdown Selections
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
  String? _selectRequestBudgetValue;

  CreateHeaderResponse? apiResponse;
  bool isLoading = true;

  // Field visibility from API
  bool _showAccount = true;
  bool _showRestaurant = true;
  bool _showDepartmentCode = true;
  bool _showInvoiceCode = true;
  bool _showDocumentType = true;
  bool _showRefNo = true;
  bool _showDeliveryCode = true;
  bool _showInstructions = true;
  bool _showCategoryCode = true;
  bool _showCustomer = true;
  bool _showIncoterms = true;
  bool _showShipVia = true;
  bool _showJustification = true;
  bool _showBudget = true;
  bool _showDeliverTo = true;
  bool _showPaymentTerms = true;
  bool _showSupplierContact = true;
  bool _showContractNumber = true;
  bool _showSupplier = true;
  bool _showRequestDescription = true;
  bool _showRequestBudget = true;

  // Dropdown Data
  List<DropdownItem> getBudget() {
    return [
      DropdownItem(id: "In Budget", value: "In Budget"),
      DropdownItem(id: "Out Budget", value: "Out Budget"),
      DropdownItem(id: "Over Budget", value: "Over Budget"),
    ];
  }

  List<DropdownItem> getSupplierCodes() {
    return [
      DropdownItem(id: "1", value: "Supplier 1"),
      DropdownItem(id: "2", value: "Supplier 2"),
      DropdownItem(id: "3", value: "Supplier 3"),
      DropdownItem(id: "236", value: "MFAX2"),
    ];
  }

  List<DropdownItem> getDeliveryCodes() {
    return [
      DropdownItem(id: "1", value: "D001"),
      DropdownItem(id: "2", value: "D002"),
      DropdownItem(id: "3", value: "D003"),
      DropdownItem(id: "4", value: "D004"),
      DropdownItem(id: "5", value: "D005"),
    ];
  }

  final String mockJson = '''{
    "code": 200,
    "message": [
        "success"
    ],
    "data": [
        {
            "fieldID": "ExpCode1_ID",
            "labelName": "Account",
            "ID": 66,
            "value": "HW",
            "controlType": "dropdown",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "ExpCode2_ID",
            "labelName": "Restaurant",
            "ID": 9,
            "value": "Finance",
            "controlType": "dropdown",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "ExpCode3_ID",
            "labelName": "Department Code",
            "ID": 8,
            "value": "0430-SD",
            "controlType": "dropdown",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "OrderTypeID",
            "labelName": "Document Type",
            "ID": 5,
            "value": "PO",
            "controlType": "dropdown",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "ReferenceNo",
            "labelName": "Ref Num",
            "ID": 0,
            "value": "001782",
            "controlType": "textbox",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "DeliveryID",
            "labelName": "Delivery Code",
            "ID": 7,
            "value": "DC-IT",
            "controlType": "dropdown",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "Instructions",
            "labelName": "Instructions",
            "ID": 0,
            "value": "Send to 2nd floor, for Servio in receiving",
            "controlType": "textbox",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "CategoryID",
            "labelName": "Category Code",
            "ID": 8,
            "value": "Development",
            "controlType": "dropdown",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "Cust_ID",
            "labelName": "Customer",
            "ID": 0,
            "value": "",
            "controlType": "dropdown",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "FOB",
            "labelName": "Incoterms",
            "ID": 0,
            "value": "001782",
            "controlType": "textbox",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "Ship_Via",
            "labelName": "Ship Via",
            "ID": 0,
            "value": "001782",
            "controlType": "textbox",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "Request_Description",
            "labelName": "Request Description",
            "ID": 0,
            "value": "001782001782001782001782",
            "controlType": "textbox",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "FAO",
            "labelName": "Delivery To",
            "ID": 0,
            "value": "David Smith",
            "controlType": "textbox",
            "required": false,
            "readWrite": true,
            "visible": true
        },
        {
            "fieldID": "Request_Budget_header",
            "labelName": "Budget",
            "ID": "Out of Budget",
            "value": "Out of Budget",
            "controlType": "textbox",
            "required": true,
            "readWrite": true,
            "visible": true
        }
    ],
    "totalrecords": 14
}''';

  @override
  void initState() {
    super.initState();
    loadMockData();
  }

  void loadMockData() {
    final decoded = CreateHeaderResponseFromJson(mockJson);
    setState(() {
      apiResponse = decoded;
      isLoading = false;

      // Set field visibility based on API response
      for (var field in decoded.data) {
        switch (field.fieldId) {
          case "ExpCode1_ID":
            _showAccount = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedAccountId = field.id.toString();
              _selectedAccountValue = field.value;
            }
            break;

          case "ExpCode2_ID":
            _showRestaurant = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedRestaurentId = field.id.toString();
              _selectedRestaurentValue = field.value;
            }
            break;
          case "ExpCode3_ID":
            _showDepartmentCode = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectDepartmentCodeId = field.id.toString();
              _selectDepartmentCodeValue = field.value;
            }
            break;
          case "InvoicePtID":
            _showInvoiceCode = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedInvoiceCodeId = field.id.toString();
              _selectedInvoiceCodeValue = field.value;
            }
            break;

          case "OrderTypeID":
            _showDocumentType = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedDocumentTypeId = field.id.toString();
              _selectedDocumentTypeValue = field.value;
            }
            break;
          case "ReferenceNo":
            _showRefNo = field.visible;
            if (field.visible) {
              _refNoController.text = field.value;
            }
            break;
          case "DeliveryID":
            _showDeliveryCode = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedDeliveryCodeId = field.id.toString();
              _selectedDeliveryCodeValue = field.value;
            }
            break;
          case "Instructions":
            _showInstructions = field.visible;
            if (field.visible) {
              _instructionsController.text = field.value;
            }
            break;
          case "CategoryID":
            _showCategoryCode = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedCategoryCodeId = field.id.toString();
              _selectedCategoryCodeValue = field.value;
            }
            break;
          case "Cust_ID":
            _showCustomer = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedCustomerId = field.id.toString();
              _selectedCustomerValue = field.value;
            }
            break;
          case "FOB":
            _showIncoterms = field.visible;
            if (field.visible) {
              _deliverIncoterms.text = field.value;
            }
            break;
          case "Ship_Via":
            _showShipVia = field.visible;
            if (field.visible) {
              _shipViaController.text = field.value;
            }
            break;
          case "Justification":
            _showJustification = field.visible;
            if (field.visible) {
              _justificationController.text = field.value;
            }
            break;
          case "Order_Budget_Header":
            _showBudget = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedBudgetId = field.id.toString();
              _selectedBudgetValue = field.value;
            }
            break;
          case "FAO":
            _showDeliverTo = field.visible;
            if (field.visible) {
              _deliverToController.text = field.value;
            }
            break;
          case "Payment_Terms":
            _showPaymentTerms = field.visible;
            if (field.visible) {
              _paymentTermsController.text = field.value;
            }
            break;
          case "Supp_Cont_ID":
            _showSupplierContact = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedSupplierContactId = field.id.toString();
              _selectedSupplierContactValue = field.value;
            }
            break;
          case "ContractID":
            _showContractNumber = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedContractNumberId = field.id.toString();
              _selectedContractNumberValue = field.value;
            }
            break;
          case "SupplierID":
            _showSupplier = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectedSupplierCodeId = field.id.toString();
              _selectedSupplierCodeValue = field.value;
            }
            break;
          case "Request_Description":
            _showRequestDescription = field.visible;
            if (field.visible) {
              _requestDescriptionController.text = field.value;
            }
            break;

          case "Request_Budget_header":
            _showRequestBudget = field.visible;
            if (field.visible && field.value.isNotEmpty) {
              _selectRequestBudgetId = field.id.toString();
              _selectRequestBudgetValue = field.value;
            }
            break;
        }
      }
    });
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
    super.dispose();
  }

  void _saveForm() {
    // Prepare data for API
    Map<String, dynamic> formData = {
      'ReferenceNo': _refNoController.text,
      'SupplierCode': _selectedSupplierCodeId,
      'FAO': _deliverToController.text,
      'DeliveryID': _selectedDeliveryCodeId,
      'CategoryID': _selectedCategoryCodeId,
      'OrderTypeID': _selectedDocumentTypeId,
      'InvoicePtID': _selectedInvoiceCodeId,
      'ExpCode1_ID': _selectedAccountId,
      'ExpCode2_ID': _selectedRestaurentId,
      'Supp_Cont_ID': _selectedContactNumberId,
      'FOB': _deliverIncoterms.text,
      'Order_Budget_Header': _selectedBudgetId,
      'Instructions': _instructionsController.text,
      'Ship_Via': _shipViaController.text,
      'Justification': _justificationController.text,
      'Payment_Terms': _paymentTermsController.text,
      'Cust_ID': _selectedCustomerId,
      'ContractID': _selectedContractNumberId,
    };

    print("Saving Order Header...");
    LoggerData.dataLog("Form Data: $formData");

    // Here you would call your actual API
    // await OrderHeaderService.saveOrderHeader(formData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Order Header Saved Successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: buildCommonAppBar(
          context: context,
          title: "Request Header",
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: "Request Header",
      ),
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
                    //-------------------- CONSTANT FIELDS --------------------
                    Container(
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
                          _buildConstantField("Request No", "ORD-1234"),
                          const SizedBox(height: 8),
                          _buildConstantField("Request Date", "13/10/2025"),
                          const SizedBox(height: 8),
                          _buildConstantField("Request Status", "DORMANT"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    //-------------------- DYNAMIC FIELDS BASED ON VISIBILITY --------------------

                    FormFieldHelper.buildTextField(
                      label: "Ref No",
                      controller: _refNoController,
                      hintText: "Enter reference number",
                      isRequired: true,
                    ),
                    const SizedBox(height: 10),

                    // Supplier Code Dropdown
                    if (_showSupplier) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Supplier Code",
                        value: _selectedSupplierCodeId,
                        apiDisplayValue: _selectedSupplierCodeValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSupplierCodeId = value;
                          });
                        },
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Deliver To Text Field
                    if (_showDeliverTo) ...[
                      FormFieldHelper.buildTextField(
                        label: "Deliver To",
                        controller: _deliverToController,
                        hintText: "Enter delivery location",
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Delivery Code Dropdown
                    if (_showDeliveryCode) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Delivery Code",
                        value: _selectedDeliveryCodeId,
                        items: getSupplierCodes(),
                        apiDisplayValue: _selectedDeliveryCodeValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedDeliveryCodeId = value;
                          });
                        },
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Category Code Dropdown
                    if (_showCategoryCode) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Category Code",
                        value: _selectedCategoryCodeId,
                        apiDisplayValue: _selectedCategoryCodeValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryCodeId = value;
                          });
                        },
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Document Type Dropdown
                    if (_showDocumentType) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Document Type",
                        value: _selectedDocumentTypeId,
                        apiDisplayValue: _selectedDocumentTypeValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDocumentTypeId = value;
                          });
                        },
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Invoice Code Dropdown
                    if (_showInvoiceCode) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Invoice Code",
                        value: _selectedInvoiceCodeId,
                        apiDisplayValue: _selectedInvoiceCodeValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedInvoiceCodeId = value;
                          });
                        },
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Account Dropdown
                    if (_showAccount) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Account",
                        value: _selectedAccountId,
                        apiDisplayValue: _selectedAccountValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAccountId = value;
                          });
                        },
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Restaurant Dropdown
                    if (_showRestaurant) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Restaurant",
                        value: _selectedRestaurentId,
                        apiDisplayValue: _selectedRestaurentValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRestaurentId = value;
                          });
                        },
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Supplier Contact Dropdown
                    if (_showSupplierContact) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Supplier Contact",
                        value: _selectedSupplierContactId,
                        apiDisplayValue: _selectedSupplierContactValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSupplierContactId = value;
                          });
                        },
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Contact Number Dropdown
                    FormFieldHelper.buildDropdownFieldWithIds(
                      context: context,
                      label: "Contact Number",
                      value: _selectedContactNumberId,
                      apiDisplayValue: _selectedContactNumberValue,
                      items: getSupplierCodes(),
                      onChanged: (value) {
                        setState(() {
                          _selectedContactNumberId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // Incoterms Text Field
                    if (_showIncoterms) ...[
                      FormFieldHelper.buildTextField(
                        label: "Incoterms",
                        controller: _deliverIncoterms,
                        hintText: "Enter Incoterms",
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Budget Dropdown
                    if (_showBudget) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Budget",
                        value: _selectedBudgetId,
                        apiDisplayValue: _selectedBudgetValue,
                        items: getBudget(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBudgetId = value;
                          });
                        },
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Instructions Text Field
                    if (_showInstructions) ...[
                      FormFieldHelper.buildTextField(
                        label: "Instructions",
                        controller: _instructionsController,
                        hintText: "Enter instructions",
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Ship Via Text Field
                    if (_showShipVia) ...[
                      FormFieldHelper.buildTextField(
                        label: "Ship Via",
                        controller: _shipViaController,
                        hintText: "Enter ship via",
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Justification Text Field
                    if (_showJustification) ...[
                      FormFieldHelper.buildTextField(
                        label: "Justification",
                        controller: _justificationController,
                        hintText: "Enter justification",
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Payment Terms Text Field
                    if (_showPaymentTerms) ...[
                      FormFieldHelper.buildTextField(
                        label: "Payment Terms",
                        controller: _paymentTermsController,
                        hintText: "Enter payment terms",
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Customer Dropdown
                    if (_showCustomer) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Customer",
                        value: _selectedCustomerId,
                        apiDisplayValue: _selectedCustomerValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCustomerId = value;
                          });
                        },
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Contract Number Dropdown
                    if (_showContractNumber) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Contract Number",
                        value: _selectedContractNumberId,
                        apiDisplayValue: _selectedContractNumberValue,
                        items: getDeliveryCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectedContractNumberId = value;
                          });
                        },
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Department Code Dropdown
                    if (_showDepartmentCode) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Department Code",
                        value: _selectDepartmentCodeId,
                        apiDisplayValue: _selectDepartmentCodeValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectDepartmentCodeId = value;
                          });
                        },
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                    ],
                    // Request Description Dropdown
                    if (_showRequestDescription) ...[
                      FormFieldHelper.buildTextField(
                        label: "Request Description",
                        controller: _paymentTermsController,
                        hintText: "Enter payment terms",
                        isRequired: true,
                      ),
                      const SizedBox(height: 10),
                    ],
                    // Request Description Dropdown
                    if (_showRequestBudget) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: "Request Budget",
                        value: _selectRequestBudgetId,
                        apiDisplayValue: _selectRequestBudgetValue,
                        items: getSupplierCodes(),
                        onChanged: (value) {
                          setState(() {
                            _selectRequestBudgetId = value;
                          });
                        },
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 30),

                    //-------------------- SAVE BUTTON --------------------
                    SizedBox(
                      height: 50,
                      child: CustomButton(
                        buttonText: 'Save',
                        onTap: () {
                          _saveForm();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //-------------------- CONSTANT FIELD --------------------
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
