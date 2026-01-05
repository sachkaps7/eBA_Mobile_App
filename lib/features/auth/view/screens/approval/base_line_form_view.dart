// import 'package:eyvo_v3/api/api_service/api_service.dart';
// import 'package:eyvo_v3/api/response_models/order_header_response.dart';
// import 'package:eyvo_v3/app/app_prefs.dart';
// import 'package:eyvo_v3/core/resources/strings_manager.dart';
// import 'package:eyvo_v3/core/widgets/button.dart';
// import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
// import 'package:eyvo_v3/core/widgets/searchable_dropdown_modal.dart';
// import 'package:eyvo_v3/log_data.dart/logger_data.dart';
// import 'package:flutter/material.dart';
// import 'package:eyvo_v3/core/resources/color_manager.dart';
// import 'package:eyvo_v3/core/resources/font_manager.dart';
// import 'package:eyvo_v3/core/resources/styles_manager.dart';
// import 'package:eyvo_v3/core/widgets/common_app_bar.dart';

// class CommonLineViewPage extends StatefulWidget {
//   final int id;
//   final int lineId;
//   final LineType lineType;
//   final String appBarTitle;
//   const CommonLineViewPage({
//     Key? key,
//     required this.id,
//     required this.lineId,
//     required this.lineType,
//     required this.appBarTitle,
//   }) : super(key: key);

//   @override
//   State<CommonLineViewPage> createState() => _CreateRequestLineViewState();
// }

// enum LineType {
//   order,
//   request,
// }

// class _CreateRequestLineViewState extends State<CommonLineViewPage> {
//   // Controllers

//   final ApiService apiService = ApiService();
//   bool isError = false;
//   String errorText = AppStrings.somethingWentWrong;
//   CreateHeaderResponse? apiResponse;
//   bool isLoading = true;
//   List<Datum>? headerData;
//   Map<String, bool> fieldVisible = {};
//   Map<String, bool> fieldRequired = {};
//   Map<String, bool> fieldReadOnly = {};
//   Map<String, String> fieldLabels = {};

// // Dropdown Selected IDs

//   String? _selectedExpCode4Id;
//   String? _selectedExpCode5Id;
//   String? _selectedExpCode6CodeId;
//   String? _selectedUnitId;
//   String? _selectedItemCodeId;
//   String? _selectedDiscountTypeId;
//   String? _selectedOpexCapexId;
//   String? _selectedExpenseTypeId;
//   String? _selectedSupplierId;

// // Dropdown Selected Values

//   String? _selectedExpCode4Value;
//   String? _selectedExpCode5Value;
//   String? _selectedExpCode6CodeValue;
//   String? _selectedUnitValue;
//   String? _selectedItemCodeValue;
//   String? _selectedDiscountTypeValue;
//   String? _selectedOpexCapexValue;
//   String? _selectedExpenseTypeValue;
//   String? _selectedSupplierValue;

// // Text Controllers

//   final TextEditingController _dueDateController = TextEditingController();
//   final TextEditingController _suppliersPartNoController =
//       TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _packSizeController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _discountController = TextEditingController();
//   final TextEditingController _salesTaxController = TextEditingController();
//   final TextEditingController _markupController = TextEditingController();
//   final TextEditingController _supplierPartNoController =
//       TextEditingController();
//   final TextEditingController _itemQuantityController = TextEditingController();
//   final TextEditingController _itemPackSizeController = TextEditingController();
//   // final TextEditingController _priceController = TextEditingController();
//   // final TextEditingController _salesTaxController = TextEditingController();
//   final TextEditingController _itemDescriptionController =
//       TextEditingController();

//   // Dropdown data
//   List<DropdownItem> catalogItems() {
//     return [
//       DropdownItem(id: "1", value: "CAT-001"),
//       DropdownItem(id: "1", value: "CAT-002"),
//       DropdownItem(id: "1", value: "CAT-003"),
//       DropdownItem(id: "1", value: "CAT-004"),
//     ];
//   }

//   Future<void> fetchOrderLine() async {
//     setState(() {
//       isLoading = true;
//       isError = false;
//     });

