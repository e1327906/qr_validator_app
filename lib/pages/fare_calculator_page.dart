import 'package:flutter/material.dart';

import '../models/constants.dart';

class FareCalculatorPage extends StatefulWidget {
  @override
  _FareCalculatorPageState createState() => _FareCalculatorPageState();
}

class _FareCalculatorPageState extends State<FareCalculatorPage> {


  // Selected values
  String? selectedSrcStnId;
  String? selectedDestStnId;
  String? selectedTicketType;
  String? selectedJourneyType;
  String? selectedGroupSize;

  double? fareAmount; // Stores the calculated fare

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
            buildDropdown("Select Source Station", Icons.train, stationIds, selectedSrcStnId, (value) {
              setState(() => selectedSrcStnId = value);
            }),
            buildDropdown("Select Destination Station", Icons.location_on, stationIds, selectedDestStnId, (value) {
              setState(() => selectedDestStnId = value);
            }),
            buildDropdown("Choose Ticket Type", Icons.confirmation_number, ticketTypes, selectedTicketType, (value) {
              setState(() => selectedTicketType = value);
            }),
            buildDropdown("Select Journey Type", Icons.directions, journeyTypes, selectedJourneyType, (value) {
              setState(() => selectedJourneyType = value);
            }),
            buildDropdown("Choose Group Size", Icons.group, groupSizes, selectedGroupSize, (value) {
              setState(() => selectedGroupSize = value);
            }),

            const SizedBox(height: 20),

            // Calculate Fare Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: calculateFare,
                icon: const Icon(Icons.attach_money),
                label: const Text("Calculate Fare", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                ),
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
          content: Text("Please select all fields before calculating the fare."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      // Basic fare calculation formula (adjust as needed)
      fareAmount = 5.0 +
          (int.parse(selectedDestStnId!) - int.parse(selectedSrcStnId!)).abs() * 2.5;

      // Modify fare based on ticket type
      if (selectedTicketType == "2") fareAmount = fareAmount! * 1.2; // Premium
      if (selectedTicketType == "3") fareAmount = fareAmount! * 1.5; // Luxury

      // Round trip costs double
      if (selectedJourneyType == "2") fareAmount = fareAmount! * 2; // Return Trip

      // Multiply by group size
      if (selectedGroupSize == "2") fareAmount = fareAmount! * 1.5; // Couple
      if (selectedGroupSize == "3") fareAmount = fareAmount! * 2; // Family
      if (selectedGroupSize == "4") fareAmount = fareAmount! * 3; // Group
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fare calculated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}