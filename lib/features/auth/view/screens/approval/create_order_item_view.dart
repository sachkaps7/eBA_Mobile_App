import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/order_header_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
import 'package:eyvo_v3/core/widgets/searchable_dropdown_modal.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';

class CreateOrderLineView extends StatefulWidget {
  final int orderId;
  const CreateOrderLineView({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<CreateOrderLineView> createState() => _CreateOrderLineViewState();
}

class _CreateOrderLineViewState extends State<CreateOrderLineView> {
  // Controllers

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
// Field Visibility Flags

  bool _showExpCode4 = true;
  bool _showExpCode5Code = true;
  bool _showExpCode6Code = true;
  bool _showDueDate = true;
  bool _showUnit = true;
  bool _showSuppliersPartNo = true;
  bool _showItemCode = true;
  bool _showQuantity = true;
  bool _showPackSize = true;
  bool _showPrice = true;
  bool _showDiscountType = true;
  bool _showDiscount = true;
  bool _showSalesTax = true;
  bool _showOpexCapex = true;
  bool _showMarkup = true;
  bool _showExpenseType = true;
  bool _showSupplier = true;

// Dropdown Selected IDs

  String? _selectedExpCode4Id;
  String? _selectedExpCode5Id;
  String? _selectedExpCode6CodeId;
  String? _selectedUnitId;
  String? _selectedItemCodeId;
  String? _selectedDiscountTypeId;
  String? _selectedOpexCapexId;
  String? _selectedExpenseTypeId;
  String? _selectedSupplierId;

// Dropdown Selected Values

  String? _selectedExpCode4Value;
  String? _selectedExpCode5Value;
  String? _selectedExpCode6CodeValue;
  String? _selectedUnitValue;
  String? _selectedItemCodeValue;
  String? _selectedDiscountTypeValue;
  String? _selectedOpexCapexValue;
  String? _selectedExpenseTypeValue;
  String? _selectedSupplierValue;

// Text Controllers

  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _suppliersPartNoController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _packSizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _salesTaxController = TextEditingController();
  final TextEditingController _markupController = TextEditingController();
  final TextEditingController _supplierPartNoController =
      TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemPackSizeController = TextEditingController();
  // final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _salesTaxController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();

  // Dropdown data
  List<DropdownItem> catalogItems() {
    return [
      DropdownItem(id: "1", description: "CAT-001", code: "ert"),
      DropdownItem(id: "1", description: "CAT-002", code: "ert"),
      DropdownItem(id: "1", description: "CAT-003", code: "ert"),
      DropdownItem(id: "1", description: "CAT-004", code: "ert"),
    ];
  }

  Future<void> fetchOrderLine() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final jsonResponse = await apiService.postRequest(
        context,
        ApiService.createOrderHeader,
        {
          'uid': SharedPrefs().uID,
          'apptype': AppConstants.apptype,
          'ID': widget.orderId,
          'LineID': 3556,
          'group': 'Order',
          'section': 'Line',
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

            switch (field.fieldId) {
              case "ExpCode4_ID":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedExpCode4Id = field.id.toString();
                  _selectedExpCode4Value = field.value;
                }
                break;

              case "ExpCode5_ID":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedExpCode5Id = field.id.toString();
                  _selectedExpCode5Value = field.value;
                }
                break;

              case "ExpCode6_ID":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedExpCode6CodeId = field.id.toString();
                  _selectedExpCode6CodeValue = field.value;
                }
                break;

              case "DueDate":
                if (field.visible && field.value.isNotEmpty) {
                  _dueDateController.text = field.value;
                }
                break;

              case "Unit":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedUnitId = field.id.toString();
                  _selectedUnitValue = field.value;
                }
                break;

              case "SuppliersPartNo":
                if (field.visible) {
                  _suppliersPartNoController.text = field.value;
                }
                break;

              case "ItemID":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedItemCodeId = field.id.toString();
                  _selectedItemCodeValue = field.value;
                }
                break;

              case "Quantity":
                if (field.visible) {
                  _quantityController.text = field.value;
                }
                break;

              case "PackSize":
                if (field.visible) {
                  _packSizeController.text = field.value;
                }
                break;

              case "Price":
                if (field.visible) {
                  _priceController.text = field.value;
                }
                break;