//     try {
//       final jsonResponse = await apiService.postRequest(
//         context,
//         ApiService.createOrderHeader,
//         {
//            'uid': SharedPrefs().uID,'apptype': AppConstants.apptype,
//           'ID': widget.id,
//           'LineID': widget.lineId,
//           'group': widget.lineType,
//           'section': 'Line',
//           'apptype': 'mobile',
//         },
//       );

//       if (jsonResponse == null) {
//         setState(() {
//           isError = true;
//           errorText = "No response from server";
//           isLoading = false;
//         });
//         return;
//       }

//       final resp = CreateHeaderResponse.fromJson(jsonResponse);

//       if (resp.code == 200 && resp.data != null) {
//         setState(() {
//           apiResponse = resp;
//           headerData = resp.data;
//           isLoading = false;

//           // Reset old data
//           fieldVisible.clear();
//           fieldRequired.clear();
//           fieldReadOnly.clear();

//           // Parse each field dynamically
//           for (var field in resp.data!) {
//             // Store field-level properties
//             fieldVisible[field.fieldId] = field.visible;
//             fieldRequired[field.fieldId] = field.required;
//             fieldReadOnly[field.fieldId] = !field.readWrite;
//             fieldLabels[field.fieldId] = field.labelName;

//             // Assign values and handle visibility

//             switch (field.fieldId) {
//               case "ExpCode4_ID":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedExpCode4Id = field.id.toString();
//                   _selectedExpCode4Value = field.value;
//                 }
//                 break;

//               case "ExpCode5_ID":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedExpCode5Id = field.id.toString();
//                   _selectedExpCode5Value = field.value;
//                 }
//                 break;

//               case "ExpCode6_ID":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedExpCode6CodeId = field.id.toString();
//                   _selectedExpCode6CodeValue = field.value;
//                 }
//                 break;

//               case "DueDate":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _dueDateController.text = field.value;
//                 }
//                 break;

//               case "Unit":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedUnitId = field.id.toString();
//                   _selectedUnitValue = field.value;
//                 }
//                 break;

//               case "SuppliersPartNo":
//                 if (field.visible) {
//                   _suppliersPartNoController.text = field.value;
//                 }
//                 break;

//               case "ItemID":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedItemCodeId = field.id.toString();
//                   _selectedItemCodeValue = field.value;
//                 }
//                 break;

//               case "Quantity":
//                 if (field.visible) {
//                   _quantityController.text = field.value;
//                 }
//                 break;

//               case "PackSize":
//                 if (field.visible) {
//                   _packSizeController.text = field.value;
//                 }
//                 break;

//               case "Price":
//                 if (field.visible) {
//                   _priceController.text = field.value;
//                 }
//                 break;

//               case "Discount_Type":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedDiscountTypeId = field.id.toString();
//                   _selectedDiscountTypeValue = field.value;
//                 }
//                 break;

//               case "Discount":
//                 if (field.visible) {
//                   _discountController.text = field.value;
//                 }
//                 break;

//               case "Tax":
//                 if (field.visible) {
//                   _salesTaxController.text = field.value;
//                 }
//                 break;

//               case "Opex_Capex":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedOpexCapexId = field.id.toString();
//                   _selectedOpexCapexValue = field.value;
//                 }
//                 break;

//               case "Markup":
//                 if (field.visible) {
//                   _markupController.text = field.value;
//                 }
//                 break;

//               case "Expense_Type":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedExpenseTypeId = field.id.toString();
//                   _selectedExpenseTypeValue = field.value;
//                 }
//                 break;

//               case "SupplierID":
//                 if (field.visible && field.value.isNotEmpty) {
//                   _selectedSupplierId = field.id.toString();
//                   _selectedSupplierValue = field.value;
//                 }
//                 break;
//             }
//           }
//         });
//       } else {
//         setState(() {
//           isError = true;
//           errorText = resp.message?.join(', ') ?? "Failed to fetch data";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isError = true;
//         errorText = "Something went wrong: $e";
//         isLoading = false;
//       });
//     }
//   }

// //{fieldID: SupplierID, labelName: Supplier, ID: 268, value: NordicaHK, controlType: dropdown, required: false, readWrite: true, visible: true},
//   @override
//   void initState() {
//     super.initState();
//     fetchOrderLine();
//   }

