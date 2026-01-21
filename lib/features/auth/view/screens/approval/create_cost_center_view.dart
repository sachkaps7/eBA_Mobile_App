import 'dart:async';

import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/all_CC_list_response_model.dart';
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

class CreateCostCenterView extends StatefulWidget {
  final String group;
  final int ordReqID;
  const CreateCostCenterView({
    super.key,
    required this.group,
    required this.ordReqID,
  });

  @override
  State<CreateCostCenterView> createState() => _CreateCostCenterView();
}

class _CreateCostCenterView extends State<CreateCostCenterView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String searchText = '';

  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  List<bool> _isCardSelected = [];
  CostCenterData? costCenterData;
  List<CostCenterItem> allCC = [];
  List<int> costCentreId = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    fetchCCDetails();
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
            fetchCCDetails();
          },
        );
      }
    }
  }

  Future<void> fetchCCDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.getAllCC,
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
      final resp = CostCenterResponse.fromJson(jsonResponse);

      if (resp.code == 200) {
        setState(() {
          costCenterData = resp.data;
          allCC = resp.data.list;

          _isCardSelected = allCC.map((CC) => CC.recNum != 0).toList();

          costCentreId = allCC
              .where((cc) => cc.recNum != 0) 
              .map((cc) => cc.costCentreId)
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

  Future<void> saveCCDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.saveAllCC,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'OrdReqID': widget.ordReqID,
        "search": _searchController.text.trim(),
        'group': widget.group,
        'CostCentreIDs': costCentreId.join(','),
        'id': '0',
      },
    );

    if (jsonResponse != null) {
      final resp = SaveTerms.fromJson(jsonResponse);

      if (resp.code == 200) {
        if (resp.code == 200) {
          final successMessage = resp.message.isNotEmpty
              ? resp.message.first
              : 'cost center saved successfully';

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
        title: "Cost Center",
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
                            itemCount: allCC.length,
                            itemBuilder: (context, index) {
                              final item = allCC[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: FormFieldHelper.buildCardWidget(
                                  index: index,
                                  subtitles: [
                                    {'Code    ': item.costCode},
                                    {'Outline': item.costDescription},
                                  ],
                                  isCardSelected: _isCardSelected,
                                  onTap: () {
                                    setState(() {
                                      _isCardSelected[index] =
                                          !_isCardSelected[index];

                                      final ccId = allCC[index].costCentreId;

                                      if (_isCardSelected[index]) {
                                        // Selected  add costCentreId
                                        if (!costCentreId.contains(ccId)) {
                                          costCentreId.add(ccId);
                                        }
                                      } else {
                                        // Unselected  remove costCentreId
                                        costCentreId.remove(ccId);
                                      }

                                      LoggerData.dataLog(
                                          "Selected CostCentreIDs => $costCentreId");
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
                          if (costCentreId.isEmpty) {
                            showSnackBar(context, "No Cost Center selected!");
                          } else {
                            saveCCDetails();
                            // showSnackBar(
                            //   context,
                            //   "Saved Successfully!\nRecNums: ${costCentreId.join(', ')}",
                            // );
                          }
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
