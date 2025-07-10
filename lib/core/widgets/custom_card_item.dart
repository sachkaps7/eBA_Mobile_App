import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomItemCard extends StatelessWidget {
  final String imageString;
  final String title;
  final Color backgroundColor;
  final double cornerRadius;
  final VoidCallback onTap;

  const CustomItemCard({
    super.key,
    required this.imageString,
    required this.title,
    required this.backgroundColor,
    required this.cornerRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (displayWidth(context) * 0.45), // reduced width
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        padding: const EdgeInsets.all(10.0), // reduced padding
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imageString,
                height: 40, // reduced image size
                width: 40,
              ),
              const SizedBox(height: 6.0), // reduced spacing
              Text(
                title,
                style: getSemiBoldStyle(
                  color: ColorManager.lightGrey1,
                  fontSize: FontSize.s14, // reduced font size
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomItemCardDashboard extends StatelessWidget {
  final String imageString;
  final String title;
  final Color backgroundColor;
  final double cornerRadius;
  final VoidCallback onTap;

  const CustomItemCardDashboard({
    super.key,
    required this.imageString,
    required this.title,
    required this.backgroundColor,
    required this.cornerRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: displayWidth(context) * 0.5,
        height: 160, // keep this fixed height
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // center everything
          children: [
            Image.asset(
              imageString,
              height: 60,
              width: 60,
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: getSemiBoldStyle(
                color: ColorManager.lightGrey1,
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // handle long text gracefully
            ),
          ],
        ),
      ),
    );
  }
}

class CustomItemCardWithEdit extends StatelessWidget {
  final String imageString;
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final Color backgroundColor;
  final double cornerRadius;
  final bool isEditable;

  const CustomItemCardWithEdit({
    super.key,
    required this.imageString,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.backgroundColor,
    required this.cornerRadius,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Stack(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(cornerRadius),
                  child: Image.asset(
                    imageString,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: getSemiBoldStyle(
                          color: ColorManager.lightGrey1,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: getRegularStyle(
                          color: ColorManager.lightGrey2,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            Positioned(
              top: 4.0,
              right: 4.0,
              child: IconButton(
                icon: Image.asset(
                  ImageAssets.editIcon,
                  width: 20,
                  height: 20,
                ),
                onPressed: onEdit,
              ),
            ),
        ],
      ),
    );
  }
}

class CommonCardWidget extends StatelessWidget {
  final List<Map<String, String>> subtitles;
  final VoidCallback? onTap;

  const CommonCardWidget({
    super.key,
    required this.subtitles,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FixedColumnWidth(24),
              2: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List.generate(subtitles.length, (index) {
              final item = subtitles[index];
              final label = item.keys.first;
              final value = item.values.first;

              final isOrderNo = label == 'Order No';

              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 4),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16,
                        color: ColorManager.darkGrey,
                      ),
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: FontSize.s16,
                        color: isOrderNo
                            ? ColorManager.blue
                            : ColorManager.darkGrey,
                        decoration: isOrderNo ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
