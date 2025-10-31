import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: ColorManager.green,
        content: Text(content,
            style: getRegularStyle(
                color: ColorManager.white, fontSize: FontSize.s16)),
      ),
    );
}

void showAlertDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(AppStrings.ok,
                style: getBoldStyle(
                    color: ColorManager.black, fontSize: FontSize.s20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSuccessDialog(BuildContext context, String imageString,
    String titleString, String messageString, bool isNeedToPopBack) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomImageActionAlert(
          iconString: '',
          imageString: imageString,
          titleString: titleString,
          subTitleString: messageString,
          destructiveActionString: '',
          normalActionString: AppStrings.ok,
          onDestructiveActionTap: () {},
          onNormalActionTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          isNormalAlert: true);
    },
  );
}

void showErrorDialog(
    BuildContext context, String message, bool isNeedToPopBack) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomImageActionAlert(
          iconString: '',
          imageString: ImageAssets.errorMessageIcon,
          titleString: '',
          subTitleString: message,
          destructiveActionString: '',
          normalActionString: AppStrings.ok,
          onDestructiveActionTap: () {},
          onNormalActionTap: () {
            Navigator.pop(context);
            if (isNeedToPopBack) {
              Navigator.pop(context);
            }
          },
          isNormalAlert: true);
    },
  );
}

void showImageActionDialog({
  required BuildContext context,
  required String imageString,
  required String titleString,
  required String messageString,
  String destructiveActionString = '',
  String normalActionString = 'OK',
  VoidCallback? onDestructiveActionTap,
  VoidCallback? onNormalActionTap,
  bool isNeedToPopBack = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomImageActionAlert(
        iconString: '',
        imageString: imageString,
        titleString: titleString,
        subTitleString: messageString,
        destructiveActionString: destructiveActionString,
        normalActionString: normalActionString,
        onDestructiveActionTap: onDestructiveActionTap ?? () {},
        onNormalActionTap: () {
          Navigator.pop(context); // close dialog

          if (isNeedToPopBack) {
            Navigator.pop(context); // go back if needed
          }

          if (onNormalActionTap != null) {
            onNormalActionTap();
          }
        },
        isNormalAlert: true,
      );
    },
  );
}

//Returns the number as a string, properly formatted with commas and decimal points.
String getFormattedPriceString(double price) {
  var priceFormatter = NumberFormat.currency(
      locale: 'en_US', symbol: '', decimalDigits: SharedPrefs().decimalPlaces);
  String formattedPrice = priceFormatter.format(price);
  return formattedPrice;
}

//Converts a number directly to a string with a fixed number of decimal places
String getFormattedString(double number) {
  return number.toStringAsFixed(SharedPrefs().decimalPlaces);
}

// String getFormattedPriceStringPrice(double price) {
//   var priceFormatter = NumberFormat.currency(
//       locale: 'en_US',
//       symbol: '',
//       decimalDigits: SharedPrefs().decimalplacesprice);
//   String formattedPrice = priceFormatter.format(price);
//   return formattedPrice;
// }
String getFormattedPriceStringPrice(double price) {
  var priceFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: SharedPrefs().decimalplacesprice);
  String formattedPrice = priceFormatter.format(price);

  // Ensure at least two decimal places are retained
  if (formattedPrice.contains('.')) {
    formattedPrice =
        formattedPrice.replaceAll(RegExp(r'0+$'), ''); // Remove trailing zeroes

    // Ensure at least two decimal places remain
    int decimalIndex = formattedPrice.indexOf('.');
    if (decimalIndex != -1 && formattedPrice.length - decimalIndex - 1 < 2) {
      formattedPrice = formattedPrice.padRight(decimalIndex + 3, '0');
    }
  }

  return formattedPrice;
}

// String getFormattedStringPrice(double number) {
//   return number.toStringAsFixed(SharedPrefs().decimalplacesprice);
// }
String getFormattedStringPrice(double number) {
  String formatted = number.toStringAsFixed(SharedPrefs()
      .decimalplacesprice); // Convert to string with 5 decimal places

  if (formatted.contains('.')) {
    formatted =
        formatted.replaceAll(RegExp(r'0+$'), ''); // Remove trailing zeroes

    // Ensure at least two decimal places remain
    int decimalIndex = formatted.indexOf('.');
    if (decimalIndex != -1 && formatted.length - decimalIndex - 1 < 2) {
      formatted = formatted.padRight(decimalIndex + 3, '0');
    }
  }

  return formatted;
}

String getDefaultString(String formattedString) {
  return formattedString.replaceAll(',', '');
}

void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ),
  );
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;
  final double minValue;
  final double maxValue;

  DecimalTextInputFormatter({
    required this.decimalPlaces,
    required this.minValue,
    required this.maxValue,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Allow input that matches the regex pattern
    final regExp = RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$');
    if (regExp.hasMatch(text)) {
      // Parse the text to a double and check if it's within the range, only if it's a complete number
      final double? value = double.tryParse(text);
      if (value != null) {
        if (value >= minValue && value <= maxValue) {
          return newValue;
        } else if (newValue.text != '0.00' && value <= maxValue) {
          return newValue; // Allow intermediate inputs like "0" or "0."
        } else {
          return oldValue;
        }
      }
    }

    // If the input doesn't match the pattern or is out of range, keep the old value
    return oldValue;
  }
}

String capitalizeFirstLetter(String? text) {
  if (text == null || text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String getNormalizedStatus(String? status) {
  return (status != null && status.trim().isNotEmpty)
      ? status.trim().toUpperCase()
      : 'REJECTED';
}

Color getStatusColor(String? status) {
  switch (getNormalizedStatus(status)) {
    case 'UNISSUED':
      return const Color(0xFF09AF00);
    case 'ISSUED':
      return const Color(0xFF1976D2);
    case 'PARTIAL':
      return const Color(0xFF4DD0E1);
    case 'CLOSED':
      return const Color(0xFF8D6E63);
    case 'REJECTED':
      return const Color(0xFFC62809);
    case 'PENDING':
      return Colors.orange;
    case 'APPROVED':
      return const Color(0xFFAFB42B);
    case 'RECEIVED':
      return const Color(0xFFA07C03);
    case 'CANCELLED':
      return const Color(0xFFB0BEC5);
    default:
      return Colors.grey;
  }
}
