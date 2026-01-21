import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:eyvo_v3/api/response_models/order_header_response.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/widgets/custom_field.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/widgets/searchable_dropdown_modal.dart';

class FormFieldHelper {
  //-------------------- TEXT FIELD --------------------

  // static Widget buildTextField({
  //   required String label,
  //   required TextEditingController controller,
  //   required String hintText,
  //   TextInputType keyboardType = TextInputType.text,
  //   bool isRequired = false,
  //   bool readOnly = false,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: getSemiBoldStyle(
  //           color: ColorManager.black,
  //           fontSize: FontSize.s14,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Stack(
  //         children: [
  //           FocusScope(
  //             canRequestFocus: !readOnly,
  //             child: TextField(
  //               controller: controller,
  //               keyboardType: keyboardType,
  //               readOnly: readOnly,
  //               style: TextStyle(
  //                 color: ColorManager.black,
  //                 fontSize: FontSize.s14,
  //               ),
  //               decoration: InputDecoration(
  //                 hintText: hintText,
  //                 filled: true,
  //                 fillColor: readOnly
  //                     ? ColorManager.readOnlyColor
  //                     : ColorManager.white,
  //                 hintStyle: getMediumStyle(
  //                   color: ColorManager.lightGrey,
  //                   fontSize: FontSize.s14,
  //                 ),
  //                 contentPadding:
  //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

  //                 //Show icon only in read-only mode
  //                 suffixIcon: readOnly
  //                     ? Icon(
  //                         Icons.lock_outline,
  //                         color: ColorManager.lightGrey3,
  //                         size: 20,
  //                       )
  //                     : null,

  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                   borderSide: BorderSide(
  //                     color: readOnly
  //                         ? ColorManager.lightGrey
  //                         : ColorManager.darkGrey,
  //                     width: 1.0,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                   borderSide: BorderSide(
  //                     color:
  //                         readOnly ? ColorManager.lightGrey : ColorManager.blue,
  //                     width: readOnly ? 1.0 : 2.0,
  //                   ),
  //                 ),
  //                 disabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                   borderSide: BorderSide(
  //                     color: ColorManager.lightGrey,
  //                     width: 1.0,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),

  //           // Red triangle indicator (if required)
  //           if (isRequired)
  //             Positioned(
  //               right: 0,
  //               top: 0,
  //               child: CustomPaint(
  //                 size: const Size(12, 12),
  //                 painter: _RedTrianglePainter(),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  static Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
    bool readOnly = false,
    bool showError = false,
    String? errorText,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getSemiBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            FocusScope(
              canRequestFocus: !readOnly,
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                readOnly: readOnly,
                onChanged: (_) => onChanged?.call(),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: getMediumStyle(
                    color: ColorManager.lightGrey,
                    fontSize: FontSize.s14,
                  ),
                  errorText: showError
                      ? (errorText ?? "This field is required")
                      : null,
                  filled: true,
                  fillColor: readOnly
                      ? ColorManager.readOnlyColor
                      : ColorManager.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: readOnly
                      ? Icon(Icons.lock_outline,
                          color: ColorManager.lightGrey3, size: 20)
                      : null,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: readOnly
                          ? ColorManager.lightGrey
                          : ColorManager.darkGrey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          readOnly ? ColorManager.lightGrey : ColorManager.blue,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
            ),
            if (isRequired)
              Positioned(
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(12, 12),
                  painter: _RedTrianglePainter(),
                ),
              ),
          ],
        ),
      ],
    );
  }