//   @override
//   void dispose() {
//     _dueDateController.dispose();
//     _suppliersPartNoController.dispose();
//     _quantityController.dispose();
//     _packSizeController.dispose();
//     _priceController.dispose();
//     _discountController.dispose();
//     _salesTaxController.dispose();
//     _markupController.dispose();
//     _supplierPartNoController.dispose();
//     _itemQuantityController.dispose();
//     _itemPackSizeController.dispose();
//     _itemDescriptionController.dispose();

//     super.dispose();
//   }

//   void _saveForm() {
//     // Prepare data for API
//     Map<String, dynamic> formData = {
//       'ExpCode4_ID': _selectedExpCode4Id,
//       'ExpCode5_ID': _selectedExpCode5Id,
//       'ExpCode6_ID': _selectedExpCode6CodeId,
//       'DueDate': _dueDateController.text,
//       'Unit': _selectedUnitId,
//       'SuppliersPartNo': _suppliersPartNoController.text,
//       'ItemID': _selectedItemCodeId,
//       'Quantity': _quantityController.text,
//       'PackSize': _packSizeController.text,
//       'Price': _priceController.text,
//       'Discount_Type': _selectedDiscountTypeId,
//       'Discount': _discountController.text,
//       'Tax': _salesTaxController.text,
//       'Opex_Capex': _selectedOpexCapexId,
//       'Markup': _markupController.text,
//       'Expense_Type': _selectedExpenseTypeId,
//       'SupplierID': _selectedSupplierId,
//     };

//     LoggerData.dataLog("Order Line Form Data: $formData");
//     // print("Order Line Form Data: $formData");

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Order Line Saved Successfully!"),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
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
//           // You can add more customization:
//           trackColor:
//               WidgetStateProperty.all(ColorManager.lightGrey.withOpacity(0.3)),
//           trackBorderColor: WidgetStateProperty.all(ColorManager.grey),
//           minThumbLength: 30,
//           crossAxisMargin: 2,
//           mainAxisMargin: 10,
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
//                     //-------------------- DROPDOWN: Catalog Items --------------------
//                     if (fieldVisible["ItemID"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["ItemID"] ?? "",
//                         value: _selectedItemCodeId,
//                         apiDisplayValue: _selectedItemCodeValue,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedItemCodeId = value;
//                           });
//                         },
//                         isRequired: true,
//                         readOnly: true,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

//                     //-------------------- BIG TEXT FIELD: Item Description --------------------
//                     FormFieldHelper.buildMultilineTextField(
//                       label: "Item Description",
//                       controller: _itemDescriptionController,
//                       hintText: "Enter detailed item description",
//                       isRequired: true,
//                     ),
//                     const SizedBox(height: 10),

