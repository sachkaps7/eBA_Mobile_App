import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/form_field_helper.dart';
import 'package:eyvo_inventory/core/widgets/searchable_dropdown_modal.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';

class CreateOrderHeaderView extends StatefulWidget {
  const CreateOrderHeaderView({Key? key}) : super(key: key);

  @override
  State<CreateOrderHeaderView> createState() => _CreateOrderHeaderViewState();
}

class _CreateOrderHeaderViewState extends State<CreateOrderHeaderView> {
  // Text Controllers
  final TextEditingController _refNoController = TextEditingController();
  final TextEditingController _deliverToController = TextEditingController();
  final TextEditingController _deliverIncoterms = TextEditingController();
  // Dropdown Selections
  String? _selectedSupplierCode;
  String? _selectedDeliveryCode;
  String? _selectedBudget;
  String? _selectedContactNumber;
  String? _selectedRestaurent;
  String? _selectedAccount;
  String? _selectedInvoiceCode;
  String? _selectedDocumentType;
  String? _selectedCategoryCode;

  // Dropdown Data
  final List<String> supplierCodes = ["1", "2", "3", "4"];
  final List<String> deliveryCodes = [
    "D001",
    "D002",
    "D003",
    "D004",
    "D005",
    "D006",
    "D007",
    "D008",
    "D009",
    "D010",
    "D011",
    "D012",
    "D013",
    "D014",
    "D015",
    "D016"
  ];

  @override
  void dispose() {
    _refNoController.dispose();
    _deliverToController.dispose();
    _deliverIncoterms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: "Order Header",
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
                        // soft background
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: ColorManager.darkBlue
                                .withOpacity(0.1)), // optional border
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildConstantField("Order No", "ORD-1234"),
                          const SizedBox(height: 8),
                          _buildConstantField("Order Date", "13/10/2025"),
                          const SizedBox(height: 8),
                          _buildConstantField("Order Status", "Pending"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Divider(color: ColorManager.lightGrey, thickness: 1),
                    // const SizedBox(height: 16),

                    //-------------------- INPUT FIELDS --------------------
                    FormFieldHelper.buildTextField(
                      label: "Ref No",
                      controller: _refNoController,
                      hintText: "Enter reference number",
                    ),

                    const SizedBox(height: 10),

                    //-------------------- Supplier Code Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Supplier Code",
                      value: _selectedSupplierCode,
                      items: supplierCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedSupplierCode = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    //-------------------- Deliver To Text --------------------
                    FormFieldHelper.buildTextField(
                      label: "Deliver To",
                      controller: _deliverToController,
                      hintText: "Enter delivery location",
                    ),

                    const SizedBox(height: 10),

                    //-------------------- Delivery Code Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Delivery Code",
                      value: _selectedDeliveryCode,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedDeliveryCode = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    //-------------------- Category Code Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Category Code",
                      value: _selectedCategoryCode,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryCode = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    //-------------------- Document Type Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Document Type",
                      value: _selectedDocumentType,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedDocumentType = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    //-------------------- Invoice Code Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Invoice Code",
                      value: _selectedInvoiceCode,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedInvoiceCode = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    //-------------------- Account Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Account",
                      value: _selectedAccount,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedAccount = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    //-------------------- Restaurent Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Restaurent",
                      value: _selectedRestaurent,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedRestaurent = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    //-------------------- Contact Number Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Contact Number",
                      value: _selectedContactNumber,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedContactNumber = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    //-------------------- Incoterms To Text --------------------
                    FormFieldHelper.buildTextField(
                      label: "Incoterms",
                      controller: _deliverIncoterms,
                      hintText: "Enter Incoterms",
                    ),

                    const SizedBox(height: 10),
                    //-------------------- Delivery Code Dropdown --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Budget",
                      value: _selectedBudget,
                      items: deliveryCodes,
                      onChanged: (value) {
                        setState(() {
                          _selectedBudget = value;
                        });
                      },
                    ),

                    const SizedBox(height: 30),
                    //-------------------- SAVE BUTTON --------------------
                    SizedBox(
                      height: 50,
                      child: CustomButton(
                        buttonText: 'Save',
                        onTap: () {
                          print("Saving Order Header...");
                          print("Ref No: ${_refNoController.text}");
                          print("Supplier Code: $_selectedSupplierCode");
                          print("Deliver To: ${_deliverToController.text}");
                          print("Delivery Code: $_selectedDeliveryCode");

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order Header Saved Successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
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
              "$label",
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