//----------------- Card Widget---------------------------
  static Widget buildCardWidget({
    required int index,
    required List<Map<String, String>> subtitles,
    required List<bool> isCardSelected,
    required VoidCallback onTap,
  }) {
    final isSelected = isCardSelected[index];

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // always rectangle
          side: BorderSide(
            color: isSelected ? ColorManager.darkBlue : Colors.transparent,
            width: 1.5,
          ),
        ),
        color: isSelected ? ColorManager.highlightColor : Colors.white,
        // elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: subtitles.map((item) {
                    final key = item.keys.first;
                    final value = item.values.first;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, bottom: 4),
                            child: Text(
                              "$key",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize.s16,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                          ),
                          // Colon
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              ':',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize.s16,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                          ),
                          // Value
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              value,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: FontSize.s16,
                                color: ColorManager.darkGrey,
                                decoration: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: ColorManager.darkBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //-------------------- MULTILINE TEXT FIELD --------------------
  static Widget buildMultilineTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 4,
    bool isRequired = false,
    bool readOnly = false,
    bool showLengthError = false,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: getSemiBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // TEXT FIELD
        Stack(
          alignment: Alignment.topRight,
          children: [
            FocusScope(
              canRequestFocus: !readOnly,
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                readOnly: readOnly,
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: readOnly
                      ? ColorManager.readOnlyColor
                      : ColorManager.white,
                  hintText: hintText,
                  hintStyle: getMediumStyle(
                    color: ColorManager.lightGrey,
                    fontSize: FontSize.s14,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: ColorManager.darkGrey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          readOnly ? ColorManager.darkGrey : ColorManager.blue,
                      width: readOnly ? 1.0 : 2.0,
                    ),
                  ),
                ),
              ),
            ),
            if (readOnly)
              Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: ColorManager.lightGrey3,
                ),
              ),
            if (isRequired)
              Positioned(
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(16, 16),
                  painter: _RedTrianglePainter(),
                ),
              ),
          ],
        ),

        // ERROR MESSAGE
        if (showLengthError && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: ColorManager.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
  // static Widget buildNotesTextField({
  //   required String label,
  //   required TextEditingController controller,
  //   String? hintText,
  //   int maxLines = 4,
  //   bool isRequired = false,
  //   bool readOnly = false,
  //   int maxLength = 2500,
  //   bool showLengthError = false,
  //   String? errorMessage,
  // }) {
  //   int currentLength = controller.text.length;
  //   int remaining = maxLength - currentLength;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Text(
  //             label,
  //             style: getSemiBoldStyle(
  //               color: ColorManager.black,
  //               fontSize: FontSize.s14,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),

  //       // TEXT FIELD
  //       Stack(
  //         alignment: Alignment.topRight,
  //         children: [
  //           FocusScope(
  //             canRequestFocus: !readOnly,
  //             child: TextField(
  //               controller: controller,
  //               maxLines: maxLines,
  //               readOnly: readOnly,
  //               maxLength: maxLength, // <-- LIMIT APPLIED
  //               style: TextStyle(
  //                 fontSize: FontSize.s14,
  //                 color: ColorManager.black,
  //               ),
  //               decoration: InputDecoration(
  //                 counterText: "", // hide default counter
  //                 filled: true,
  //                 fillColor: readOnly
  //                     ? ColorManager.readOnlyColor
  //                     : ColorManager.white,
  //                 hintText: hintText,
  //                 hintStyle: getMediumStyle(
  //                   color: ColorManager.lightGrey,
  //                   fontSize: FontSize.s14,
  //                 ),
  //                 contentPadding:
  //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                   borderSide: BorderSide(
  //                     color: ColorManager.darkGrey,
  //                     width: 1.0,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                   borderSide: BorderSide(
  //                     color:
  //                         readOnly ? ColorManager.darkGrey : ColorManager.blue,
  //                     width: readOnly ? 1.0 : 2.0,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           if (readOnly)
  //             Positioned(
  //               right: 8,
  //               top: 8,
  //               child: Icon(
  //                 Icons.lock_outline,
  //                 size: 20,
  //                 color: ColorManager.lightGrey3,
  //               ),
  //             ),
  //           if (isRequired)
  //             Positioned(
  //               right: 0,
  //               top: 0,
  //               child: CustomPaint(
  //                 size: const Size(16, 16),
  //                 painter: _RedTrianglePainter(),
  //               ),
  //             ),
  //         ],
  //       ),

  //       const SizedBox(height: 6),

  //       // REMAINING CHARACTERS
  //       Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(
  //           "Characters Remaining: $remaining",
  //           style: TextStyle(
  //             color: remaining == 0 ? ColorManager.red : ColorManager.grey,
  //             fontSize: FontSize.s12,
  //           ),
  //         ),
  //       ),

  //       // ERROR MESSAGE
  //       if (showLengthError && errorMessage != null)
  //         Padding(
  //           padding: const EdgeInsets.only(top: 6),
  //           child: Text(
  //             errorMessage,
  //             style: TextStyle(
  //               color: ColorManager.red,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //     ],
  //   );
  // }
  static Widget buildNotesTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 4,
    bool isRequired = false,
    bool readOnly = false,
    int maxLength = 2500,
    bool showLengthError = false,
    String? errorMessage,
  }) {
    final currentLength = controller.text.length;
    final remaining = maxLength - currentLength;

    final borderColor =
        readOnly ? ColorManager.lightGrey : ColorManager.darkGrey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL
        Row(
          children: [
            Text(
              label,
              style: getSemiBoldStyle(
                color: readOnly ? ColorManager.grey : ColorManager.black,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // TEXT FIELD
        Stack(
          children: [
            FocusScope(
              canRequestFocus: !readOnly,
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                readOnly: readOnly,
                maxLength: maxLength,
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: readOnly ? ColorManager.grey : ColorManager.black,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: readOnly
                      ? ColorManager.readOnlyColor
                      : ColorManager.white,
                  hintText: hintText,
                  hintStyle: getMediumStyle(
                    color: ColorManager.lightGrey,
                    fontSize: FontSize.s14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: readOnly ? borderColor : ColorManager.blue,
                      width: readOnly ? 1.0 : 2.0,
                    ),
                  ),
                ),
              ),
            ),
            // 🔺 REQUIRED MARK
            if (isRequired)
              Positioned(
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(16, 16),
                  painter: _RedTrianglePainter(),
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),

        // CHARACTER COUNTER
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Characters Remaining: $remaining",
            style: TextStyle(
              color: remaining == 0 ? ColorManager.red : ColorManager.grey,
              fontSize: FontSize.s12,
            ),
          ),
        ),

        // ERROR MESSAGE
        if (showLengthError && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: ColorManager.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  //-------------------- DROPDOWN FIELD --------------------
  static Widget buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false, // new parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getSemiBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            GestureDetector(
              onTap: () async {
                final selected = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => SearchableDropdownModal(
                    items: items,
                    selectedValue: value,
                  ),
                );
                if (selected != null) {
                  onChanged(selected);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorManager.lightGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value ?? "Select $label",
                      style: TextStyle(
                        fontSize: FontSize.s14,
                        color: value == null
                            ? ColorManager.grey
                            : ColorManager.black,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            // Red triangle if required
            if (isRequired)
              Positioned(
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(12, 12),
                  painter: _RedTrianglePainter(),
                ),
              ),
          ],
        ),
      ],
    );
  }

