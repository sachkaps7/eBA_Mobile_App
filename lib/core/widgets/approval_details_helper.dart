import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';

class ApprovalDetailsHelper {
  static List<Widget> buildKeyValueSection(Map<dynamic, dynamic> map) {
    double maxKeyLength = map.keys
        .map((k) => k.toString().length)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return map.entries.map((e) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: maxKeyLength * 9,
              child: Text(
                e.key.toString(),
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
            Expanded(
              child: Text(
                e.value?.toString() ?? "",
                style: TextStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.darkGrey,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  static List<Widget> buildKeyValueSectionforAttachment(
    Map<dynamic, dynamic> map, {
    VoidCallback? onFileTap,
  }) {
    double maxKeyLength = map.keys
        .map((k) => k.toString().length)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return map.entries.map((e) {
      bool isFileNameField = e.key.toString().toLowerCase() == "file name";

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: maxKeyLength * 9,
              child: Text(
                e.key.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Text(" : ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: isFileNameField
                  ? InkWell(
                      onTap: onFileTap,
                      child: Text(
                        e.value.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorManager.darkBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(
                      e.value.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      );
    }).toList();
  }

//-----------------------------------buildMiniCard----------------------------------------------------------
  static Widget buildMiniCard(Map<dynamic, dynamic> data,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        color: ColorManager.white,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: buildKeyValueSection(data)),
        ),
      ),
    );
  }

  static Widget buildMiniCard1(
    Map<dynamic, dynamic> data, {
    VoidCallback? onTap,
    bool showDelete = false,
    VoidCallback? onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        color: ColorManager.white,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: buildKeyValueSection(data))),

              // ---------- DELETE ICON ----------
              if (showDelete)
                InkWell(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete,
                    color: ColorManager.red,
                    size: 26,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildMiniCardForAttachment(
    Map<dynamic, dynamic> data, {
    VoidCallback? onTap,
    bool showDelete = false,
    VoidCallback? onDelete,
    VoidCallback? onFileTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        color: ColorManager.white,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: buildKeyValueSectionforAttachment(
                    data,
                    onFileTap: onFileTap,
                  ),
                ),
              ),
              if (showDelete)
                InkWell(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete,
                    color: ColorManager.red,
                    size: 26,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

//-----------------------------------buildEmptyView----------------------------------------------------------
  static Widget buildEmptyView(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageAssets.emptyItem,
          height: 120,
          width: 120,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: TextStyle(
            color: ColorManager.darkGrey,
            fontSize: FontSize.s16,
          ),
        ),
      ],
    );
  }

//-----------------------------------buildSection----------------------------------------------------------
  static Widget buildSection(
    String title,
    IconData icon,
    List<Widget> children, {
    VoidCallback? onTap,
    int? count,
    double iconSize = 24,
    required bool isExpanded,
    required VoidCallback toggleSection,
    Widget? trailing,
    VoidCallback? onTrailingTap,
  }) {
    return Card(
      color: ColorManager.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              toggleSection();
              if (onTap != null) onTap();
            },
            borderRadius: BorderRadius.circular(8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              horizontalTitleGap: 8,
              leading: Icon(
                icon,
                size: iconSize,
                color:
                    isExpanded ? ColorManager.darkBlue : ColorManager.darkGrey,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: FontSize.s18,
                  fontWeight: FontWeight.w600,
                  color: isExpanded
                      ? ColorManager.darkBlue
                      : ColorManager.darkGrey,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Count badge
                  if (count != null && count > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorManager.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  // Expand/Collapse Arrow
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded
                        ? ColorManager.darkBlue
                        : ColorManager.darkGrey,
                  ),
                ],
              ),
            ),
          ),

          // Expand content
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Divider(
                color: ColorManager.lightGrey4,
                thickness: 1,
                height: 0,
              ),
            ),
          // const SizedBox(
          //   height: 20,
          // ),
          //  trailing icon at the at top

          if (isExpanded && trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 30),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: trailing,
                ),
              ),
            ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }

  static Widget buildTrailingButton({
    required IconData icon,
    required Color backgroundColor,
    double size = 40,
    double iconSize = 22,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }

//-----------------------------------buildMiniCardWithEditIcon----------------------------------------------------------
  static Widget buildMiniCardWithEditIcon(
      Map<String, dynamic> data, VoidCallback onTap) {
    final entries = data.entries.toList();
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: ColorManager.white,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              if (entries.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        entries[0].key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.s16,
                          color: ColorManager.darkGrey,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8), // Add horizontal spacing
                      child: Text(":",
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(
                      child: Text(
                        entries[0].value.toString(),
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.darkGrey,
                        ),
                      ),
                    ),
                    Icon(Icons.edit, size: 18, color: ColorManager.blue),
                  ],
                ),
              ...entries.skip(1).map((e) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            e.key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.s16,
                              color: ColorManager.darkGrey,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(":",
                              style: TextStyle(
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text(
                            e.value.toString(),
                            style: TextStyle(
                              fontSize: FontSize.s16,
                              color: ColorManager.darkGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

//-----------------------------------buildMiniCardForApproval----------------------------------------------------------
  static Widget buildMiniCardForApproval(
    Map<dynamic, dynamic> data,
    VoidCallback onIconTap, {
    bool Function(Map<dynamic, dynamic>)? showIconCondition,
  }) {
    final entries = data.entries.toList();
    final bool showIcon = showIconCondition?.call(data) ?? true;

    return Card(
      color: ColorManager.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (entries.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      entries[0].key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16,
                        color: ColorManager.darkGrey,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(":",
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Expanded(
                    child: Text(
                      entries[0].value.toString(),
                      style: TextStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.darkGrey,
                      ),
                    ),
                  ),
                  if (showIcon)
                    GestureDetector(
                      onTap: onIconTap,
                      child: Image.asset(
                        ImageAssets.detailsRule,
                        width: 25,
                        height: 25,
                        color: ColorManager.blue,
                      ),
                    ),
                ],
              ),
            ...entries.skip(1).map((e) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          e.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s16,
                            color: ColorManager.darkGrey,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8), // Add horizontal spacing
                        child: Text(":",
                            style: TextStyle(
                              fontSize: FontSize.s16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Expanded(
                        child: Text(
                          e.value.toString(),
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  static Widget buildMiniCardForApproval1(
    Map<dynamic, dynamic> data,
    VoidCallback onIconTap, {
    bool Function(Map<dynamic, dynamic>)? showIconCondition,
    bool showDelete = false,
    VoidCallback? onDelete,
  }) {
    final entries = data.entries.toList();
    final bool showIcon = showIconCondition?.call(data) ?? true;

    return Card(
      color: ColorManager.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (entries.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      entries[0].key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16,
                        color: ColorManager.darkGrey,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(":",
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Expanded(
                    child: Text(
                      entries[0].value.toString(),
                      style: TextStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.darkGrey,
                      ),
                    ),
                  ),

                  // Blue Info Icon
                  if (showIcon)
                    GestureDetector(
                      onTap: onIconTap,
                      child: Image.asset(
                        ImageAssets.detailsRule,
                        width: 25,
                        height: 25,
                        color: ColorManager.blue,
                      ),
                    ),

                  const SizedBox(width: 10),

                  //  Delete Icon
                  if (showDelete)
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(
                        Icons.delete,
                        color: ColorManager.red,
                        size: 26,
                      ),
                    ),
                ],
              ),

            // Remaining fields
            ...entries.skip(1).map((e) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          e.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s16,
                            color: ColorManager.darkGrey,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(":",
                            style: TextStyle(
                              fontSize: FontSize.s16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Expanded(
                        child: Text(
                          e.value.toString(),
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

//-----------------------------------buildSectionForDetails----------------------------------------------------------
  static Widget buildSectionForDetails(
    String title,
    IconData icon,
    Map<dynamic, dynamic>? infoMap, {
    VoidCallback? onTap,
    required bool isExpanded,
    required VoidCallback toggleSection,
  }) {
    final entries = infoMap?.entries.toList() ?? [];

    return Card(
      color: ColorManager.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: toggleSection,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              horizontalTitleGap: 8,
              leading: Icon(
                icon,
                color:
                    isExpanded ? ColorManager.darkBlue : ColorManager.darkGrey,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: FontSize.s18,
                  fontWeight: FontWeight.w600,
                  color: isExpanded
                      ? ColorManager.darkBlue
                      : ColorManager.darkGrey,
                ),
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color:
                    isExpanded ? ColorManager.darkBlue : ColorManager.darkGrey,
              ),
            ),
          ),
          if (isExpanded && infoMap != null)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: ApprovalDetailsHelper.buildKeyValueSection(infoMap),
                ),
              ),
            ),
        ],
      ),
    );
  }

//-----------------------------------------buildSectionForDetailsWithEditIcon-------------------------------------------------
  static Widget buildSectionForDetailsWithEditIcon(
    String title,
    IconData icon,
    Map<dynamic, dynamic>? infoMap, {
    VoidCallback? onTap,
    required bool isExpanded,
    required VoidCallback toggleSection,
  }) {
    final entries = infoMap?.entries.toList() ?? [];

    return Card(
      color: ColorManager.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: toggleSection,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              horizontalTitleGap: 8,
              leading: Icon(
                icon,
                color:
                    isExpanded ? ColorManager.darkBlue : ColorManager.darkGrey,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: FontSize.s18,
                  fontWeight: FontWeight.w600,
                  color: isExpanded
                      ? ColorManager.darkBlue
                      : ColorManager.darkGrey,
                ),
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color:
                    isExpanded ? ColorManager.darkBlue : ColorManager.darkGrey,
              ),
            ),
          ),
          if (isExpanded && entries.isNotEmpty)
            InkWell(
              onTap: onTap, // <---- Entire expanded area is now clickable
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    // ---------- FIRST ROW WITH EDIT ICON ----------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            entries[0].key.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.s16,
                              color: ColorManager.darkGrey,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontSize: FontSize.s16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entries[0].value.toString(),
                            style: TextStyle(
                              fontSize: FontSize.s16,
                              color: ColorManager.darkGrey,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onTap,
                          child: Icon(Icons.edit,
                              size: 18, color: ColorManager.blue),
                        ),
                      ],
                    ),

                    // ---------- OTHER ROWS ----------
                    ...entries.skip(1).map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    e.key.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: FontSize.s16,
                                      color: ColorManager.darkGrey,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                      fontSize: FontSize.s16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    e.value.toString(),
                                    style: TextStyle(
                                      fontSize: FontSize.s16,
                                      color: ColorManager.darkGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

//-----------------------------------buildNetGrossTotalWidget----------------------------------------------------------
  static Widget buildNetGrossTotalWidget(
    BuildContext context,
    List<dynamic> lineItems, {
    String? dialogTitle,
    String? netTotalLabel,
    String? salesTaxLabel,
    String? shippingChargesLabel,
    String? grossTotalLabel,
    String? currencyLabel,
  }) {
    double orderNetTotal =
        lineItems.fold(0.0, (sum, item) => sum + item.netPrice);
    double salesTaxTotal =
        lineItems.fold(0.0, (sum, item) => sum + item.taxValue);
    double shippingChargesTotal = 0.0;
    if (shippingChargesLabel != null) {
      shippingChargesTotal = lineItems.fold(0.0, (sum, item) {
        // Check if item has the property
        try {
          return sum + (item.shippingCharges ?? 0.0);
        } catch (e) {
          return sum;
        }
      });
    }

    double GrossTotal = orderNetTotal + salesTaxTotal;
    String currency =
        lineItems.isNotEmpty ? lineItems.first.supplierCcyCode : '';
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Widget buildRow(String label, String value,
        {bool isBold = false, Color? color}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label part
            Expanded(
              flex: 4,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: FontSize.s16,
                  color: color ?? ColorManager.darkGrey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Text(
              " : ",
              style: TextStyle(
                fontSize: FontSize.s16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Value part
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: FontSize.s16,
                  color: color ?? ColorManager.darkGrey,
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Stack(
                    children: [
                      // Dialog positioned in the center
                      Positioned(
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: ColorManager.white,
                          child: Container(
                            width: screenWidth * 0.9,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    dialogTitle ?? 'Title',
                                    style: getSemiBoldStyle(
                                      color: ColorManager.darkBlue,
                                      fontSize: FontSize.s18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                buildRow(
                                  netTotalLabel ?? 'Net Total',
                                  getFormattedPriceString(orderNetTotal),
                                ),
                                buildRow(
                                  salesTaxLabel ?? 'Sales Tax',
                                  salesTaxTotal.toStringAsFixed(3),
                                ),
                                //  Only show shipping charges if label is provided
                                if (shippingChargesLabel != null)
                                  buildRow(
                                    shippingChargesLabel,
                                    getFormattedPriceString(
                                        shippingChargesTotal),
                                  ),
                                buildRow(
                                  currencyLabel ?? 'Currency',
                                  currency,
                                  color: ColorManager.darkGrey,
                                ),
                                const Divider(height: 20, thickness: 1),
                                buildRow(
                                  grossTotalLabel ?? 'Gross Total',
                                  getFormattedPriceString(GrossTotal),
                                  isBold: true,
                                  color: ColorManager.darkBlue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Close icon positioned above the dialog
                      Positioned(
                        top: screenHeight * 0.27,
                        right: screenWidth * 0.075,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.darkGrey,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              color: ColorManager.darkGrey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
              child: Text(
                '${netTotalLabel ?? 'Order Net Total'}: ${getFormattedPriceString(orderNetTotal)} ($currency)',
                style: getSemiBoldStyle(
                  color: ColorManager.darkBlue,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
