import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/note_details_response_model.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:eyvo_v3/services/file_upload_helper.dart';
import 'package:eyvo_v3/services/image_upload_helper.dart';
import 'package:flutter/material.dart';

enum UploadType { file, url }

class FileUploadPage extends StatefulWidget {
  final int ordReqID;
  final String group;
  const FileUploadPage({Key? key, required this.group, required this.ordReqID})
      : super(key: key);

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  final ApiService apiService = ApiService();
  final ImageHelper _imageHelper = ImageHelper();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();

  List<bool> _isCardSelected = [true, false];

  File? _selectedImage;
  String? _fileExtension;
  String? _fileSize;
  bool _isUploading = false;
  bool _isFileTooLarge = false;
  bool _isInvalidFormat = false;
  bool _isFileNameTooLong = false;
  bool _isDescriptionTooLong = false;
  String? _fileName;
  String? _base64File;

  //UploadType _selectedUploadType = UploadType.file;

  @override
  void initState() {
    super.initState();
    _itemDescriptionController.addListener(_validateDescription);
    LoggerData.dataLog('${widget.ordReqID}');
  }

  void _validateDescription() {
    setState(() {
      _isDescriptionTooLong =
          _itemDescriptionController.text.trim().length > 50;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _itemDescriptionController.dispose();
    super.dispose();
  }

  bool get _privacyValue {
    return _isCardSelected[0]; // true = Private, false = Public
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 KB";
    const int kb = 1000;
    const int mb = kb * 1000;
    if (bytes >= mb) return (bytes / mb).toStringAsFixed(decimals) + " MB";
    return (bytes / kb).toStringAsFixed(decimals) + " KB";
  }

  Future<void> _pickFile() async {
    File? pickedFile = await FilePickerHelper.showFilePickerSheet(context);

    if (pickedFile != null) {
      final bytes = await pickedFile.length();
      final ext = pickedFile.path.split('.').last.toLowerCase();
      final fileName = pickedFile.path.split('/').last;

      setState(() {
        _selectedImage = pickedFile;
        _fileExtension = ext;
        _fileSize = _formatBytes(bytes, 2);
        _fileName = fileName;

        _isFileTooLarge = false;
        _isInvalidFormat = false;
        _isFileNameTooLong = fileName.length > 50;

        if (AppConstants.allowedImageFormats.contains(ext)) {
          _isFileTooLarge = bytes > AppConstants.imageSizeLimitBytes;
        } else if (AppConstants.blockedExtensions.contains(ext)) {
          _isInvalidFormat = true;
        }
      });

      final fileBytes = await pickedFile.readAsBytes();
      _base64File = base64Encode(fileBytes);
    }
  }

  Widget _buildFileUploadUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ---- Upload Box ----
        FormFieldHelper.buildUploadBoxForFile(
          selectedFile: _selectedImage,
          onPickFile: _pickFile,
          onRemoveFile: () {
            setState(() {
              _selectedImage = null;
              _fileExtension = null;
              _fileSize = null;
              _isFileTooLarge = false;
              _isInvalidFormat = false;
              _isFileNameTooLong = false;
            });
          },
          isUploading: _isUploading,
        ),

        const SizedBox(height: 10),

        // ---- File Status (size, extension, errors,file name lenght) ----
        FormFieldHelper.buildFileStatusForFileUpload(
          isInvalidFormat: _isInvalidFormat,
          isFileTooLarge: _isFileTooLarge,
          isFileNameTooLong: _isFileNameTooLong,
          fileSize: _fileSize,
          fileExtension: _fileExtension,
        ),

        const SizedBox(height: 10),

        // ---- Description Text Box ----
        FormFieldHelper.buildMultilineTextField(
          label: "Item Description",
          controller: _itemDescriptionController,
          hintText: "Enter detailed item description",
          isRequired: true,
          showLengthError: _isDescriptionTooLong,
          errorMessage: "Description cannot exceed 50 characters.",
        ),

        const SizedBox(height: 10),

        // ---- File Privacy Cards ----
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'File Privacy',
            style: getSemiBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s14,
            ),
          ),
        ),
        const SizedBox(height: 5),
        FormFieldHelper.buildInfoCard(
          index: 0,
          icon: Icons.lock_outlined,
          title: "Private",
          subtitle: "Only you and invited members can see this file",
          isCardSelected: _isCardSelected,
          onTap: () {
            setState(() {
              _isCardSelected = [true, false];
            });
          },
        ),
        const SizedBox(height: 12),
        FormFieldHelper.buildInfoCard(
          index: 1,
          icon: Icons.public,
          title: "Public",
          subtitle: "Anyone with the link can view this file",
          isCardSelected: _isCardSelected,
          onTap: () {
            setState(() {
              _isCardSelected = [false, true];
            });
          },
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  // Widget _buildUrlInputBox() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       FormFieldHelper.buildTextField(
  //         label: "File URL",
  //         controller: _descriptionController,
  //         hintText: "Enter file URL here",
  //       ),
  //       const SizedBox(height: 12),
  //       FormFieldHelper.buildMultilineTextField(
  //         label: "File Description",
  //         controller: _descriptionController,
  //         hintText: "Enter File URL description here",
  //       ),
  //       const SizedBox(height: 12),
  //       // ---- Cards ----
  //       Align(
  //         alignment: Alignment.centerLeft,
  //         child: Text(
  //           'File Privacy',
  //           style: getSemiBoldStyle(
  //             color: ColorManager.black,
  //             fontSize: FontSize.s14,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 5),
  //       FormFieldHelper.buildInfoCard(
  //         index: 0,
  //         icon: Icons.lock_outlined,
  //         title: "Private",
  //         subtitle: "Only you and Invited members can see this file",
  //         isCardSelected: _isCardSelected,
  //         onTap: () {
  //           setState(() {
  //             _isCardSelected[0] = !_isCardSelected[0];
  //           });
  //         },
  //       ),
  //       const SizedBox(height: 12),
  //       FormFieldHelper.buildInfoCard(
  //         index: 1,
  //         icon: Icons.public,
  //         title: "Public",
  //         subtitle: "Anyone with the link can view this file \n",
  //         isCardSelected: _isCardSelected,
  //         onTap: () {
  //           setState(() {
  //             _isCardSelected[1] = !_isCardSelected[1];
  //           });
  //         },
  //       ),

  //       const SizedBox(height: 30),
  //     ],
  //   );
  // }
  Future<void> saveAttachment() async {
    setState(() {
      _isUploading = true;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.saveattachment,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'ID': '0',
        'OrdReqID': widget.ordReqID,
        'group': widget.group,
        'FileName': _fileName,
        'Description': _itemDescriptionController.text.trim(),
        'File_Type': 'File',
        'AttachmentFrom': 'Flutter',
        'Privacy': _privacyValue,
        'Document_File': _base64File,
      },
    );

    setState(() {
      _isUploading = false;
    });

    if (jsonResponse != null) {
      final resp = NotesResponse.fromJson(jsonResponse);

      if (resp.code == 200) {
        showSnackBar(context, resp.message.first);
        Navigator.pop(context, true);
      } else {
        showSnackBar(
          context,
          resp.message.isNotEmpty
              ? resp.message.join(', ')
              : AppStrings.somethingWentWrong,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: 'Attachment',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(20), child: _buildFileUploadUI()),
          ),
          // ---- Upload Button ----
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: Text(
                _isUploading ? "Uploading..." : "Save",
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s18,
                ),
              ),
              onPressed: () {
                saveAttachment();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