// //-------------------- TEXT FIELD: Supplier Part No --------------------
//                     if (fieldVisible["SuppliersPartNo"] ?? false) ...[
//                       FormFieldHelper.buildTextField(
//                         label: fieldLabels["SuppliersPartNo"] ?? "",
//                         controller: _suppliersPartNoController,
//                         hintText:
//                             'Enter ${fieldLabels["SuppliersPartNo"] ?? ""}',
//                         isRequired: fieldRequired["SuppliersPartNo"] ?? false,
//                         readOnly: fieldReadOnly["SuppliersPartNo"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- DATE PICKER: Due Date --------------------
//                     if (fieldVisible["DueDate"] ?? false) ...[
//                       FormFieldHelper.buildDatePickerField(
//                         context: context,
//                         label: fieldLabels["DueDate"] ?? "",
//                         controller: _dueDateController,
//                         isRequired: fieldRequired["DueDate"] ?? false,
//                         readOnly: fieldReadOnly["DueDate"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- TEXT FIELD: Quantity --------------------
//                     if (fieldVisible["Quantity"] ?? false) ...[
//                       FormFieldHelper.buildTextField(
//                         label: fieldLabels["Quantity"] ?? "",
//                         controller: _quantityController,
//                         hintText: 'Enter ${fieldLabels["Quantity"] ?? ""}',
//                         keyboardType: TextInputType.number,
//                         isRequired: fieldRequired["Quantity"] ?? false,
//                         readOnly: fieldReadOnly["Quantity"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                     //-------------------- DROPDOWN: Catalog Items --------------------
//                     if (fieldVisible["SupplierID"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["SupplierID"] ?? "",
//                         value: _selectedSupplierId,
//                         apiDisplayValue: _selectedSupplierValue,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedSupplierId = value;
//                           });
//                         },
//                         isRequired: true,
//                         readOnly: true,
//                       ),
//                       const SizedBox(height: 10),
//                     ],
// //-------------------- DROPDOWN: Unit --------------------
//                     if (fieldVisible["Unit"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["Unit"] ?? "",
//                         value: _selectedUnitId,
//                         apiDisplayValue: _selectedUnitValue,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedUnitId = value;
//                           });
//                         },
//                         isRequired: fieldRequired["Unit"] ?? false,
//                         readOnly: fieldReadOnly["Unit"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- TEXT FIELD: Pack Size --------------------
//                     if (fieldVisible["PackSize"] ?? false) ...[
//                       FormFieldHelper.buildTextField(
//                         label: fieldLabels["PackSize"] ?? "",
//                         controller: _packSizeController,
//                         hintText: 'Enter ${fieldLabels["PackSize"] ?? ""}',
//                         isRequired: fieldRequired["PackSize"] ?? false,
//                         readOnly: fieldReadOnly["PackSize"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- TEXT FIELD: Price --------------------
//                     if (fieldVisible["Price"] ?? false) ...[
//                       FormFieldHelper.buildTextField(
//                         label: fieldLabels["Price"] ?? "",
//                         controller: _priceController,
//                         hintText: 'Enter ${fieldLabels["Price"] ?? ""}',
//                         keyboardType: TextInputType.number,
//                         isRequired: fieldRequired["Price"] ?? false,
//                         readOnly: fieldReadOnly["Price"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- TEXT FIELD: Sales Tax --------------------
//                     if (fieldVisible["Tax"] ?? false) ...[
//                       FormFieldHelper.buildTextField(
//                         label: fieldLabels["Tax"] ?? "",
//                         controller: _salesTaxController,
//                         hintText:
//                             'Enter ${fieldLabels["Tax"] ?? ""} percentage',
//                         keyboardType: TextInputType.number,
//                         isRequired: fieldRequired["Tax"] ?? false,
//                         readOnly: fieldReadOnly["Tax"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- DROPDOWN: ExpCode4_ID (GL) --------------------
//                     if (fieldVisible["ExpCode4_ID"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["ExpCode4_ID"] ?? "",
//                         value: _selectedExpCode4Id,
//                         apiDisplayValue: _selectedExpCode4Value,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedExpCode4Value = value;
//                           });
//                         },
//                         isRequired: fieldRequired["ExpCode4_ID"] ?? false,
//                         readOnly: fieldReadOnly["ExpCode4_ID"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- DROPDOWN: ExpCode5_ID (Property Code) --------------------
//                     if (fieldVisible["ExpCode5_ID"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["ExpCode5_ID"] ?? "",
//                         value: _selectedExpCode5Id,
//                         apiDisplayValue: _selectedExpCode5Value,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedExpCode5Value = value;
//                           });
//                         },
//                         isRequired: fieldRequired["ExpCode5_ID"] ?? false,
//                         readOnly: fieldReadOnly["ExpCode5_ID"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- DROPDOWN: ExpCode6_ID (Nominal Code) --------------------
//                     if (fieldVisible["ExpCode6_ID"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["ExpCode6_ID"] ?? "Nominal Code",
//                         value: _selectedExpCode6CodeId,
//                         apiDisplayValue: _selectedExpCode6CodeValue,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedExpCode6CodeValue = value;
//                           });
//                         },
//                         isRequired: fieldRequired["ExpCode6_ID"] ?? false,
//                         readOnly: fieldReadOnly["ExpCode6_ID"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- DROPDOWN: Opex/Capex --------------------
//                     if (fieldVisible["Opex_Capex"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["Opex_Capex"] ?? "",
//                         value: _selectedOpexCapexId,
//                         apiDisplayValue: _selectedOpexCapexValue,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedOpexCapexValue = value;
//                           });
//                         },
//                         isRequired: fieldRequired["Opex_Capex"] ?? false,
//                         readOnly: fieldReadOnly["Opex_Capex"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- TEXT FIELD: Markup --------------------
//                     if (fieldVisible["Markup"] ?? false) ...[
//                       FormFieldHelper.buildTextField(
//                         label: fieldLabels["Markup"] ?? "",
//                         controller: _markupController,
//                         keyboardType: TextInputType.number,
//                         hintText: 'Enter ${fieldLabels["Markup"] ?? ""}',
//                         isRequired: fieldRequired["Markup"] ?? false,
//                         readOnly: fieldReadOnly["Markup"] ?? false,
//                       ),
//                       const SizedBox(height: 10),
//                     ],

