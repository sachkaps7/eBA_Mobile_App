import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/form_field_helper.dart';
import 'package:eyvo_inventory/core/widgets/searchable_dropdown_modal.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';

class CreateOrderLineView extends StatefulWidget {
  const CreateOrderLineView({Key? key}) : super(key: key);

  @override
  State<CreateOrderLineView> createState() => _CreateOrderLineViewState();
}

class _CreateOrderLineViewState extends State<CreateOrderLineView> {
  // Controllers
  final TextEditingController _supplierPartNoController =
      TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemPackSizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salesTaxController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final TextEditingController _itemDueDateController = TextEditingController();

  // Dropdown selections
  String? _selectedCatalogItem;
  String? _selectedItemUnit;

  // Dropdown data
  final List<String> catalogItems = [
    "CAT-001",
    "CAT-002",
    "CAT-003",
    "CAT-004",
  ];

  final List<String> itemUnits = [
    "Box",
    "Piece",
    "Kg",
    "Liters",
  ];

  @override
  void dispose() {
    _supplierPartNoController.dispose();
    _itemQuantityController.dispose();
    _itemPackSizeController.dispose();
    _priceController.dispose();
    _salesTaxController.dispose();
    _itemDescriptionController.dispose();
    _itemDueDateController.dispose();
    super.dispose();
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
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Catalog Item",
                      value: _selectedCatalogItem,
                      items: catalogItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedCatalogItem = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    //-------------------- BIG TEXT FIELD: Item Description --------------------
                    FormFieldHelper.buildMultilineTextField(
                      label: "Item Description",
                      controller: _itemDescriptionController,
                      hintText: "Enter detailed item description",
                    ),
                    const SizedBox(height: 10),
                    //-------------------- TEXT FIELD: Supplier Part No --------------------
                    FormFieldHelper.buildTextField(
                      label: "Supplier Part No",
                      controller: _supplierPartNoController,
                      hintText: "Enter supplier part number",
                    ),
                    const SizedBox(height: 10),

                    //-------------------- DATE PICKER: Item Due Date --------------------
                    FormFieldHelper.buildDatePickerField(
                      context: context,
                      label: "Item Due Date",
                      controller: _itemDueDateController,
                    ),
                    const SizedBox(height: 10),
                    //-------------------- TEXT FIELD: Item Quantity --------------------
                    FormFieldHelper.buildTextField(
                      label: "Item Quantity",
                      controller: _itemQuantityController,
                      hintText: "Enter item quantity",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    //-------------------- DROPDOWN: Item Unit --------------------
                    FormFieldHelper.buildDropdownField(
                      context: context,
                      label: "Item Unit",
                      value: _selectedItemUnit,
                      items: itemUnits,
                      onChanged: (value) {
                        setState(() {
                          _selectedItemUnit = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    //-------------------- TEXT FIELD: Item Pack Size --------------------
                    FormFieldHelper.buildTextField(
                      label: "Item Pack Size",
                      controller: _itemPackSizeController,
                      hintText: "Enter item pack size",
                    ),
                    const SizedBox(height: 10),

                    //-------------------- TEXT FIELD: Price (USD) --------------------
                    FormFieldHelper.buildTextField(
                      label: "Price (USD)",
                      controller: _priceController,
                      hintText: "Enter price in USD",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    //-------------------- TEXT FIELD: Sales Tax % --------------------
                    FormFieldHelper.buildTextField(
                      label: "Sales Tax %",
                      controller: _salesTaxController,
                      hintText: "Enter sales tax percentage",
                      keyboardType: TextInputType.number,
                    ),
                    //  const SizedBox(height: 10),

                    const SizedBox(height: 30),

                    //-------------------- SAVE BUTTON --------------------
                    SizedBox(
                      height: 50,
                      child: CustomButton(
                        buttonText: 'Save',
                        onTap: () {
                          print("Saving Order Line...");
                          print("Catalog Item: $_selectedCatalogItem");
                          print("Item Unit: $_selectedItemUnit");
                          print(
                              "Supplier Part No: ${_supplierPartNoController.text}");
                          print(
                              "Item Quantity: ${_itemQuantityController.text}");
                          print(
                              "Item Pack Size: ${_itemPackSizeController.text}");
                          print("Price: ${_priceController.text}");
                          print("Sales Tax: ${_salesTaxController.text}");
                          print(
                              "Item Description: ${_itemDescriptionController.text}");
                          print(
                              "Item Due Date: ${_itemDueDateController.text}");

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order Line Saved Successfully!"),
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
}
