import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/note_details_response_model.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';

class NotesView extends StatefulWidget {
  final int noteId;
  final String group;
  final int ordReqID;

  const NotesView({
    Key? key,
    required this.noteId,
    required this.group,
    required this.ordReqID,
  }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final TextEditingController _noteController = TextEditingController();
  List<bool> _isCardSelected = [true, false];
  bool _isUploading = false;
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  NotesWrapper? noteDetails;
  bool get isEditable => noteDetails?.permission.mode == 'RW';

  int? _notePrivacy;
  final ApiService apiService = ApiService();
  @override
  void initState() {
    super.initState();
    _noteController.addListener(() {
      setState(() {});
    });
    fetchNoteDetails();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> fetchNoteDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.getnoteDetails,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'ID': widget.noteId,
        'OrdReqID': widget.ordReqID,
        'group': widget.group,
      },
    );

    if (jsonResponse != null) {
      final resp = NotesResponse.fromJson(jsonResponse);
      if (resp.code == 200) {
        setState(() {
          noteDetails = resp.data;

          _noteController.text = resp.data.notesData.notes ?? '';

          _notePrivacy = noteDetails?.notesData.notePrivacy;

          _isCardSelected = _notePrivacy == 0
              ? [true, false] // Private
              : [false, true]; // Public

          isLoading = false;
        });
        return;
      } else {
        errorText = resp.message.join(', ');
      }
    }
    setState(() {
      isError = true;
      isLoading = false;
    });
  }

  Future<void> saveNote() async {
    setState(() {
      _isUploading = true;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.savenote,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'ID': widget.noteId,
        'OrdReqID': widget.ordReqID,
        'group': widget.group,
        'Notes': _noteController.text.trim(),
        'Note_Privacy':
            (_notePrivacy == 1) ? false : true, // true=Private, false=Public
      },
    );

    setState(() {
      _isUploading = false;
    });

    if (jsonResponse != null) {
      final resp = NotesResponse.fromJson(jsonResponse);

      if (resp.code == 200) {
        final successMessage = resp.message.isNotEmpty
            ? resp.message.first
            : 'Note saved successfully';

        showSnackBar(context, successMessage);

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
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: 'Notes',
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          return false;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormFieldHelper.buildNotesTextField(
                  label: "Notes",
                  controller: _noteController,
                  maxLines: 10,
                  maxLength: 2500,
                  readOnly: !isEditable,
                  showLengthError: _noteController.text.length >= 2500,
                  errorMessage: "Max 2500 characters allowed",
                  isRequired: true),

              const SizedBox(height: 30),
              Text(
                'File Privacy',
                style: getSemiBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s14,
                ),
              ),
              const SizedBox(height: 8),
              FormFieldHelper.buildInfoCard(
                index: 0,
                icon: Icons.lock_outlined,
                title: "Private",
                subtitle: "Only you and invited members can see this file",
                isCardSelected: _isCardSelected,
                onTap: isEditable
                    ? () {
                        setState(() {
                          _notePrivacy = 0;
                          _isCardSelected = [true, false];
                        });
                      }
                    : null,
              ),

              const SizedBox(height: 12),
              FormFieldHelper.buildInfoCard(
                index: 1,
                icon: Icons.public,
                title: "Public",
                subtitle: "Anyone with the link can view this file \n",
                isCardSelected: _isCardSelected,
                onTap: isEditable
                    ? () {
                        setState(() {
                          _notePrivacy = 1;
                          _isCardSelected = [false, true];
                        });
                      }
                    : null,
              ),

              //  const SizedBox(height: 20),
              // ---- Upload Button ----

              // if (isEditable)
              //   SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.90,
              //     height: 50,
              //     child: ElevatedButton.icon(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: ColorManager.darkBlue,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //       ),
              //       label: Text(
              //         _isUploading ? "Uploading..." : "Save",
              //         style: getBoldStyle(
              //           color: ColorManager.white,
              //           fontSize: FontSize.s18,
              //         ),
              //       ),
              //       onPressed: () {},
              //     ),
              //   ),
              // const SizedBox(
              //   height: 20,
              // )
            ],
          ),
        ),
      ),
      bottomNavigationBar: isEditable
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
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
                    saveNote();
                  },
                ),
              ),
            )
          : null,
    );
  }
}