// //-------------------- DROPDOWN: Expense Type --------------------
//                     if (fieldVisible["Expense_Type"] ?? false) ...[
//                       FormFieldHelper.buildDropdownFieldWithIds(
//                         context: context,
//                         label: fieldLabels["Expense_Type"] ?? "",
//                         value: _selectedExpenseTypeId,
//                         apiDisplayValue: _selectedExpenseTypeValue,
//                         items: catalogItems(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedExpenseTypeValue = value;
//                           });
//                         },
//                         isRequired: fieldRequired["Expense_Type"] ?? false,
//                         readOnly: fieldReadOnly["Expense_Type"] ?? false,
//                       ),
//                       const SizedBox(height: 30),
//                     ],

//                     //-------------------- SAVE BUTTON --------------------
//                     SizedBox(
//                       height: 50,
//                       child: CustomButton(
//                         buttonText: 'Save',
//                         onTap: () {
//                           _saveForm();
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/dropdown_response_model.dart';
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

class BaseLineView extends StatefulWidget {
  final int id;
  final int lineId;
  final LineType lineType;
  final String appBarTitle;
  final bool? buttonshow;

  const BaseLineView({
    Key? key,
    required this.id,
    required this.lineId,
    required this.lineType,
    required this.appBarTitle,
    this.buttonshow,
  }) : super(key: key);

  @override
  State<BaseLineView> createState() => _BaseLineViewState();
}

enum LineType {
  order,
  request,
}

