import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:eyvo_inventory/presentation/image_upload/image_upload_helper.dart';
import 'package:flutter/material.dart';

// Future<void> showImageUploadDialog(BuildContext context) {
//   return showDialog(
//     context: context,
//     barrierDismissible: false, // prevent closing on outside tap
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         insetPadding: const EdgeInsets.all(16),
//         backgroundColor: ColorManager.primary,
//         child: _ImageUploadPopup(),
//       );
//     },
//   );
// }
Future<Map<String, String>?> showImageUploadDialog(BuildContext context) {
  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: ColorManager.white,
        child: _ImageUploadPopup(),
      );
    },
  );
}

class _ImageUploadPopup extends StatefulWidget {
  @override
  State<_ImageUploadPopup> createState() => _ImageUploadPopupState();
}

class _ImageUploadPopupState extends State<_ImageUploadPopup> {
  File? _selectedImage;
  bool _isUploading = false;
  String? _base64Image;

  final ImageHelper _imageHelper = ImageHelper();

  Future<void> _pickImage() async {
    final pickedFile = await _imageHelper.pickImageWithChoice(context: context);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  // Future<void> _uploadImage() async {
  //   if (_selectedImage == null) return;

  //   setState(() => _isUploading = true);

  //   try {
  //     String fileName = _selectedImage!.path.split('/').last;
  //     final bytes = await _selectedImage!.readAsBytes();
  //     _base64Image = base64Encode(bytes);

  //     LoggerData.dataLog("IMAGE NAME: $fileName");
  //     LoggerData.dataLog("BASE64 STRING: $_base64Image");

  //     // Show success
  //     Navigator.of(context).pop(); // close popup
  //     showImageActionDialog(
  //       context: context,
  //       imageString: ImageAssets.successfulIcon,
  //       titleString: '',
  //       messageString: "Image uploaded successfully",
  //       isNeedToPopBack: false,
  //       onNormalActionTap: () {},
  //     );
  //   } catch (e) {
  //     LoggerData.dataLog("Error converting image: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: $e")),
  //     );
  //   } finally {
  //     setState(() => _isUploading = false);
  //   }
  // }
  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      String fileName = _selectedImage!.path.split('/').last;
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      LoggerData.dataLog("IMAGE NAME: $fileName");

      // Close dialog and return the base64
      Navigator.of(context).pop({
        "fileName": fileName,
        "base64": base64Image,
      });
    } catch (e) {
      LoggerData.dataLog("Error converting image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const SizedBox(height: 8),

          // Asset image with increased size
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              ImageAssets.uploadImage,
              height: 150, // increased from 150
              width: 150, // increased from 150
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),

          // Title text again below image
          Text(
            "Upload Image",
            style: TextStyle(
              color: ColorManager.darkBlue,
              fontSize: FontSize.s20,
              fontWeight: FontWeightManager.bold,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.80, // take full width
            height: MediaQuery.of(context).size.height *
                0.25, // 25% of screen height

            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: [6, 3],
              color: ColorManager.lightGrey1,
              strokeWidth: 1,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // center vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // center horizontally
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: _selectedImage == null
                          ? Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                ImageAssets.uploadIcon,
                                height: 60,
                                width: 60,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _selectedImage!,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImage = null;
                                        _base64Image = null;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorManager.lightGrey,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(Icons.close,
                                          color: ColorManager.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Click to upload",
                      style: TextStyle(
                        color: ColorManager.darkBlue,
                        fontSize: FontSize.s16,
                        fontWeight: FontWeightManager.medium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "SVG, JPG, PNG (Max 50MB)",
                      style: TextStyle(
                        color: ColorManager.darkBlue,
                        fontWeight: FontWeightManager.regular,
                        fontSize: FontSize.s14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          const SizedBox(height: 20),

          // Upload Button

          SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.80, // 80% of screen width
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.darkBlue,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: (_isUploading || _selectedImage == null)
                  ? null
                  : _uploadImage,
              icon: _isUploading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CustomProgressIndicator(),
                    )
                  : Icon(Icons.file_upload_outlined, color: ColorManager.white),
              label: Text(
                _isUploading ? "Uploading..." : "Upload",
                style: TextStyle(color: ColorManager.white, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: ColorManager.white)),
          ),
        ],
      ),
    );
  }
}