              case "Discount_Type":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedDiscountTypeId = field.id.toString();
                  _selectedDiscountTypeValue = field.value;
                }
                break;

              case "Discount":
                if (field.visible) {
                  _discountController.text = field.value;
                }
                break;

              case "Tax":
                if (field.visible) {
                  _salesTaxController.text = field.value;
                }
                break;

              case "Opex_Capex":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedOpexCapexId = field.id.toString();
                  _selectedOpexCapexValue = field.value;
                }
                break;

              case "Markup":
                if (field.visible) {
                  _markupController.text = field.value;
                }
                break;

              case "Expense_Type":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedExpenseTypeId = field.id.toString();
                  _selectedExpenseTypeValue = field.value;
                }
                break;

              case "SupplierID":
                if (field.visible && field.value.isNotEmpty) {
                  _selectedSupplierId = field.id.toString();
                  _selectedSupplierValue = field.value;
                }
                break;
            }
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

  @override
  void initState() {
    super.initState();
    fetchOrderLine();
  }

  @override
  void dispose() {
    _dueDateController.dispose();
    _suppliersPartNoController.dispose();
    _quantityController.dispose();
    _packSizeController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _salesTaxController.dispose();
    _markupController.dispose();
    _supplierPartNoController.dispose();
    _itemQuantityController.dispose();
    _itemPackSizeController.dispose();
    _itemDescriptionController.dispose();

    super.dispose();
  }

  void _saveForm() {
    // Prepare data for API
    Map<String, dynamic> formData = {
      'ExpCode4_ID': _selectedExpCode4Id,
      'ExpCode5_ID': _selectedExpCode5Id,
      'ExpCode6_ID': _selectedExpCode6CodeId,
      'DueDate': _dueDateController.text,
      'Unit': _selectedUnitId,
      'SuppliersPartNo': _suppliersPartNoController.text,
      'ItemID': _selectedItemCodeId,
      'Quantity': _quantityController.text,
      'PackSize': _packSizeController.text,
      'Price': _priceController.text,
      'Discount_Type': _selectedDiscountTypeId,
      'Discount': _discountController.text,
      'Tax': _salesTaxController.text,
      'Opex_Capex': _selectedOpexCapexId,
      'Markup': _markupController.text,
      'Expense_Type': _selectedExpenseTypeId,
      'SupplierID': _selectedSupplierId,
    };

    LoggerData.dataLog("Order Line Form Data: $formData");
    // print("Order Line Form Data: $formData");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Order Line Saved Successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: "Order Line",
      ),
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(ColorManager.blue),
          radius: const Radius.circular(8),
          thickness: WidgetStateProperty.all(6),
          // You can add more customization:
          trackColor:
              WidgetStateProperty.all(ColorManager.lightGrey.withOpacity(0.3)),
          trackBorderColor: WidgetStateProperty.all(ColorManager.grey),
          minThumbLength: 30,
          crossAxisMargin: 2,
          mainAxisMargin: 10,
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
                    //-------------------- DROPDOWN: Catalog Items --------------------
                    if (fieldVisible["ItemID"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["ItemID"] ?? "",
                        value: _selectedItemCodeId,
                        apiDisplayValue: _selectedItemCodeValue,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedItemCodeId = value;
                          });
                        },
                        isRequired: true,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                    ],

                    //-------------------- BIG TEXT FIELD: Item Description --------------------
                    FormFieldHelper.buildMultilineTextField(
                      label: "Item Description",
                      controller: _itemDescriptionController,
                      hintText: "Enter detailed item description",
                      isRequired: true,
                    ),
                    const SizedBox(height: 10),

