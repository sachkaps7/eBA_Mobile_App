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
