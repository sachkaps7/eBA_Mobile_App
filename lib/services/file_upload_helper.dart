import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Show bottom sheet with 3 options
  static Future<File?> showFilePickerSheet(BuildContext context) async {
    return await showModalBottomSheet<File>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
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
              _buildOption(
                icon: Icons.camera_alt,
                label: "Take Photo",
                onTap: () async {
                  File? file = await pickImageFromCamera();
                  Navigator.pop(context, file);
                },
              ),
              _buildOption(
                icon: Icons.photo,
                label: "Choose Image from Gallery",
                onTap: () async {
                  File? file = await pickImageFromGallery();
                  Navigator.pop(context, file);
                },
              ),
              _buildOption(
                icon: Icons.insert_drive_file,
                label: "Choose File",
                onTap: () async {
                  File? file = await pickSingleFile();
                  Navigator.pop(context, file);
                },
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

  /// Pick any single file
  static Future<File?> pickSingleFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
  }

  /// Pick from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? picked =
          await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) return File(picked.path);
      return null;
    } catch (e) {
      print("Gallery error: $e");
      return null;
    }
  }

  /// Pick from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked != null) return File(picked.path);
      return null;
    } catch (e) {
      print("Camera error: $e");
      return null;
    }
  }
}