//-------------------- TEXT FIELD: Supplier Part No --------------------
                    if (fieldVisible["SuppliersPartNo"] ?? false) ...[
                      FormFieldHelper.buildTextField(
                        label: fieldLabels["SuppliersPartNo"] ?? "",
                        controller: _suppliersPartNoController,
                        hintText:
                            'Enter ${fieldLabels["SuppliersPartNo"] ?? ""}',
                        isRequired: fieldRequired["SuppliersPartNo"] ?? false,
                        readOnly: fieldReadOnly["SuppliersPartNo"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- DATE PICKER: Due Date --------------------
                    if (fieldVisible["DueDate"] ?? false) ...[
                      FormFieldHelper.buildDatePickerField(
                        context: context,
                        label: fieldLabels["DueDate"] ?? "",
                        controller: _dueDateController,
                        isRequired: fieldRequired["DueDate"] ?? false,
                        readOnly: fieldReadOnly["DueDate"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- TEXT FIELD: Quantity --------------------
                    if (fieldVisible["Quantity"] ?? false) ...[
                      FormFieldHelper.buildTextField(
                        label: fieldLabels["Quantity"] ?? "",
                        controller: _quantityController,
                        hintText: 'Enter ${fieldLabels["Quantity"] ?? ""}',
                        keyboardType: TextInputType.number,
                        isRequired: fieldRequired["Quantity"] ?? false,
                        readOnly: fieldReadOnly["Quantity"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],
                    //-------------------- DROPDOWN: Catalog Items --------------------
                    if (fieldVisible["SupplierID"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["SupplierID"] ?? "",
                        value: _selectedSupplierId,
                        apiDisplayValue: _selectedSupplierValue,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSupplierId = value;
                          });
                        },
                        isRequired: true,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                    ],
//-------------------- DROPDOWN: Unit --------------------
                    if (fieldVisible["Unit"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["Unit"] ?? "",
                        value: _selectedUnitId,
                        apiDisplayValue: _selectedUnitValue,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUnitId = value;
                          });
                        },
                        isRequired: fieldRequired["Unit"] ?? false,
                        readOnly: fieldReadOnly["Unit"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- TEXT FIELD: Pack Size --------------------
                    if (fieldVisible["PackSize"] ?? false) ...[
                      FormFieldHelper.buildTextField(
                        label: fieldLabels["PackSize"] ?? "",
                        controller: _packSizeController,
                        hintText: 'Enter ${fieldLabels["PackSize"] ?? ""}',
                        isRequired: fieldRequired["PackSize"] ?? false,
                        readOnly: fieldReadOnly["PackSize"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- TEXT FIELD: Price --------------------
                    if (fieldVisible["Price"] ?? false) ...[
                      FormFieldHelper.buildTextField(
                        label: fieldLabels["Price"] ?? "",
                        controller: _priceController,
                        hintText: 'Enter ${fieldLabels["Price"] ?? ""}',
                        keyboardType: TextInputType.number,
                        isRequired: fieldRequired["Price"] ?? false,
                        readOnly: fieldReadOnly["Price"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- TEXT FIELD: Sales Tax --------------------
                    if (fieldVisible["Tax"] ?? false) ...[
                      FormFieldHelper.buildTextField(
                        label: fieldLabels["Tax"] ?? "",
                        controller: _salesTaxController,
                        hintText:
                            'Enter ${fieldLabels["Tax"] ?? ""} percentage',
                        keyboardType: TextInputType.number,
                        isRequired: fieldRequired["Tax"] ?? false,
                        readOnly: fieldReadOnly["Tax"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- DROPDOWN: ExpCode4_ID (GL) --------------------
                    if (fieldVisible["ExpCode4_ID"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["ExpCode4_ID"] ?? "",
                        value: _selectedExpCode4Id,
                        apiDisplayValue: _selectedExpCode4Value,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExpCode4Value = value;
                          });
                        },
                        isRequired: fieldRequired["ExpCode4_ID"] ?? false,
                        readOnly: fieldReadOnly["ExpCode4_ID"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- DROPDOWN: ExpCode5_ID (Property Code) --------------------
                    if (fieldVisible["ExpCode5_ID"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["ExpCode5_ID"] ?? "",
                        value: _selectedExpCode5Id,
                        apiDisplayValue: _selectedExpCode5Value,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExpCode5Value = value;
                          });
                        },
                        isRequired: fieldRequired["ExpCode5_ID"] ?? false,
                        readOnly: fieldReadOnly["ExpCode5_ID"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- DROPDOWN: ExpCode6_ID (Nominal Code) --------------------
                    if (fieldVisible["ExpCode6_ID"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["ExpCode6_ID"] ?? "Nominal Code",
                        value: _selectedExpCode6CodeId,
                        apiDisplayValue: _selectedExpCode6CodeValue,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExpCode6CodeValue = value;
                          });
                        },
                        isRequired: fieldRequired["ExpCode6_ID"] ?? false,
                        readOnly: fieldReadOnly["ExpCode6_ID"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- DROPDOWN: Opex/Capex --------------------
                    if (fieldVisible["Opex_Capex"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["Opex_Capex"] ?? "",
                        value: _selectedOpexCapexId,
                        apiDisplayValue: _selectedOpexCapexValue,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedOpexCapexValue = value;
                          });
                        },
                        isRequired: fieldRequired["Opex_Capex"] ?? false,
                        readOnly: fieldReadOnly["Opex_Capex"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- TEXT FIELD: Markup --------------------
                    if (fieldVisible["Markup"] ?? false) ...[
                      FormFieldHelper.buildTextField(
                        label: fieldLabels["Markup"] ?? "",
                        controller: _markupController,
                        keyboardType: TextInputType.number,
                        hintText: 'Enter ${fieldLabels["Markup"] ?? ""}',
                        isRequired: fieldRequired["Markup"] ?? false,
                        readOnly: fieldReadOnly["Markup"] ?? false,
                      ),
                      const SizedBox(height: 10),
                    ],

//-------------------- DROPDOWN: Expense Type --------------------
                    if (fieldVisible["Expense_Type"] ?? false) ...[
                      FormFieldHelper.buildDropdownFieldWithIds(
                        context: context,
                        label: fieldLabels["Expense_Type"] ?? "",
                        value: _selectedExpenseTypeId,
                        apiDisplayValue: _selectedExpenseTypeValue,
                        items: catalogItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExpenseTypeValue = value;
                          });
                        },
                        isRequired: fieldRequired["Expense_Type"] ?? false,
                        readOnly: fieldReadOnly["Expense_Type"] ?? false,
                      ),
                      const SizedBox(height: 30),
                    ],

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
}
