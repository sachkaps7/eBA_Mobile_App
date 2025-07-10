import 'package:flutter/material.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';

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

  static Widget buildEmptyView(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageAssets.noRecordFoundIcon,
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

  static Widget buildSection(
    String title,
    IconData icon,
    List<Widget> children, {
    VoidCallback? onTap,
    int? count,
    double iconSize = 24,
    required bool isExpanded,
    required VoidCallback toggleSection,
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
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Divider(
                color: ColorManager.lightGrey4,
                thickness: 1,
                height: 0,
              ),
            ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }

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
                    const Text(":", style: TextStyle(fontSize: FontSize.s16)),
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
                              fontSize: 14,
                              color: ColorManager.darkGrey,
                            ),
                          ),
                        ),
                        const Text(":", style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Text(
                            e.value.toString(),
                            style: TextStyle(
                              fontSize: 14,
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
                  const Text(":", style: TextStyle(fontSize: FontSize.s16)),
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
                      const Text(":", style: TextStyle(fontSize: FontSize.s16)),
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
}
