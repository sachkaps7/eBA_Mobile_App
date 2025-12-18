import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/custom_field.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class CreateTermsAndConditionView extends StatefulWidget {
  const CreateTermsAndConditionView({super.key});

  @override
  State<CreateTermsAndConditionView> createState() =>
      _CreateTermsAndConditionView();
}

class _CreateTermsAndConditionView extends State<CreateTermsAndConditionView> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  List<bool> _isCardSelected = [];

  List<Map<String, String>> termsAndConditionList = [
    {'Code': "Offer & Agreement", 'Outline': "DELL T&C's"},
    {'Code': "Display PO Num", 'Outline': "Display Order Number"},
    {'Code': "NET-30-DAY", 'Outline': "NET 30 Agreement"},
    {'Code': "Assignment", 'Outline': "Assignment"},
    {'Code': "Compliance", 'Outline': "Compliance"},
    {'Code': "TaxExempt", 'Outline': "TaxExempt"},
    {'Code': "Inspection", 'Outline': "Inspection"},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filtertermsAndCondition);
    // _isCardSelected = List.generate(termsAndConditionList.length, (_) => false); // for all cards
    _isCardSelected = List.generate(termsAndConditionList.length,
        (index) => index == 0); // selected first card by default
  }

  void _filtertermsAndCondition() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // filteredtermsAndCondition = requestApprovalList.where((request) {
      //   return request.requestNumber.toLowerCase().contains(query) ||
      //       request.requestStatus.toLowerCase().contains(query);
      // }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                            itemCount: termsAndConditionList.length,
                            itemBuilder: (context, index) {
                              //final request = filteredRequests[index];
                              final item = termsAndConditionList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: FormFieldHelper.buildCardWidget(
                                  index: index,
                                  subtitles: [
                                    {'Code    ': item['Code']!},
                                    {'Outline': item['Outline']!},
                                  ],
                                  isCardSelected: _isCardSelected,
                                  onTap: () {
                                    // navigateToScreen(
                                    //   context,
                                    //   RequestDetailsView(
                                    //       requestId: request.requestId,
                                    //       requestNumber: request.requestNumber),
                                    // );

                                    setState(() {
                                      _isCardSelected[index] =
                                          !_isCardSelected[index];
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
                          final selectedCenters = <String>[];

                          for (int i = 0;
                              i < termsAndConditionList.length;
                              i++) {
                            if (_isCardSelected[i]) {
                              selectedCenters
                                  .add(termsAndConditionList[i]['Code'] ?? '');
                            }
                          }
                          if (selectedCenters.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No Terms & Condition selected!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            final selectedNames =
                                selectedCenters.join(', '); // join with commas

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Terms & Condition Saved Successfully!\nSelected: $selectedNames",
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                              ),
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
