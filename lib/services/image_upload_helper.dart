import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageHelper {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from camera and keep original extension
  Future<File?> pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final originalFile = File(photo.path);

      // Get original extension (.jpg, .png, .heic, etc.)
      final ext = path.extension(photo.path);

      // Custom filename with original extension
      final newFileName =
          "CameraImage_${DateTime.now().millisecondsSinceEpoch}$ext";

      // Save in same directory
      final newPath = '${originalFile.parent.path}/$newFileName';
      final newFile = await originalFile.copy(newPath);

      return newFile;
    }
    return null;
  }

  /// Pick image from gallery and keep original extension
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final originalFile = File(image.path);

      // Get original extension
      final ext = path.extension(image.path);

      final newFileName =
          "GalleryImage_${DateTime.now().millisecondsSinceEpoch}$ext";

      final newPath = '${originalFile.parent.path}/$newFileName';
      final newFile = await originalFile.copy(newPath);

      return newFile;
    }
    return null;
  }

  /// Show bottom sheet for choice
  Future<File?> pickImageWithChoice({required BuildContext context}) async {
    return await showModalBottomSheet<File>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Option",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // CAMERA
              _buildOption(
                icon: Icons.camera_alt,
                label: "Take Photo",
                onTap: () async {
                  final file = await pickImageFromCamera();
                  Navigator.pop(sheetContext, file);
                },
              ),

              // GALLERY
              _buildOption(
                icon: Icons.photo,
                label: "Choose Image from Gallery",
                onTap: () async {
                  final file = await pickImageFromGallery();
                  Navigator.pop(sheetContext, file); 
                }
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
