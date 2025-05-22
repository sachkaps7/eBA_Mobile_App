import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:flutter/material.dart';

class OrderItemListTile extends StatefulWidget {
  final int itemID;
  final String title;
  final String subtitle;
  final String imageString;
  final double totalQuantity;
  final double receivedQuantity;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const OrderItemListTile(
      {super.key,
      required this.itemID,
      required this.title,
      required this.subtitle,
      required this.imageString,
      required this.totalQuantity,
      required this.receivedQuantity,
      required this.isSelected,
      required this.onTap,
      required this.onEdit});

  @override
  State<OrderItemListTile> createState() => _OrderItemListTileState();
}

class _OrderItemListTileState extends State<OrderItemListTile> {
  late double selectedQuantity;

  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.receivedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card(
          color: widget.isSelected ? ColorManager.darkBlue : ColorManager.white,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text('${AppStrings.itemIDDetails}${widget.itemID}',
                            maxLines: 1,
                            style: getSemiBoldStyle(
                                color: widget.isSelected
                                    ? ColorManager.white
                                    : ColorManager.lightGrey1,
                                fontSize: FontSize.s12)),
                        const SizedBox(height: 4),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: ColorManager.white,
                              border: Border.all(
                                  color: ColorManager.grey4, width: 1.0),
                              borderRadius: BorderRadius.circular(6)),
                          child: Image.network(
                            widget.imageString,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title.isNotEmpty)
                            Text(widget.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: getBoldStyle(
                                    color: widget.isSelected
                                        ? ColorManager.white
                                        : ColorManager.darkBlue,
                                    fontSize: FontSize.s14)),
                          Text(widget.subtitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: widget.title.isEmpty ? 3 : 2,
                              style: getRegularStyle(
                                  color: widget.isSelected
                                      ? ColorManager.white
                                      : ColorManager.lightGrey2,
                                  fontSize: FontSize.s14))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppStrings.quantityDetail}${getFormattedString(widget.totalQuantity)}',
                      style: getBoldStyle(
                          color: widget.isSelected
                              ? ColorManager.white
                              : ColorManager.lightGrey2,
                          fontSize: FontSize.s17),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 52,
                          child: GestureDetector(
                            onTap: widget.onEdit,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                  color: widget.isSelected
                                      ? ColorManager.white
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: ColorManager.grey4, width: 1.0),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getFormattedString(widget.receivedQuantity),
                                    style: getSemiBoldStyle(
                                        color: ColorManager.lightGrey1,
                                        fontSize: FontSize.s17),
                                  ),
                                  SizedBox(
                                    height: 12,
                                    width: 13,
                                    child: Image.asset(ImageAssets.dropDownIcon,
                                        height: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 5),
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(AppStrings.receiveQuantity,
                                style: getSemiBoldStyle(
                                    color: ColorManager.lightGrey1,
                                    fontSize: FontSize.s12)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItemListTile extends StatelessWidget {
  final String title;
  final String imageString;
  final VoidCallback onTap;

  const MenuItemListTile({
    super.key,
    required this.title,
    required this.imageString,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        width: displayWidth(context),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 12,
              width: 16,
              child: Image.asset(imageString),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: getRegularStyle(
                color: ColorManager.lightGrey1,
                fontSize: FontSize.s16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String imageString;

  const ItemListTile({
    super.key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.imageString,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: displayWidth(context),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // key change
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: ColorManager.white,
              border: Border.all(color: ColorManager.grey4, width: 1.0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              imageString,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // vertically center the text
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getBoldStyle(
                    color: ColorManager.darkBlue,
                    fontSize: FontSize.s14,
                  ),
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    text: AppStrings.itemCodeDetails,
                    style: getSemiBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                    ),
                    children: [
                      TextSpan(
                        text: subtitle1,
                        style: getRegularStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    text: AppStrings.categoryCodeDetails,
                    style: getSemiBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                    ),
                    children: [
                      TextSpan(
                        text: subtitle2,
                        style: getRegularStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    text: AppStrings.stockDetails,
                    style: getSemiBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                    ),
                    children: [
                      TextSpan(
                        text: subtitle3,
                        style: getRegularStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemGridTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String imageString;

  const ItemGridTile({
    super.key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.imageString,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        // <== ADD THIS
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorManager.white,
                border: Border.all(color: ColorManager.grey4, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.network(
                  imageString,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // REMOVE Expanded or Flexible
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: getBoldStyle(
                color: ColorManager.darkBlue,
                fontSize: FontSize.s14,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: AppStrings.itemCodeDetails,
                style: getSemiBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s12,
                ),
                children: [
                  TextSpan(
                    text: subtitle1,
                    style: getRegularStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: AppStrings.categoryCodeDetails,
                style: getSemiBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s12,
                ),
                children: [
                  TextSpan(
                    text: subtitle2,
                    style: getRegularStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                text: AppStrings.stockDetails,
                style: getSemiBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s12,
                ),
                children: [
                  TextSpan(
                    text: subtitle3,
                    style: getRegularStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class ItemGridTile extends StatelessWidget {
//   final String title;
//   final String subtitle1;
//   final String subtitle2;
//   final String subtitle3;
//   final String imageString;

//   const ItemGridTile(
//       {super.key,
//       required this.title,
//       required this.subtitle1,
//       required this.subtitle2,
//       required this.subtitle3,
//       required this.imageString});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 440,
//       decoration: BoxDecoration(
//           color: ColorManager.white, borderRadius: BorderRadius.circular(8)),
//       padding: const EdgeInsets.all(18.0),
//       child: IntrinsicHeight(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 100,
//               width: double.infinity,
//               child: Image.network(
//                 imageString,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(title,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//                 style: getBoldStyle(
//                     color: ColorManager.darkBlue, fontSize: FontSize.s14)),
//             RichText(
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               text: TextSpan(
//                 text: AppStrings.itemCodeDetails,
//                 style: getSemiBoldStyle(
//                     color: ColorManager.black, fontSize: FontSize.s12),
//                 children: [
//                   TextSpan(
//                       text: subtitle1,
//                       style: getRegularStyle(
//                           color: ColorManager.black, fontSize: FontSize.s12))
//                 ],
//               ),
//             ),
//             RichText(
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               text: TextSpan(
//                 text: AppStrings.categoryCodeDetails,
//                 style: getSemiBoldStyle(
//                     color: ColorManager.black, fontSize: FontSize.s12),
//                 children: [
//                   TextSpan(
//                       text: subtitle2,
//                       style: getRegularStyle(
//                           color: ColorManager.black, fontSize: FontSize.s12))
//                 ],
//               ),
//             ),
//             RichText(
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               text: TextSpan(
//                 text: AppStrings.stockDetails,
//                 style: getSemiBoldStyle(
//                     color: ColorManager.black, fontSize: FontSize.s12),
//                 children: [
//                   TextSpan(
//                       text: subtitle3,
//                       style: getRegularStyle(
//                           color: ColorManager.black, fontSize: FontSize.s12))
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
