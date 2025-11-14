import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class ErrorTextViewBox extends StatelessWidget {
  final String iconString;
  final String titleString;
  const ErrorTextViewBox(
      {super.key,
      this.iconString = ImageAssets.errorIcon,
      this.titleString = AppStrings.requiresValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: titleString.length >= 25
          ? 60
          : titleString.length >= 15
              ? 50
              : 40,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: ColorManager.lightRed,
          border: Border.all(color: ColorManager.lightRed2),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage(iconString), width: 20, height: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: titleString.length >= 25 ? 3 : 2,
              titleString,
              style: getRegularStyle(
                  color: ColorManager.red, fontSize: FontSize.s14),
            ),
          )
        ],
      ),
    );
  }
}
// import 'package:eyvo_v3/core/resources/assets_manager.dart';
// import 'package:eyvo_v3/core/resources/color_manager.dart';
// import 'package:eyvo_v3/core/resources/font_manager.dart';
// import 'package:eyvo_v3/core/resources/strings_manager.dart';
// import 'package:eyvo_v3/core/resources/styles_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ErrorTextViewBox extends StatelessWidget {
//   final String iconString;
//   final String titleString;

//   const ErrorTextViewBox({
//     super.key,
//     this.iconString = ImageAssets.errorIcon,
//     this.titleString = AppStrings.requiresValue,
//   });

//   Future<void> _onOpenLink(LinkableElement link) async {
//     final url = link.url;

//     // Handle email links
//     if (url.startsWith('mailto:')) {
//       final uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         // Fallback: try to launch as string
//         await launchUrl(Uri.parse('mailto:${url.replaceFirst('mailto:', '')}'));
//       }
//     }
//     // Handle regular URLs
//     else {
//       final uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       }
//     }
//   }

//   String _stripHtmlTags(String html) {
//     return html
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll('mailto:', '')
//         .trim();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cleanedText = _stripHtmlTags(titleString);

//     return Container(
//       height: titleString.length >= 25
//           ? 60
//           : titleString.length >= 15
//               ? 50
//               : 40,
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: ColorManager.lightRed,
//         border: Border.all(color: ColorManager.lightRed2),
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image(image: AssetImage(iconString), width: 20, height: 20),
//           const SizedBox(width: 10),
//           Expanded(
//             child: SelectableLinkify(
//               text: cleanedText,
//               onOpen: _onOpenLink,
//               options: const LinkifyOptions(looseUrl: true),
//               style: getRegularStyle(
//                 color: ColorManager.red,
//                 fontSize: FontSize.s14,
//               ),
//               linkStyle: const TextStyle(
//                 color: Colors.blue,
//                 decoration: TextDecoration.underline,
//               ),
//               maxLines: 3,
//               //overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:eyvo_v3/core/resources/assets_manager.dart';
// import 'package:eyvo_v3/core/resources/color_manager.dart';
// import 'package:eyvo_v3/core/resources/font_manager.dart';
// import 'package:eyvo_v3/core/resources/strings_manager.dart';
// import 'package:eyvo_v3/core/resources/styles_manager.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:linkify/linkify.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ErrorTextViewBox extends StatelessWidget {
//   final String iconString;
//   final String titleString;

//   const ErrorTextViewBox({
//     super.key,
//     this.iconString = ImageAssets.errorIcon,
//     this.titleString = AppStrings.requiresValue,
//   });

//   String _stripHtmlTags(String html) {
//     return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
//   }

//   Future<void> _onOpen(LinkifyElement link) async {
//     if (link is UrlElement) {
//       final uri = Uri.parse(link.url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       }
//     } else if (link is EmailElement) {
//       final uri = Uri.parse('mailto:${link.emailAddress}');
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cleanedText = _stripHtmlTags(titleString);
//     final linkified =
//         linkify(cleanedText, options: const LinkifyOptions(humanize: false));

//     return Container(
//       height: titleString.length >= 25
//           ? 60
//           : titleString.length >= 15
//               ? 50
//               : 40,
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: ColorManager.lightRed,
//         border: Border.all(color: ColorManager.lightRed2),
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image(image: AssetImage(iconString), width: 20, height: 20),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _buildLinkifiedText(linkified),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLinkifiedText(List<LinkifyElement> elements) {
//     final textSpans = <TextSpan>[];

//     for (final element in elements) {
//       if (element is TextElement) {
//         textSpans.add(
//           TextSpan(
//             text: element.text,
//             style: getRegularStyle(
//                 color: ColorManager.red, fontSize: FontSize.s14),
//           ),
//         );
//       } else if (element is UrlElement) {
//         textSpans.add(
//           TextSpan(
//             text: element.text,
//             style: getRegularStyle(color: Colors.blue, fontSize: FontSize.s14)
//                 .copyWith(decoration: TextDecoration.underline),
//             recognizer: TapGestureRecognizer()..onTap = () => _onOpen(element),
//           ),
//         );
//       } else if (element is EmailElement) {
//         textSpans.add(
//           TextSpan(
//             text: element.text,
//             style: getRegularStyle(color: Colors.blue, fontSize: FontSize.s14)
//                 .copyWith(decoration: TextDecoration.underline),
//             recognizer: TapGestureRecognizer()..onTap = () => _onOpen(element),
//           ),
//         );
//       }
//     }

//     return SelectableText.rich(
//       TextSpan(children: textSpans),
//       maxLines: 3,
//     );
//   }
// }
