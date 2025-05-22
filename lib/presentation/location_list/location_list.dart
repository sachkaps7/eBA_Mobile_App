import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/location_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class LocationListView extends StatefulWidget {
  final String selectedItem;
  final String selectedTitle;
  final int selectedRegioId;
  const LocationListView(
      {super.key,
      required this.selectedItem,
      required this.selectedTitle,
      required this.selectedRegioId});

  @override
  State<LocationListView> createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  bool isLoading = false;
  final ApiService apiService = ApiService();
  late List<Location> locationItems = [];
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void fetchLocations() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      //  'uid': SharedPrefs().uID,
      'regionid': widget.selectedRegioId
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.locationList, data);
    if (jsonResponse != null) {
      final response = LocationResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          locationItems = response.data!;
        });
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //   double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: AppStrings.selectLocation,
      ),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isError
              ? Column(
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: displayHeight(context) * 0.65,
                        width: displayWidth(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: ColorManager.white,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Image.asset(
                                ImageAssets.noRecordFoundIcon,
                                width: displayWidth(context) * 0.5,
                              ),
                              Text(
                                errorText,
                                style: getRegularStyle(
                                  color: ColorManager.lightGrey,
                                  fontSize: FontSize.s17,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    height: displayHeight(context),
                    child: Column(
                      children: [
                        // SizedBox(height: topPadding),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 12),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         widget.selectedTitle,
                        //         style: getBoldStyle(
                        //           color: ColorManager.darkBlue,
                        //           fontSize: FontSize.s20,
                        //         ),
                        //       ),
                        //       const Spacer(),
                        //       SizedBox(
                        //         height: 20,
                        //         child: CustomImageButton(
                        //           imageString: ImageAssets.closeIcon,
                        //           onTap: () {
                        //             Navigator.pop(context);
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 12),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: locationItems.length,
                            separatorBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Divider(
                                color: ColorManager.primary,
                                height: 0.1,
                                thickness: 0.1,
                              ),
                            ),
                            itemBuilder: (context, index) {
                              final item = locationItems[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.circular(
                                        6), // Match radius
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    visualDensity:
                                        const VisualDensity(vertical: -2),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    title: Text(
                                      item.locationCode!,
                                      style: item.locationCode ==
                                              widget.selectedItem
                                          ? getMediumStyle(
                                              color: ColorManager.orange2,
                                              fontSize: FontSize.s17,
                                            )
                                          : getRegularStyle(
                                              color: ColorManager.lightGrey2,
                                              fontSize: FontSize.s17,
                                            ),
                                    ),
                                    onTap: () {
                                      SharedPrefs().selectedLocation =
                                          item.locationCode!;
                                      SharedPrefs().selectedLocationID =
                                          item.locationId!;
                                      showSnackBar(context,
                                          '${AppStrings.locationSelectedMessage}${item.locationCode}');
                                      Navigator.pop(context, item.locationCode);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
