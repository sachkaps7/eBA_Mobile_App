// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageHelper {
//   final ImagePicker _picker = ImagePicker();

//   /// Pick image from camera
//   // Future<File?> pickImageFromCamera() async {
//   //   final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//   //   return photo != null ? File(photo.path) : null;
//   // }
//   /// Pick image from camera and rename it
//   Future<File?> pickImageFromCamera() async {
//     final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//     if (photo != null) {
//       final originalFile = File(photo.path);

//       // Custom filename (you can use timestamp or any pattern)
//       final newFileName =
//           "CameraImage_${DateTime.now().millisecondsSinceEpoch}.jpg";

//       // Save in the same directory or app-specific directory
//       final newPath = '${originalFile.parent.path}/$newFileName';
//       final newFile = await originalFile.copy(newPath);

//       return newFile;
//     }
//     return null;
//   }

//   /// Pick image from gallery
//   // Future<File?> pickImageFromGallery() async {
//   //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//   //   return image != null ? File(image.path) : null;
//   // }
//   // // Pick image from gallery and rename
//   // Future<Map<String, dynamic>?> pickImageFromGallery() async {
//   //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//   //   if (image != null) {
//   //     File file = File(image.path);

//   //     // Extract file name using path package
//   //     String fileName = path.basename(image.path);

//   //     return {
//   //       "file": file,
//   //       "fileName": fileName,
//   //     };
//   //   }
//   //   return null;
//   // }
//   Future<File?> pickImageFromGallery() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       final originalFile = File(image.path);

//       // Custom filename (same pattern as camera)
//       final newFileName =
//           "GalleryImage_${DateTime.now().millisecondsSinceEpoch}.jpg";

//       // Save in the same directory or app-specific directory
//       final newPath = '${originalFile.parent.path}/$newFileName';
//       final newFile = await originalFile.copy(newPath);

//       return newFile;
//     }
//     return null;
//   }

//   /// Show a dialog and let user choose Camera or Gallery
//   Future<File?> pickImageWithChoice({required context}) async {
//     return showModalBottomSheet<File?>(
//       context: context,
//       isScrollControlled: true, // allows height adjustment
//       builder: (_) {
//         final screenHeight = MediaQuery.of(context).size.height;
//         return Container(
//           height: screenHeight * 0.20, // 35% of screen height, adjust as needed
//           child: SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text("Take Photo"),
//                   onTap: () async {
//                     Navigator.pop(_, await pickImageFromCamera());
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text("Choose from Gallery"),
//                   onTap: () async {
//                     Navigator.pop(_, await pickImageFromGallery());
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
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
  Future<File?> pickImageWithChoice({required context}) async {
    return showModalBottomSheet<File?>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Container(
          height: screenHeight * 0.20,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take Photo"),
                  onTap: () async {
                    Navigator.pop(_, await pickImageFromCamera());
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from Gallery"),
                  onTap: () async {
                    Navigator.pop(_, await pickImageFromGallery());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