class _BaseLineViewState extends State<BaseLineView> {
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
  final TextEditingController _orderItemDescriptionController =
      TextEditingController();
  final TextEditingController _Request_DescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLineData();
  }

  String _getGroupName() {
    return widget.lineType == LineType.order ? 'Order' : 'Request';
  }

  String _getLinePrefix() {
    return widget.lineType == LineType.order ? 'Order' : 'Request';
  }

  // Dropdown data - These can be replaced with API calls
  List<DropdownItem> catalogItems() {
    return [
      DropdownItem(id: "1", description: "CAT-001", code: "pou"),
      DropdownItem(id: "2", description: "CAT-002", code: "pou"),
      DropdownItem(id: "3", description: "CAT-003", code: "pou"),
      DropdownItem(id: "4", description: "CAT-004", code: "pou"),
    ];
  }

  Future<void> fetchLineData() async {
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
          'ID': widget.id,
          'LineID': widget.lineId,
          'group': _getGroupName(),
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
  Future<List<DropdownItem>> _fetchDropdownData(String group,
      {String search = ""}) async {
    try {
      final response = await apiService.getDropdownData(
        context: context,
        group: group,
        search: search, // Use the search parameter here
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

    return [];
  }

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
        return "Contracts";
      case "Order_Budget_Header":
        return "Budgets";
      case "Supp_Cont_ID":
        return "SuppContacts";
      default:
        return "";
    }
  }

  Future<List<DropdownItem>> getXXX({String search = ""}) async {
    return await _fetchDropdownData("XXX", search: search);
  }

  Future<List<DropdownItem>> getItemCodes({String search = ""}) async {
    return await _fetchDropdownData("Item", search: search);
  }

  Future<List<DropdownItem>> getSupplierCodes({String search = ""}) async {
    return await _fetchDropdownData("Supplier", search: search);
  }

  Future<List<DropdownItem>> getUnitCodes({String search = ""}) async {
    return await _fetchDropdownData("Unit", search: search);
  }

  Future<List<DropdownItem>> getExpCode4List({String search = ""}) async {
    return await _fetchDropdownData("ExpCode4", search: search);
  }

  Future<List<DropdownItem>> getExpCode5List({String search = ""}) async {
    return await _fetchDropdownData("ExpCode5", search: search);
  }

  Future<List<DropdownItem>> getExpCode6List({String search = ""}) async {
    return await _fetchDropdownData("ExpCode6", search: search);
  }

  Future<List<DropdownItem>> getOpexCapexCodes({String search = ""}) async {
    return await _fetchDropdownData("OpexCapex", search: search);
  }

  Future<List<DropdownItem>> getExpenseTypeCodes({String search = ""}) async {
    return await _fetchDropdownData("ExpenseType", search: search);
  }

  void _assignFieldValue(Datum field) {
    if (field.visible && field.value.isNotEmpty) {
      switch (field.fieldId) {
        case "ExpCode4_ID":
          _selectedExpCode4Id = field.id.toString();
          _selectedExpCode4Value = field.value;
          break;
        case "ExpCode5_ID":
          _selectedExpCode5Id = field.id.toString();
          _selectedExpCode5Value = field.value;
          break;
        case "ExpCode6_ID":
          _selectedExpCode6CodeId = field.id.toString();
          _selectedExpCode6CodeValue = field.value;
          break;
        case "DueDate":
          _dueDateController.text = field.value;
          break;
        case "Unit":
          _selectedUnitId = field.id.toString();
          _selectedUnitValue = field.value;
          break;
        case "SuppliersPartNo":
          _suppliersPartNoController.text = field.value;
          break;
        case "ItemID":
          _selectedItemCodeId = field.id.toString();
          _selectedItemCodeValue = field.value;
          break;
        case "Quantity":
          _quantityController.text = field.value;
          break;
        case "PackSize":
          _packSizeController.text = field.value;
          break;
        case "Price":
          _priceController.text = field.value;
          break;
        case "Discount_Type":
          _selectedDiscountTypeId = field.id.toString();
          _selectedDiscountTypeValue = field.value;
          break;
        case "Discount":
          _discountController.text = field.value;
          break;
        case "Tax":
          _salesTaxController.text = field.value;
          break;
        case "Opex_Capex":
          _selectedOpexCapexId = field.id.toString();
          _selectedOpexCapexValue = field.value;
          break;
        case "Markup":
          _markupController.text = field.value;
          break;
        case "Expense_Type":
          _selectedExpenseTypeId = field.id.toString();
          _selectedExpenseTypeValue = field.value;
          break;
        case "SupplierID":
          _selectedSupplierId = field.id.toString();
          _selectedSupplierValue = field.value;
          break;
      }
    } else if (field.visible) {
      // Handle text fields without values
      switch (field.fieldId) {
        case "SuppliersPartNo":
          _suppliersPartNoController.text = field.value;
          break;
        case "DueDate":
          _dueDateController.text = field.value;
          break;
        case "Quantity":
          _quantityController.text = field.value;
          break;
        case "PackSize":
          _packSizeController.text = field.value;
          break;
        case "Price":
          _priceController.text = field.value;
          break;
        case "Discount":
          _discountController.text = field.value;
          break;
        case "Tax":
          _salesTaxController.text = field.value;
          break;
        case "Markup":
          _markupController.text = field.value;
          break;
        case "Description":
          _Request_DescriptionController.text = field.value;
          break;
      }
    }
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
    _orderItemDescriptionController.dispose();
    _Request_DescriptionController.dispose();
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
      'Description': _Request_DescriptionController.text,
    };

    LoggerData.dataLog("${_getLinePrefix()} Line Form Data: $formData");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${_getLinePrefix()} Line Saved Successfully!"),
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
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(ColorManager.blue),
          radius: const Radius.circular(8),
          thickness: WidgetStateProperty.all(6),
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
                    // Dynamic Fields
                    ..._buildDynamicFields(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          (SharedPrefs().userOrder == "RW" || SharedPrefs().userRequest == "RW")
              ?     CustomTextActionButton(
                  buttonText: 'Save',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: ColorManager.green,
                  borderColor: ColorManager.green,
                  fontColor: ColorManager.white,
                  isBoldFont: true,
                  fontSize: FontSize.s18,
                  buttonWidth: 150,
                  buttonHeight: 50,
                )
              : null,
    );
  }

  List<Widget> _buildDynamicFields() {
    List<Widget> fields = [];

    void addFieldIfVisible(String fieldId, Widget fieldWidget) {
      if (fieldVisible[fieldId] ?? false) {
        fields.add(fieldWidget);
        fields.add(const SizedBox(height: 10));
      }
    }

    // Item Code Dropdown
    addFieldIfVisible(
      "ItemID",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["ItemID"] ?? "",
        value: _selectedItemCodeId,
        apiDisplayValue: _selectedItemCodeValue,
        fetchItems: getItemCodes,
        onChanged: (value) {
          setState(() {
            _selectedItemCodeId = value;
            // Clear display value when null
            if (value == null) {
              _selectedItemCodeValue = null;
            }
          });
        },
        isRequired: fieldRequired["ItemID"] ?? false,
        readOnly: fieldReadOnly["ItemID"] ?? false,
      ),
    );

