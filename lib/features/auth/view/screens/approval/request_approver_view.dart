import 'package:eyvo_inventory/api/response_models/request_approver_model.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/widgets/common_app_bar.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestApproverPage extends StatefulWidget {
  const RequestApproverPage({super.key});

  @override
  State<RequestApproverPage> createState() => _RequestApproverPageState();
}

class _RequestApproverPageState extends State<RequestApproverPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<RequestModel> allRequests = [
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '001',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
    RequestModel(
      requestNo: '006',
      entryDate: '06-Jun-2025',
      status: 'UNAPPROVED',
      netTotal: 400.00,
    ),
  ];

  List<RequestModel> filteredRequests = [];

  @override
  void initState() {
    super.initState();
    filteredRequests = allRequests;
    _searchController.addListener(_filterRequests);
  }

  void _filterRequests() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredRequests = allRequests.where((request) {
        return request.requestNo.toLowerCase().contains(query) ||
            request.status.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildRequestCard(RequestModel request) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text('Request No: ${request.requestNo}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Entry Date: ${request.entryDate}'),
            Text('Status: ${request.status}'),
            Text('Net Total: ₹${request.netTotal.toStringAsFixed(2)}'),
          ],
        ),
        onTap: () {
          LoggerData.dataLog('hi');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: AppStrings.requestApproval,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: CustomSearchField(
              controller: _searchController,
              placeholderText: 'Search by request no or status',
              inputType: TextInputType.text,
            ),
          ),
          Expanded(
            child: filteredRequests.isEmpty
                ? const Center(child: Text('No requests found'))
                : ListView.builder(
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      return buildRequestCard(filteredRequests[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