//----------------------------------DROPDOWN FIELD with IDs---------------------------------------------

  static Widget buildDropdownFieldWithIds({
    required BuildContext context,
    required String label,
    required String? value, // String ID
    required List<DropdownItem> items,
    required ValueChanged<String?> onChanged, // String ID
    bool isRequired = false,
    String? apiDisplayValue,
    bool readOnly = false,
  }) {
    // Determine display value for the given ID
    String? displayValue;

    if (value != null) {
      try {
        final foundItem = items.firstWhere(
          (item) => item.id == value,
          orElse: () => DropdownItem(id: '', description: '', code: ''),
        );
        displayValue =
            foundItem.id.isNotEmpty ? foundItem.description : apiDisplayValue;
      } catch (e) {
        displayValue = apiDisplayValue;
      }
    } else {
      displayValue = apiDisplayValue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getSemiBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            GestureDetector(
              onTap: readOnly
                  ? null
                  : () async {
                      List<String> displayItems =
                          items.map((item) => item.description).toList();

                      if (apiDisplayValue != null &&
                          !displayItems.contains(apiDisplayValue)) {
                        displayItems.add(apiDisplayValue!);
                      }

                      final selectedDisplayValue =
                          await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => SearchableDropdownModal(
                          items: displayItems,
                          selectedValue: displayValue,
                        ),
                      );

                      if (selectedDisplayValue != null) {
                        String selectedId;
                        if (selectedDisplayValue == apiDisplayValue) {
                          selectedId = value ?? '';
                        } else {
                          selectedId = items
                              .firstWhere((item) =>
                                  item.description == selectedDisplayValue)
                              .id;
                        }
                        onChanged(selectedId);
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: readOnly
                      ? ColorManager.readOnlyColor
                      : ColorManager.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorManager.darkGrey,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayValue ?? "Select $label",
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          color: displayValue == null
                              ? ColorManager.grey
                              : ColorManager.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     if (readOnly) ...[
                    //       Icon(
                    //         Icons.arrow_drop_down,
                    //         color: ColorManager.lightGrey3,
                    //       ),
                    //       Icon(
                    //         Icons.lock_outline,
                    //         size: 20,
                    //         color: ColorManager.lightGrey3,
                    //       ),
                    //     ] else
                    //       Icon(
                    //         Icons.arrow_drop_down,
                    //         color: ColorManager.darkGrey,
                    //       ),
                    //   ],
                    // )

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (readOnly)
                          Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: ColorManager.lightGrey3,
                          )
                        else
                          Icon(
                            Icons.arrow_drop_down,
                            color: ColorManager.darkGrey,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Red triangle (if required)
            if (isRequired)
              Positioned(
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(12, 12),
                  painter: _RedTrianglePainter(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // static Widget buildDropdownFieldWithIds1({
  //   required BuildContext context,
  //   required String label,
  //   required String? value,
  //   required Future<List<DropdownItem>> Function() fetchItems,
  //   required ValueChanged<String?> onChanged,
  //   bool isRequired = false,
  //   String? apiDisplayValue,
  //   bool readOnly = false,
  //   Function(String?)? onDisplayValueUpdate, // Changed to String?
  //   required TextEditingController searchController,
  // }) {
  //   String? displayValue = apiDisplayValue;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: getSemiBoldStyle(
  //           color: ColorManager.black,
  //           fontSize: FontSize.s14,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Stack(
  //         children: [
  //           GestureDetector(
  //             onTap: readOnly
  //                 ? null
  //                 : () async {
  //                     searchController.clear();
  //                     final items = await fetchItems();

  //                     final selectedDisplayValue =
  //                         await showModalBottomSheet<String?>(
  //                       context: context,
  //                       isScrollControlled: true,
  //                       builder: (_) => CustomDropdownModal(
  //                         items: items,
  //                         selectedValue: displayValue,
  //                         label: label,
  //                         searchController: searchController,
  //                         allowDeselection: !isRequired, // Added this parameter
  //                         onSearchChanged: () async {
  //                           return await fetchItems();
  //                         },
  //                       ),
  //                     );

  //                     if (selectedDisplayValue != null) {
  //                       String selectedId;
  //                       String selectedDisplayText;

  //                       if (selectedDisplayValue == apiDisplayValue) {
  //                         selectedId = value ?? '';
  //                         selectedDisplayText = selectedDisplayValue;
  //                       } else {
  //                         // Extract the code from the selected display value (part before " - ")
  //                         final selectedCode =
  //                             selectedDisplayValue.split(' - ').first;

  //                         // Find the actual item to get the proper ID
  //                         final selectedItem = items.firstWhere(
  //                           (item) => item.code == selectedCode,
  //                           orElse: () =>
  //                               DropdownItem(id: '', description: '', code: ''),
  //                         );

  //                         selectedId = selectedItem.id;
  //                         // Show both code and description as display value
  //                         selectedDisplayText =
  //                             "${selectedItem.code} - ${selectedItem.description}";
  //                       }

  //                       // Update display value to show both code and description
  //                       displayValue = selectedDisplayText;

  //                       // Notify parent if callback provided
  //                       onDisplayValueUpdate?.call(selectedDisplayText);

  //                       onChanged(selectedId);
  //                     } else {
  //                       // Handle null case (deselection)
  //                       displayValue = null;
  //                       onDisplayValueUpdate?.call(null);
  //                       onChanged(null);
  //                     }
  //                   },
  //             child: Container(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  //               decoration: BoxDecoration(
  //                 color: readOnly
  //                     ? ColorManager.readOnlyColor
  //                     : ColorManager.white,
  //                 borderRadius: BorderRadius.circular(8),
  //                 border: Border.all(
  //                   color: ColorManager.darkGrey,
  //                   width: 1.0,
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       displayValue ?? "Select $label",
  //                       style: TextStyle(
  //                         fontSize: FontSize.s14,
  //                         color: displayValue == null
  //                             ? ColorManager.grey
  //                             : ColorManager.black,
  //                       ),
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                   Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       if (readOnly)
  //                         Icon(Icons.lock_outline,
  //                             size: 20, color: ColorManager.lightGrey3)
  //                       else
  //                         Icon(Icons.arrow_drop_down,
  //                             color: ColorManager.darkGrey),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           if (isRequired)
  //             Positioned(
  //               right: 0,
  //               top: 0,
  //               child: CustomPaint(
  //                 size: const Size(12, 12),
  //                 painter: _RedTrianglePainter(),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
  static Widget buildDropdownFieldWithIds1({
    required BuildContext context,
    required String label,
    required String? value,
    required Future<List<DropdownItem>> Function() fetchItems,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
    String? apiDisplayValue,
    bool readOnly = false,
    bool showError = false,
    Function(String?)? onDisplayValueUpdate,
    required TextEditingController searchController,
  }) {
    String? displayValue = apiDisplayValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getSemiBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            GestureDetector(
              onTap: readOnly
                  ? null
                  : () async {
                      searchController.clear();
                      final items = await fetchItems();

                      final selectedDisplayValue =
                          await showModalBottomSheet<String?>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => CustomDropdownModal(
                          items: items,
                          selectedValue: displayValue,
                          label: label,
                          searchController: searchController,
                          allowDeselection: !isRequired,
                          onSearchChanged: () async {
                            return await fetchItems();
                          },
                        ),
                      );

                      if (selectedDisplayValue != null) {
                        String selectedId;
                        String selectedDisplayText;

                        if (selectedDisplayValue == apiDisplayValue) {
                          selectedId = value ?? '';
                          selectedDisplayText = selectedDisplayValue;
                        } else {
                          final selectedCode =
                              selectedDisplayValue.split(' - ').first;

                          final selectedItem = items.firstWhere(
                            (item) => item.code == selectedCode,
                            orElse: () => DropdownItem(
                              id: '',
                              description: '',
                              code: '',
                            ),
                          );

                          selectedId = selectedItem.id;
                          selectedDisplayText =
                              "${selectedItem.code} - ${selectedItem.description}";
                        }

                        displayValue = selectedDisplayText;
                        onDisplayValueUpdate?.call(selectedDisplayText);
                        onChanged(selectedId);
                      } else {
                        displayValue = null;
                        onDisplayValueUpdate?.call(null);
                        onChanged(null);
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: readOnly
                      ? ColorManager.readOnlyColor
                      : ColorManager.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: showError ? ColorManager.red : ColorManager.darkGrey,
                    width: showError ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayValue ?? "Select $label",
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          color: displayValue == null
                              ? ColorManager.grey
                              : ColorManager.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (readOnly)
                      Icon(Icons.lock_outline,
                          size: 20, color: ColorManager.lightGrey3)
                    else
                      Icon(Icons.arrow_drop_down, color: ColorManager.darkGrey),
                  ],
                ),
              ),
            ),
            if (isRequired)
              Positioned(
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(12, 12),
                  painter: _RedTrianglePainter(),
                ),
              ),
          ],
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "This field is required",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

//-------------------------------------------------Date picker ----------------------
  static Widget buildDatePickerField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getSemiBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            FocusScope(
              canRequestFocus: !readOnly,
              child: TextField(
                controller: controller,
                readOnly: true,
                onTap: readOnly
                    ? null
                    : () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: ColorManager.darkBlue,
                                  onPrimary: ColorManager.white,
                                  onSurface: ColorManager.darkGrey,
                                ),
                                dialogBackgroundColor: ColorManager.white,
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          controller.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        }
                      },
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
                decoration: InputDecoration(
                  hintText: "Select date",
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.calendar_month,
                          size: readOnly ? 20 : 25,
                          color: readOnly
                              ? ColorManager.lightGrey3
                              : ColorManager.darkGrey,
                        ),
                      ),
                      if (readOnly)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: ColorManager.lightGrey3,
                          ),
                        ),
                    ],
                  ),
                  filled: true,
                  fillColor: readOnly
                      ? ColorManager.readOnlyColor
                      : ColorManager.white,
                  hintStyle: getMediumStyle(
                    color: ColorManager.lightGrey,
                    fontSize: FontSize.s14,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: readOnly
                          ? ColorManager.darkGrey
                          : ColorManager.darkGrey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          readOnly ? ColorManager.darkGrey : ColorManager.blue,
                      width: readOnly ? 1.0 : 2.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: ColorManager.darkGrey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),

            // Red triangle indicator (if required)
            if (isRequired)
              Positioned(
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(12, 12),
                  painter: _RedTrianglePainter(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  //-------------------- INFO CARD --------------------
  // static Widget buildInfoCard({
  //   required int index,
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   required List<bool> isCardSelected,
  //   required VoidCallback onTap,
  // }) {
  //   final isSelected = isCardSelected[index];

  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Card(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         side: BorderSide(
  //           color: isSelected ? ColorManager.darkBlue : ColorManager.lightGrey,
  //           width: 1,
  //         ),
  //       ),
  //       color: isSelected ? ColorManager.highlightColor : Colors.white,
  //       elevation: 2,
  //       child: Padding(
  //         padding: const EdgeInsets.all(12),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Icon(icon, color: ColorManager.darkBlue, size: 28),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: getSemiBoldStyle(
  //                       color: ColorManager.black,
  //                       fontSize: FontSize.s16,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     subtitle,
  //                     style: getRegularStyle(
  //                       color: ColorManager.darkGrey,
  //                       fontSize: FontSize.s14,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             if (isSelected)
  //               Container(
  //                 width: 24,
  //                 height: 24,
  //                 decoration: BoxDecoration(
  //                   color: ColorManager.darkBlue,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(Icons.check, color: Colors.white, size: 16),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  static Widget buildInfoCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<bool> isCardSelected,
    required VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    final isSelected = isCardSelected[index];

    final borderColor = !isEnabled
        ? ColorManager.lightGrey
        : isSelected
            ? ColorManager.darkBlue
            : ColorManager.lightGrey;

    final bgColor = !isEnabled
        ? ColorManager.lightGrey.withOpacity(0.2)
        : isSelected
            ? ColorManager.highlightColor
            : Colors.white;

    final iconColor = !isEnabled ? ColorManager.grey : ColorManager.darkBlue;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.6,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 1),
          ),
          color: bgColor,
          elevation: isEnabled ? 2 : 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getSemiBoldStyle(
                          color: isEnabled
                              ? ColorManager.black
                              : ColorManager.grey,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: getRegularStyle(
                          color: isEnabled
                              ? ColorManager.darkGrey
                              : ColorManager.grey,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✔ Show check even in read-only mode
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color:
                          isEnabled ? ColorManager.darkBlue : ColorManager.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- UPLOAD BOX --------------------
  static Widget buildUploadBox({
    required File? selectedFile,
    required Function() onPickFile,
    required Function() onRemoveFile,
    bool isUploading = false,
  }) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [6, 3],
      color: ColorManager.lightGrey1,
      strokeWidth: 1,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: selectedFile == null
            ? Center(
                child: GestureDetector(
                  onTap: onPickFile,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageAssets.uploadIcon2, height: 60),
                      const SizedBox(height: 8),
                      Text(
                        "Choose a file",
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Supports JPEG,PNG,PDF up to 5MB",
                        style: getRegularStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      selectedFile,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemoveFile,
                      child: CircleAvatar(
                        backgroundColor: ColorManager.red,
                        radius: 16,
                        child: Icon(Icons.delete,
                            size: 18, color: ColorManager.white),
                      ),
                    ),
                  ),
                  if (isUploading)
                    const Positioned.fill(
                      child: Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CustomProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  //-------------------- FILE STATUS WIDGET --------------------
  static Widget buildFileStatus({
    required bool isInvalidFormat,
    required bool isFileTooLarge,
    String? fileSize,
  }) {
    if (isInvalidFormat) {
      return Text(
        "Invalid format. Please upload JPG, JPEG, PNG, HEIC, or HEIF.",
        style: TextStyle(color: ColorManager.red, fontWeight: FontWeight.bold),
      );
    } else if (isFileTooLarge) {
      return Text(
        "The file size exceeds ${AppConstants.imageSizeLimitMB} MB",
        style: TextStyle(color: ColorManager.red, fontWeight: FontWeight.bold),
      );
    } else if (fileSize != null) {
      return Text(
        "Size: $fileSize",
        style:
            TextStyle(color: ColorManager.green, fontWeight: FontWeight.bold),
      );
    }
    return const SizedBox.shrink();
  }

//-------------------- FILE STATUS FOR FILE UPLOAD --------------------
  static Widget buildFileStatusForFileUpload({
    required bool isInvalidFormat,
    required bool isFileTooLarge,
    required bool isFileNameTooLong,
    String? fileSize,
    String? fileExtension,
  }) {
    if (isInvalidFormat) {
      return Text(
        "Invalid file type selected.",
        style: TextStyle(color: ColorManager.red, fontWeight: FontWeight.bold),
      );
    } else if (isFileTooLarge) {
      return Text(
        "The file size exceeds ${AppConstants.imageSizeLimitMB} MB",
        style: TextStyle(color: ColorManager.red, fontWeight: FontWeight.bold),
      );
    } else if (isFileNameTooLong) {
      return Text(
        "The file name is too long. File names must not exceed 50 characters.",
        style: TextStyle(color: ColorManager.red, fontWeight: FontWeight.bold),
      );
    } else if (fileSize != null) {
      return Text(
        "Size: $fileSize${fileExtension != null ? "  :  Type: $fileExtension" : ""}",
        style: TextStyle(
          color: ColorManager.green,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // -------------------- UPLOAD BOX FOR FILE  --------------------
  static Widget buildUploadBoxForFile({
    required File? selectedFile,
    required VoidCallback onPickFile,
    required VoidCallback onRemoveFile,
    required bool isUploading,
  }) {
    final String? ext = selectedFile != null
        ? selectedFile.path.split('.').last.toLowerCase()
        : null;

    final bool isImage =
        ext != null && AppConstants.allowedImageFormats.contains(ext);

    return GestureDetector(
      onTap: onPickFile,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        color: ColorManager.lightGrey1,
        strokeWidth: 1,
        dashPattern: const [6, 3],
        child: Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: selectedFile == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImageAssets.uploadIcon2, height: 60),
                    const SizedBox(height: 8),
                    Text(
                      "Choose a file",
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Supports up to 5MB",
                      style: getRegularStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Center(
                      child: isImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox.expand(
                                child: Image.file(
                                  selectedFile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _fileIcon(ext),
                                const SizedBox(height: 8),
                                Text(
                                  selectedFile.path.split('/').last,
                                  textAlign: TextAlign.center,
                                  style: getRegularStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    // DELETE BUTTON
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: onRemoveFile,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: ColorManager.red,
                          child: Icon(Icons.delete,
                              size: 18, color: ColorManager.white),
                        ),
                      ),
                    ),
                    if (isUploading)
                      const Positioned.fill(
                        child: Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CustomProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  static Icon _fileIcon(String? ext) {
    switch (ext) {
      case "pdf":
        return Icon(Icons.picture_as_pdf, size: 70, color: ColorManager.red);
      case "doc":
      case "docx":
        return Icon(Icons.description, size: 70, color: ColorManager.lightBlue);
      case "xls":
      case "xlsx":
        return Icon(Icons.table_chart, size: 70, color: ColorManager.green);
      case "zip":
      case "rar":
        return Icon(Icons.archive, size: 70, color: ColorManager.orange);
      default:
        return Icon(Icons.insert_drive_file,
            size: 70, color: ColorManager.grey);
    }
  }
}

class _DropdownTableModal extends StatefulWidget {
  final List<DropdownItem> items;
  final String? selectedId;
  final String label;

  const _DropdownTableModal({
    required this.items,
    required this.selectedId,
    required this.label,
  });

  @override
  State<_DropdownTableModal> createState() => _DropdownTableModalState();
}

class _DropdownTableModalState extends State<_DropdownTableModal> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      return item.description
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          item.id.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Select ${widget.label}',
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 12),

            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by ID or Name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (val) => setState(() => searchText = val),
            ),
            const SizedBox(height: 12),

            // Header row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: ColorManager.lightGrey2,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'ID',
                      style: getSemiBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Value',
                      style: getSemiBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),

            // List of rows
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final bool isSelected = item.id == widget.selectedId;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, item.id);
                    },
                    child: Container(
                      color: isSelected
                          ? ColorManager.lightGrey3
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.id,
                              style: getRegularStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              item.description,
                              style: getRegularStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the red triangle
class _RedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ColorManager.red2;
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// class AsyncDropdownField extends StatefulWidget {
//   final BuildContext context;
//   final String label;
//   final String? value;
//   final Future<List<DropdownItem>> Function({String search}) fetchItems;
//   final ValueChanged<String?> onChanged;
//   final bool isRequired;
//   final String? apiDisplayValue;
//   final bool readOnly;

//   const AsyncDropdownField({
//     Key? key,
//     required this.context,
//     required this.label,
//     required this.value,
//     required this.fetchItems,
//     required this.onChanged,
//     this.isRequired = false,
//     this.apiDisplayValue,
//     this.readOnly = false,
//   }) : super(key: key);

//   @override
//   _AsyncDropdownFieldState createState() => _AsyncDropdownFieldState();
// }

// class _AsyncDropdownFieldState extends State<AsyncDropdownField> {
//   String? _displayValue;
//   late TextEditingController _searchController;

//   @override
//   void initState() {
//     super.initState();
//     _displayValue = widget.apiDisplayValue;
//     _searchController = TextEditingController();
//   }

//   Future<List<DropdownItem>> _fetchItemsWithSearch() async {
//     final searchText = _searchController.text;
//     return await widget.fetchItems(search: searchText);
//   }

//   @override
//   void didUpdateWidget(AsyncDropdownField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.apiDisplayValue != oldWidget.apiDisplayValue) {
//       _displayValue = widget.apiDisplayValue;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FormFieldHelper.buildDropdownFieldWithIds1(
//       context: widget.context,
//       label: widget.label,
//       value: widget.value,
//       fetchItems: () => _fetchItemsWithSearch(),
//       onChanged: (value) {
//         widget.onChanged(value);
//       },
//       isRequired: widget.isRequired,
//       apiDisplayValue: _displayValue,
//       readOnly: widget.readOnly,
//       onDisplayValueUpdate: (newDisplayValue) {
//         setState(() {
//           _displayValue = newDisplayValue;
//         });
//       },
//       searchController: _searchController,
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }
class AsyncDropdownField extends StatefulWidget {
  final BuildContext context;
  final String label;
  final String? value;
  final Future<List<DropdownItem>> Function({String search}) fetchItems;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final String? apiDisplayValue;
  final bool readOnly;

  final bool showError;
  final VoidCallback? onChangedClearError;

  const AsyncDropdownField({
    Key? key,
    required this.context,
    required this.label,
    required this.value,
    required this.fetchItems,
    required this.onChanged,
    this.isRequired = false,
    this.apiDisplayValue,
    this.readOnly = false,
    this.showError = false,
    this.onChangedClearError,
  }) : super(key: key);

  @override
  _AsyncDropdownFieldState createState() => _AsyncDropdownFieldState();
}

class _AsyncDropdownFieldState extends State<AsyncDropdownField> {
  String? _displayValue;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.apiDisplayValue;
    _searchController = TextEditingController();
  }

  Future<List<DropdownItem>> _fetchItemsWithSearch() async {
    final searchText = _searchController.text;
    return await widget.fetchItems(search: searchText);
  }

  @override
  void didUpdateWidget(AsyncDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.apiDisplayValue != oldWidget.apiDisplayValue) {
      _displayValue = widget.apiDisplayValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldHelper.buildDropdownFieldWithIds1(
      context: widget.context,
      label: widget.label,
      value: widget.value,
      fetchItems: () => _fetchItemsWithSearch(),
      onChanged: (value) {
        widget.onChanged(value);

        widget.onChangedClearError?.call();
      },
      isRequired: widget.isRequired,
      apiDisplayValue: _displayValue,
      readOnly: widget.readOnly,
      showError: widget.showError,
      onDisplayValueUpdate: (newDisplayValue) {
        setState(() {
          _displayValue = newDisplayValue;
        });
      },
      searchController: _searchController,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CustomDropdownModal extends StatefulWidget {
  final List<DropdownItem> items;
  final String? selectedValue;
  final String label;
  final TextEditingController searchController;
  final Future<List<DropdownItem>> Function()? onSearchChanged;
  final bool allowDeselection; // Added this parameter

  const CustomDropdownModal({
    Key? key,
    required this.items,
    this.selectedValue,
    required this.label,
    required this.searchController,
    this.onSearchChanged,
    this.allowDeselection = false, // Default to false
  }) : super(key: key);

  @override
  _CustomDropdownModalState createState() => _CustomDropdownModalState();
}

class _CustomDropdownModalState extends State<CustomDropdownModal> {
  late List<DropdownItem> _filteredItems;
  late List<DropdownItem> _originalItems;
  late TextEditingController _searchController;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _originalItems = widget.items;
    _filteredItems = widget.items;
    _searchController = widget.searchController;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() async {
    final query = _searchController.text.toLowerCase();

    if (widget.onSearchChanged != null && query.isNotEmpty) {
      final newItems = await widget.onSearchChanged!();
      setState(() => _filteredItems = newItems);
    } else {
      setState(() {
        _filteredItems = query.isEmpty
            ? _originalItems
            : _originalItems.where((item) {
                return item.code.toLowerCase().contains(query) ||
                    item.description.toLowerCase().contains(query);
              }).toList();
      });
    }
  }

  bool _isItemSelected(DropdownItem item) {
    if (widget.selectedValue == null) return false;
    final selectedCode = widget.selectedValue?.split(' - ').first;
    return item.code == selectedCode;
  }

  void _handleItemTap(DropdownItem item) {
    final isSelected = _isItemSelected(item);

    // If item is already selected and deselection is allowed, return null
    if (isSelected && widget.allowDeselection) {
      Navigator.of(context).pop(null);
    } else {
      // Otherwise return the selected value
      Navigator.of(context).pop("${item.code} - ${item.description}");
    }
  }

  void _clearSelection() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.primary,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select ${widget.label}",
                style: getBoldStyle(
                    fontSize: FontSize.s18, color: ColorManager.darkBlue),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search
          CustomSearchField(
            controller: _searchController,
            placeholderText: "search ${widget.label}",
            inputType: TextInputType.text,
            autoFocus: true,
          ),
          const SizedBox(height: 16),

          // // Clear selection button (only show when allowDeselection is true and there's a selection)
          // if (widget.allowDeselection && widget.selectedValue != null)
          //   Column(
          //     children: [
          //       SizedBox(
          //         width: double.infinity,
          //         child: TextButton(
          //           onPressed: _clearSelection,
          //           style: TextButton.styleFrom(
          //             backgroundColor: ColorManager.lightGrey,
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //           ),
          //           child: Text(
          //             "Clear Selection",
          //             style: getMediumStyle(
          //               fontSize: FontSize.s14,
          //               color: ColorManager.darkBlue,
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(height: 16),
          //     ],
          //   ),

          Row(
            children: [
              Text(
                "Results: ${_filteredItems.length}",
                style:
                    TextStyle(fontSize: FontSize.s12, color: ColorManager.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // LIST + SCROLLBAR
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Text(
                      "No results found",
                      style: getRegularStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.grey,
                      ),
                    ),
                  )
                : ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(ColorManager.blue),
                      thickness: MaterialStateProperty.all(4),
                      radius: const Radius.circular(12),
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final isSelected = _isItemSelected(item);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: isSelected
                                ? ColorManager.highlightColor
                                : Colors.white,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.code,
                                    style: getSemiBoldStyle(
                                        fontSize: FontSize.s16,
                                        color: ColorManager.black),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.description,
                                    style: getRegularStyle(
                                        fontSize: FontSize.s14,
                                        color: ColorManager.darkGrey),
                                  ),
                                ],
                              ),
                              trailing: isSelected
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          color: ColorManager.darkBlue,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.check,
                                          size: 16, color: Colors.white),
                                    )
                                  : null,
                              onTap: () => _handleItemTap(item),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _scrollController.dispose();
    super.dispose();
  }
}