// Item Description (Always visible for line items)
    addFieldIfVisible(
      "Description",
      FormFieldHelper.buildMultilineTextField(
          label: "Item Description",
          controller: _Request_DescriptionController,
          hintText: 'Enter ${fieldLabels["Description"] ?? ""}',
          isRequired: fieldRequired["Description"] ?? false,
          readOnly: fieldReadOnly["Description"] ?? false),
    );

// Supplier Part No
    addFieldIfVisible(
      "SuppliersPartNo",
      FormFieldHelper.buildTextField(
        label: fieldLabels["SuppliersPartNo"] ?? "",
        controller: _suppliersPartNoController,
        hintText: 'Enter ${fieldLabels["SuppliersPartNo"] ?? ""}',
        isRequired: fieldRequired["SuppliersPartNo"] ?? false,
        readOnly: fieldReadOnly["SuppliersPartNo"] ?? false,
      ),
    );

// Due Date
    addFieldIfVisible(
      "DueDate",
      FormFieldHelper.buildDatePickerField(
        context: context,
        label: fieldLabels["DueDate"] ?? "",
        controller: _dueDateController,
        isRequired: fieldRequired["DueDate"] ?? false,
        readOnly: fieldReadOnly["DueDate"] ?? false,
      ),
    );

// Quantity
    addFieldIfVisible(
      "Quantity",
      FormFieldHelper.buildTextField(
        label: fieldLabels["Quantity"] ?? "",
        controller: _quantityController,
        hintText: 'Enter ${fieldLabels["Quantity"] ?? ""}',
        keyboardType: TextInputType.number,
        isRequired: fieldRequired["Quantity"] ?? false,
        readOnly: fieldReadOnly["Quantity"] ?? false,
      ),
    );

// Supplier Dropdown
    addFieldIfVisible(
      "SupplierID",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["SupplierID"] ?? "",
        value: _selectedSupplierId,
        apiDisplayValue: _selectedSupplierValue,
        fetchItems: getSupplierCodes,
        onChanged: (value) {
          setState(() {
            _selectedSupplierId = value;
            // Clear display value when null
            if (value == null) {
              _selectedSupplierValue = null;
            }
          });
        },
        isRequired: fieldRequired["SupplierID"] ?? false,
        readOnly: fieldReadOnly["SupplierID"] ?? false,
      ),
    );

// Unit Dropdown
    addFieldIfVisible(
      "Unit",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["Unit"] ?? "",
        value: _selectedUnitId,
        apiDisplayValue: _selectedUnitValue,
        fetchItems: getUnitCodes,
        onChanged: (value) {
          setState(() {
            _selectedUnitId = value;
            // Clear display value when null
            if (value == null) {
              _selectedUnitValue = null;
            }
          });
        },
        isRequired: fieldRequired["Unit"] ?? false,
        readOnly: fieldReadOnly["Unit"] ?? false,
      ),
    );

// Pack Size
    addFieldIfVisible(
      "PackSize",
      FormFieldHelper.buildTextField(
        label: fieldLabels["PackSize"] ?? "",
        controller: _packSizeController,
        hintText: 'Enter ${fieldLabels["PackSize"] ?? ""}',
        isRequired: fieldRequired["PackSize"] ?? false,
        readOnly: fieldReadOnly["PackSize"] ?? false,
      ),
    );

// Price
    addFieldIfVisible(
      "Price",
      FormFieldHelper.buildTextField(
        label: fieldLabels["Price"] ?? "",
        controller: _priceController,
        hintText: 'Enter ${fieldLabels["Price"] ?? ""}',
        keyboardType: TextInputType.number,
        isRequired: fieldRequired["Price"] ?? false,
        readOnly: fieldReadOnly["Price"] ?? false,
      ),
    );

