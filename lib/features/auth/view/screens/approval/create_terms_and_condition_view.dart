import 'dart:async';

import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/all_terms_conditions_response.dart';
import 'package:eyvo_v3/api/response_models/note_details_response_model.dart';
import 'package:eyvo_v3/api/response_models/terms_save_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/custom_field.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';

class CreateTermsAndConditionView extends StatefulWidget {
  final String group;
  final int ordReqID;
  const CreateTermsAndConditionView({
    super.key,
    required this.group,
    required this.ordReqID,
  });

  @override
  State<CreateTermsAndConditionView> createState() =>
      _CreateTermsAndConditionView();
}

class _CreateTermsAndConditionView extends State<CreateTermsAndConditionView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String searchText = '';

  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  List<bool> _isCardSelected = [];
  TermsListData? termsListDetail;
  List<ListElement> allTerms = [];
  List<int> selectedRecNums = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    fetchTermsDetails();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Trigger only when >=3 chars OR cleared
    if (_searchController.text.length >= 3 || _searchController.text.isEmpty) {
      if (searchText != _searchController.text) {
        searchText = _searchController.text;

        _debounce?.cancel();
        _debounce = Timer(
          const Duration(milliseconds: 500),
          () {
            fetchTermsDetails();
          },
        );
      }
    }
  }

  Future<void> fetchTermsDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.getAllTerms,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'ID': widget.ordReqID,
        "regionid": '1',
        "search": _searchController.text.trim(),
        'group': widget.group,
      },
    );

    if (jsonResponse != null) {
      final resp = AllTermsListDetailResponseModel.fromJson(jsonResponse);

      if (resp.code == 200) {
        setState(() {
          termsListDetail = resp.data;
          allTerms = resp.data.list;

          _isCardSelected =
              allTerms.map((term) => term.itemIndex != 0).toList();

          selectedRecNums = allTerms
              .where((term) => term.itemIndex != 0)
              .map((term) => term.recNum)
              .toList();

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

  Future<void> saveTermsDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.saveAllTerms,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'OrdReqID': widget.ordReqID,
        "search": _searchController.text.trim(),
        'group': widget.group,
        'TextCodeIDs': selectedRecNums.join(','),
        'id': '0',
      },
    );

    if (jsonResponse != null) {
      final resp = SaveTerms.fromJson(jsonResponse);

      if (resp.code == 200) {
        if (resp.code == 200) {
          final successMessage = resp.message.isNotEmpty
              ? resp.message.first
              : 'Terms saved successfully';

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
      } else {
        errorText = resp.message.join(', ');
      }
    }

    setState(() {
      isError = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: "Terms & Condition",
      ),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isError
              ? Center(child: Text(errorText))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: CustomSearchField(
                        controller: _searchController,
                        placeholderText: 'Search by code or outline',
                        inputType: TextInputType.text,
                      ),
                    ),
                    Expanded(
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbColor:
                              WidgetStateProperty.all(ColorManager.darkBlue),
                          trackColor: WidgetStateProperty.all(
                              ColorManager.primary.withOpacity(0.2)),
                          thickness: WidgetStateProperty.all(6),
                          radius: const Radius.circular(8),
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            //itemCount: filteredRequests.length,
                            itemCount: allTerms.length,
                            itemBuilder: (context, index) {
                              final item = allTerms[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: FormFieldHelper.buildCardWidget(
                                  index: index,
                                  subtitles: [
                                    {'Code    ': item.textCode},
                                    {'Outline': item.textOutline},
                                  ],
                                  isCardSelected: _isCardSelected,
                                  onTap: () {
                                    setState(() {
                                      _isCardSelected[index] =
                                          !_isCardSelected[index];

                                      final recNum = allTerms[index].recNum;

                                      if (_isCardSelected[index]) {
                                        //  Selected  add
                                        if (!selectedRecNums.contains(recNum)) {
                                          selectedRecNums.add(recNum);
                                        }
                                      } else {
                                        // Unselected  remove
                                        selectedRecNums.remove(recNum);
                                      }
                                      LoggerData.dataLog(
                                          "##############${selectedRecNums}");
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: ColorManager.white,
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: CustomButton(
                        buttonText: 'Save',
                        onTap: () {
                          if (selectedRecNums.isEmpty) {
                            showSnackBar(
                                context, "No Terms & Condition selected!");
                          } else {
                            saveTermsDetails();
                            showSnackBar(
                              context,
                              "Saved Successfully!\nRecNums: ${selectedRecNums.join(', ')}",
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
