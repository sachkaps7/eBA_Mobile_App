import 'package:eyvo_v3/api/response_models/header_response.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
 // 👈 hypothetical response model
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';


class GenericDetailAPIPage extends StatefulWidget {
  final String title;
  final int id;
  final String type;
  final int? lineId; 

  const GenericDetailAPIPage({
    Key? key,
    required this.title,
    required this.id,
    required this.type,
    this.lineId,
  }) : super(key: key);

  @override
  State<GenericDetailAPIPage> createState() => _GenericDetailAPIPageState();
}

class _GenericDetailAPIPageState extends State<GenericDetailAPIPage> {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  bool isError = false;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'header') {
      fetchHeaderDetails();
    } else {
      fetchLineDetails();
    }
  }

  // 🔹 HEADER API CALL
  Future<void> fetchHeaderDetails() async {
    try {
      final jsonResponse = await apiService.postRequest(
        context,
        ApiService.requestHeader,
        {
          'uid': SharedPrefs().uID,
          'Request_ID': widget.id,
        },
      );

      if (jsonResponse != null) {
        final response = HeaderListResponse.fromJson(jsonResponse);
        if (response.code == 200 && response.headerlineData != null) {
          final d = response.headerlineData!;
          setState(() {
            isLoading = false;
            data = {
              'Request No': d.requestNumber ?? '',
              'Entry Date': d.entryDate ?? '',
              'Request Status': d.requestStatus ?? '',
              'Reference No': d.referenceNo ?? '',
              'Instructions': d.instructions ?? '',
              'Delivery To': d.fao ?? '',
              'Document Type': d.orderType ?? '',
              'Delivery Code': d.deliveryCode ?? '',
              d.expName1: d.expCode1 ?? '',
              'Currency': d.ccyCode ?? '',
              'Gross Total': d.grossTotal ?? '',
              'Originator': d.originatorName ?? '',
              'Approver Name': d.requestApproverName ?? '',
            };
          });
        } else {
          throw Exception(response.message.join(', '));
        }
      } else {
        throw Exception("No response from server");
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  // 🔹 LINE API CALL
  Future<void> fetchLineDetails() async {
    try {
      final jsonResponse = await apiService.postRequest(
        context,
        ApiService.requestLineItem, 
        {
          'uid': SharedPrefs().uID,
          'Request_ID': widget.id,
          'Line_ID': widget.lineId,
        },
      );

      if (jsonResponse != null) {
        final response = HeaderListResponse.fromJson(jsonResponse);
        if (response.code == 200 && response.headerlineData != null) {
          final line = response.headerlineData!;
          setState(() {
            isLoading = false;
            data = {
              'Item Code': line.itemCode ?? '',
              'Description': line.description ?? '',
              'Quantity': line.quantity ?? '',
              'Unit': line.unit ?? '',
              'Unit Price': line.price ?? '',
              'Net Price': line.netPrice ?? '',
              'Tax': line.tax ?? '',
              'Tax Value': line.taxValue ?? '',
              'Currency': line.supplierCcyCode ?? '',
            };
          });
        } else {
          throw Exception(response.message.join(', '));
        }
      } else {
        throw Exception("No response from server");
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: widget.title,
      ),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isError || data == null
              ? const Center(child: Text("Failed to load data"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: ColorManager.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: data!.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value?.toString() ?? "-",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ColorManager.darkGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
    );
  }
}
