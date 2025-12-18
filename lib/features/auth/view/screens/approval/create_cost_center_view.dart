

import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/custom_field.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class CreateCostCenterView extends StatefulWidget {
  const CreateCostCenterView({super.key});

  @override
  State<CreateCostCenterView> createState() => _CreateCostCenterView();
}

class _CreateCostCenterView extends State<CreateCostCenterView> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  List<bool> _isCardSelected = [];

  List<Map<String, String>> costCenterList = [
    {'Cost Center': "FIN001", 'Description': "Finance Department"},
    {'Cost Center': "Marketing", 'Description': "Marketing"},
    {'Cost Center': "Legal", 'Description': "Legal"},
    {'Cost Center': "0100-ABC", 'Description': "Projct-Mgt-Maint"},
    {'Cost Center': "B_001", 'Description': "B_Hardware"},
    {'Cost Center': "B_001HW", 'Description': "Hardware for SiteB"},
    {'Cost Center': "B_001test", 'Description': "Hardware for SiteB"},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCostCenter);
    // _isCardSelected = List.generate(costCenterList.length, (_) => false); // for all cards
    _isCardSelected = List.generate(costCenterList.length,
        (index) => index == 0); // selected first card by default
  }

  void _filterCostCenter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // filteredCostCenter = requestApprovalList.where((request) {
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
        title: "Cost Center Split",
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
                        placeholderText: 'Search by cost center or description',
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
                            itemCount: costCenterList.length,
                            itemBuilder: (context, index) {
                              //final request = filteredRequests[index];
                              final item = costCenterList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: FormFieldHelper.buildCardWidget(
                                  index: index,
                                  subtitles: [
                                    {'Cost Center': item['Cost Center']!},
                                    {'Description': item['Description']!},
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

                          for (int i = 0; i < costCenterList.length; i++) {
                            if (_isCardSelected[i]) {
                              selectedCenters
                                  .add(costCenterList[i]['Cost Center'] ?? '');
                            }
                          }
                          if (selectedCenters.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No Cost Center selected!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            final selectedNames =
                                selectedCenters.join(', '); // join with commas

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Cost Center Saved Successfully!\nSelected: $selectedNames",
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