// Sales Tax
    addFieldIfVisible(
      "Tax",
      FormFieldHelper.buildTextField(
        label: fieldLabels["Tax"] ?? "",
        controller: _salesTaxController,
        hintText: 'Enter ${fieldLabels["Tax"] ?? ""} percentage',
        keyboardType: TextInputType.number,
        isRequired: fieldRequired["Tax"] ?? false,
        readOnly: fieldReadOnly["Tax"] ?? false,
      ),
    );

// ExpCode4_ID (GL)
    addFieldIfVisible(
      "ExpCode4_ID",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["ExpCode4_ID"] ?? "",
        value: _selectedExpCode4Id,
        apiDisplayValue: _selectedExpCode4Value,
        fetchItems: getExpCode4List,
        onChanged: (value) {
          setState(() {
            _selectedExpCode4Id = value;
            // Clear display value when null
            if (value == null) {
              _selectedExpCode4Value = null;
            }
          });
        },
        isRequired: fieldRequired["ExpCode4_ID"] ?? false,
        readOnly: fieldReadOnly["ExpCode4_ID"] ?? false,
      ),
    );

// ExpCode5_ID (Property Code)
    addFieldIfVisible(
      "ExpCode5_ID",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["ExpCode5_ID"] ?? "",
        value: _selectedExpCode5Id,
        apiDisplayValue: _selectedExpCode5Value,
        fetchItems: getExpCode5List,
        onChanged: (value) {
          setState(() {
            _selectedExpCode5Id = value;
            // Clear display value when null
            if (value == null) {
              _selectedExpCode5Value = null;
            }
          });
        },
        isRequired: fieldRequired["ExpCode5_ID"] ?? false,
        readOnly: fieldReadOnly["ExpCode5_ID"] ?? false,
      ),
    );

// ExpCode6_ID (Nominal Code)
    addFieldIfVisible(
      "ExpCode6_ID",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["ExpCode6_ID"] ?? "",
        value: _selectedExpCode6CodeId,
        apiDisplayValue: _selectedExpCode6CodeValue,
        fetchItems: getExpCode6List,
        onChanged: (value) {
          setState(() {
            _selectedExpCode6CodeId = value;
            // Clear display value when null
            if (value == null) {
              _selectedExpCode6CodeValue = null;
            }
          });
        },
        isRequired: fieldRequired["ExpCode6_ID"] ?? false,
        readOnly: fieldReadOnly["ExpCode6_ID"] ?? false,
      ),
    );

// Opex/Capex
    addFieldIfVisible(
      "Opex_Capex",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["Opex_Capex"] ?? "",
        value: _selectedOpexCapexId,
        apiDisplayValue: _selectedOpexCapexValue,
        fetchItems: getOpexCapexCodes,
        onChanged: (value) {
          setState(() {
            _selectedOpexCapexId = value;
            // Clear display value when null
            if (value == null) {
              _selectedOpexCapexValue = null;
            }
          });
        },
        isRequired: fieldRequired["Opex_Capex"] ?? false,
        readOnly: fieldReadOnly["Opex_Capex"] ?? false,
      ),
    );

// Markup
    addFieldIfVisible(
      "Markup",
      FormFieldHelper.buildTextField(
        label: fieldLabels["Markup"] ?? "",
        controller: _markupController,
        keyboardType: TextInputType.number,
        hintText: 'Enter ${fieldLabels["Markup"] ?? ""}',
        isRequired: fieldRequired["Markup"] ?? false,
        readOnly: fieldReadOnly["Markup"] ?? false,
      ),
    );

// Expense Type
    addFieldIfVisible(
      "Expense_Type",
      AsyncDropdownField(
        context: context,
        label: fieldLabels["Expense_Type"] ?? "",
        value: _selectedExpenseTypeId,
        apiDisplayValue: _selectedExpenseTypeValue,
        fetchItems: getExpenseTypeCodes,
        onChanged: (value) {
          setState(() {
            _selectedExpenseTypeId = value;
            // Clear display value when null
            if (value == null) {
              _selectedExpenseTypeValue = null;
            }
          });
        },
        isRequired: fieldRequired["Expense_Type"] ?? false,
        readOnly: fieldReadOnly["Expense_Type"] ?? false,
      ),
    );
    return fields;
  }
}
