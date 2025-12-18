

import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/custom_field.dart';
import 'package:eyvo_v3/core/widgets/form_field_helper.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class CreateGroupApproverView extends StatefulWidget {
  const CreateGroupApproverView({super.key});

  @override
  State<CreateGroupApproverView> createState() => _CreateGroupApproverView();
}

class _CreateGroupApproverView extends State<CreateGroupApproverView> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  List<bool> _isCardSelected = [];

  List<Map<String, String>> groupApproversList = [
    {'Group Code': "Accounts", 'Description': "Accountant", 'Mandatory': "No"},
    {
      'Group Code': "Engineering",
      'Description': "Engineering",
      'Mandatory': "No"
    },
    {'Group Code': "HR", 'Description': "Human Resources", 'Mandatory': "No"},
    {'Group Code': "IT", 'Description': "IT Department", 'Mandatory': "No"},
    {
      'Group Code': "Payment",
      'Description': "Payment Authority",
      'Mandatory': "No"
    },
    {
      'Group Code': "Purchasing",
      'Description': "Purchasing Department",
      'Mandatory': "No"
    },
    {
      'Group Code': "Spending",
      'Description': "Spend Managers",
      'Mandatory': "No"
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterGroupApprover);
    // _isCardSelected = List.generate(groupApproversList.length, (_) => false); // for all cards
    _isCardSelected = List.generate(groupApproversList.length,
        (index) => index == 0); // selected first card by default
  }

  void _filterGroupApprover() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // _filterGroupApprover = requestApprovalList.where((request) {
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
        title: "Group Approvers List",
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
                        placeholderText: 'Search by group code or description',
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
                            itemCount: groupApproversList.length,
                            itemBuilder: (context, index) {
                              //final request = filteredRequests[index];
                              final item = groupApproversList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: FormFieldHelper.buildCardWidget(
                                  index: index,
                                  subtitles: [
                                    {'Group Code ': item['Group Code']!},
                                    {'Description ': item['Description']!},
                                    {'Mandatory  ': item['Mandatory']!},
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
                          final selectedGroups = <String>[];

                          for (int i = 0; i < groupApproversList.length; i++) {
                            if (_isCardSelected[i]) {
                              selectedGroups.add(
                                  groupApproversList[i]['Group Code'] ?? '');
                            }
                          }
                          if (selectedGroups.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No Group Approver selected!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            final selectedNames =
                                selectedGroups.join(', '); // join with commas

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Group Approver Saved Successfully!\nSelected: $selectedNames",
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
