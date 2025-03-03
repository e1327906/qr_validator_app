import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_validator_app/models/fare_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/constants.dart';
import '../models/json_property_name.dart';
import '../models/response_model.dart';
import '../models/usage_txn_model.dart';
import '../service/base_api_service.dart';

class FareCalculatorPage extends StatefulWidget {
  const FareCalculatorPage({super.key});

  @override
  _FareCalculatorPageState createState() => _FareCalculatorPageState();
}

class _FareCalculatorPageState extends State<FareCalculatorPage> {

  bool isLoading = false; // Track loading state
  // Selected values
  String? selectedSrcStnId;
  String? selectedDestStnId;
  String? selectedTicketType;
  String? selectedJourneyType;
  String? selectedGroupSize;

  int? fareAmount; // Stores the calculated fare

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fare Calculator", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDropdown("Source Station", Icons.train, stationIds, selectedSrcStnId, (value) {
              setState(() => selectedSrcStnId = value);
            }),
            buildDropdown("Destination Station", Icons.location_on, stationIds, selectedDestStnId, (value) {
              setState(() => selectedDestStnId = value);
            }),
            buildDropdown("Ticket Type", Icons.confirmation_number, ticketTypes, selectedTicketType, (value) {
              setState(() => selectedTicketType = value);
            }),
            buildDropdown("Journey Type", Icons.directions, journeyTypes, selectedJourneyType, (value) {
              setState(() => selectedJourneyType = value);
            }),
            buildDropdown("Group Size", Icons.group, groupSizes, selectedGroupSize, (value) {
              setState(() => selectedGroupSize = value);
            }),

            const SizedBox(height: 20),

            // Calculate Fare Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : calculateFare,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                ),
                child: isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text("Calculate Fare", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 20),

            // Display Fare Result
            if (fareAmount != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Fare Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text("Fare Amount: \$${fareAmount!.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Dropdown widget builder with icon
  Widget buildDropdown(String label, IconData icon, Map<String, String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blueAccent),
              labelText: label,
              border: InputBorder.none,
            ),
            isExpanded: true,
            hint: Text("Select $label"),
            items: items.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // Simple Fare Calculation Logic
  void calculateFare() {
    if (selectedSrcStnId == null ||
        selectedDestStnId == null ||
        selectedTicketType == null ||
        selectedJourneyType == null ||
        selectedGroupSize == null) {
      // Show error message if any field is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Please select all fields before calculating the fare."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FareModel fareModel = FareModel(
        srcStnId: int.parse(selectedSrcStnId!),
        destStnId: int.parse(selectedDestStnId!),
        ticketType: int.parse(selectedTicketType!),
        journeyType: int.parse(selectedJourneyType!),
        groupSize: int.parse(selectedGroupSize!));

    getFare(fareModel);

  }

  Future<void> getFare(FareModel req) async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUrl = prefs.getString(kTgsEndpoint);
      String url;
      if (storedUrl != null && storedUrl.isNotEmpty) {
        url = storedUrl;
      } else {
        url = BaseAPIService.tgsUrl;
      }

      BaseAPIService.baseUrl = url;
      ResponseModel responseModel = await BaseAPIService.post(req.toJson(), kCalculateTrainFare);

      if (responseModel.responseCode == "200") {

        setState(() {
          // Basic fare calculation formula (adjust as needed)
          fareAmount = responseModel.responseData["fare"];
          isLoading = false; // Stop loading
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fare calculated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() => isLoading = false);
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fare calculated failed!"),
            backgroundColor: Colors.red,
          ),
        );

        log('Transaction failed');
        throw Exception('Transaction failed');
      }
    } catch (e) {
      setState(() => isLoading = false);
      // Log the exception
      log('Exception during transaction process: $e');
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fare calculated failed!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}