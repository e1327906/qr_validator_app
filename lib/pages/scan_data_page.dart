import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_validator_app/models/usage_txn_model.dart';
import 'package:qr_validator_app/pages/error_page.dart';
import 'package:qr_validator_app/pages/successful_page.dart';
import 'package:qr_validator_app/service/usage_txn_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/json_property_name.dart';
import '../models/response_model.dart';
import '../models/ticket_model.dart';
import '../service/base_api_service.dart';


class ScanDataPage extends StatefulWidget {
  final UsageTxnModel usageTxnModel;
  const ScanDataPage({Key? key, required this.usageTxnModel}) : super(key: key);

  @override
  State<ScanDataPage> createState() => _ScanDataPageState();
}

class _ScanDataPageState extends State<ScanDataPage> with SingleTickerProviderStateMixin {
  final UsageTxnService usageTxnService = UsageTxnService();
  bool _isLoading = false; // Flag to track loading state
  String errorMessage = "";
  late TabController _tabController;
  TicketModel? ticketModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getTicketDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ticket Data'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Encrypted Data'),
            Tab(text: 'Plain Data'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: QR Data
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(widget.usageTxnModel.qrData),
                  ),
                ),
              ],
            ),
          ),

          // Tab 2: Ticket Details
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Ticket Sno', ticketModel?.serialNumber ?? ''),
                  _buildDetailRow('Status', ticketModel?.status.toString() ?? ''),
                  _buildDetailRow('Purchase Date', ticketModel?.effectiveDateTime.toString() ?? ''),
                  _buildDetailRow('Ticket Type', ticketModel?.ticketType.toString() ?? ''),
                  _buildDetailRow('Email', ticketModel?.email.toString() ?? ''),
                  _buildDetailRow('Phone', ticketModel?.phoneNo.toString() ?? ''),
                  _buildDetailRow('PaymentRefNo', ticketModel?.transactionData.paymentRefNo ?? ''),
                  _buildDetailRow('Fare', "${ticketModel?.transactionData.amount}S\$" ?? ''),
                  // Add more ticket details as needed
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          //bool result = await usageTxnService.validateTxn(widget.usageTxnModel);
          bool result = await validateTxn(widget.usageTxnModel);
          if (result) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SuccessfulPage(status: widget.usageTxnModel.status),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ErrorPage(status: widget.usageTxnModel.status, message: errorMessage),
              ),
            );
          }
          setState(() {
            _isLoading = false;
          });
        },
        label: _isLoading ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ) : const Text('Submit'),
        icon: const Icon(Icons.save_rounded, color: Colors.white, size: 25),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<bool> validateTxn(UsageTxnModel req) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUrl = prefs.getString("url");
      String url;
      if (storedUrl != null && storedUrl.isNotEmpty) {
        url = storedUrl;
      } else {
        url = BaseAPIService.url;
      }

      BaseAPIService.baseUrl = url;
      ResponseModel responseModel = await BaseAPIService.post(req.toJson(), kValidate);

      if (responseModel.responseCode == "200") {
        return true;
      } else {
        errorMessage = responseModel.responseMsg;
        log('Transaction failed');
        throw Exception('Transaction failed');
      }
    } catch (e) {
      // Log the exception
      log('Exception during transaction process: $e');
    }
    return false;
  }

  Future<void> _getTicketDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUrl = prefs.getString("url");
      String url;
      if (storedUrl != null && storedUrl.isNotEmpty) {
        url = storedUrl;
      } else {
        url = BaseAPIService.url;
      }

      BaseAPIService.baseUrl = url;
      ResponseModel responseModel = await BaseAPIService.post(widget.usageTxnModel.toJson(), kGetTicketDetail);
      if (responseModel.responseCode == "200") {

        // Deserialize response and return success
        TicketModel ticket = TicketModel.fromJson(responseModel.responseData);
        log('Ticket details retrieved successfully: ${ticket.toString()}');

        setState(() {
          ticketModel = ticket;
        });

      } else {
        errorMessage = responseModel.responseMsg;
        log('Get Ticket Details failed');
        throw Exception('Get Ticket Details failed');
      }
    } catch (e) {
      // Log the exception
      log('Exception during Get Ticket Details failed process: $e');
    }
  }
}