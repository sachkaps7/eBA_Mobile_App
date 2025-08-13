import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:flutter/material.dart';

class CustomImageActionAlert extends StatefulWidget {
  final String iconString;
  final String imageString;
  final String titleString;
  final String subTitleString;
  final String destructiveActionString;
  final String normalActionString;
  final VoidCallback onDestructiveActionTap;
  final VoidCallback onNormalActionTap;
  final bool isNormalAlert;
  final bool isConfirmationAlert;
  const CustomImageActionAlert(
      {super.key,
      required this.iconString,
      required this.imageString,
      required this.titleString,
      required this.subTitleString,
      required this.destructiveActionString,
      required this.normalActionString,
      required this.onDestructiveActionTap,
      required this.onNormalActionTap,
      this.isNormalAlert = false,
      this.isConfirmationAlert = false});

  @override
  State<CustomImageActionAlert> createState() => _CustomImageActionAlertState();
}

class _CustomImageActionAlertState extends State<CustomImageActionAlert> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          AlertDialog(
            backgroundColor: ColorManager.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            content: SizedBox(
              width: displayWidth(context) - 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage(widget.imageString)),
                  CenterTitleHeader(
                      titleText: widget.titleString,
                      detailText: widget.subTitleString),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.normalActionString.isNotEmpty)
                          Expanded(
                            child: CustomTextActionButton(
                              backgroundColor: widget.isNormalAlert
                                  ? widget.isConfirmationAlert
                                      ? ColorManager.white
                                      : ColorManager.green
                                  : Colors.transparent,
                              fontColor: widget.isNormalAlert
                                  ? widget.isConfirmationAlert
                                      ? ColorManager.darkRed
                                      : ColorManager.white
                                  : ColorManager.lightGrey1,
                              borderColor: widget.isConfirmationAlert
                                  ? ColorManager.darkRed
                                  : ColorManager.lightGrey1,
                              buttonText: widget.normalActionString,
                              onTap: widget.onNormalActionTap,
                            ),
                          ),
                        if (widget.normalActionString.isNotEmpty &&
                            widget.destructiveActionString.isNotEmpty)
                          const SizedBox(width: 10),
                        if (widget.destructiveActionString.isNotEmpty)
                          Expanded(
                            child: CustomTextActionButton(
                              buttonText: widget.destructiveActionString,
                              backgroundColor: widget.isNormalAlert
                                  ? widget.isConfirmationAlert
                                      ? ColorManager.green
                                      : ColorManager.white
                                  : ColorManager.green,
                              fontColor: widget.isNormalAlert
                                  ? widget.isConfirmationAlert
                                      ? ColorManager.white
                                      : ColorManager.green
                                  : ColorManager.white,
                              borderColor: widget.isNormalAlert
                                  ? widget.isConfirmationAlert
                                      ? ColorManager.lightGrey1
                                      : ColorManager.green
                                  : ColorManager.green,
                              onTap: widget.onDestructiveActionTap,
                            ),
                          ),
                      ],
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
}
