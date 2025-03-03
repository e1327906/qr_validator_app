import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_validator_app/models/json_property_name.dart';
import 'package:qr_validator_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/base_api_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  TextEditingController qrsEndpointController = TextEditingController(); // Controller for the URL TextField
  TextEditingController tgsEndpointController = TextEditingController(); // Controller for the URL TextField
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? qrsEndpoint = prefs.getString(kQrsEndpoint);
    if (qrsEndpoint != null && qrsEndpoint.isNotEmpty) {
      setState(() {
        qrsEndpointController.text = qrsEndpoint;
      });

    } else {
      setState(() {
        qrsEndpointController.text = BaseAPIService.qrsUrl;
      });
    }

    String? tgsEndpoint = prefs.getString(kTgsEndpoint);
    if (tgsEndpoint != null && tgsEndpoint.isNotEmpty) {
      setState(() {
        tgsEndpointController.text = tgsEndpoint;
      });

    } else {
      setState(() {
        tgsEndpointController.text = BaseAPIService.tgsUrl;
      });
    }
  }

  @override
  void dispose() {
    qrsEndpointController
        .dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Settings'), // Set app bar title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: qrsEndpointController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Enter QR Server URL', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20), // Add spacing below the TextField
              TextField(
                controller: tgsEndpointController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Enter TG Server URL', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20), // Add spacing below the TextField
              ElevatedButton(
                onPressed: () async {
                  // Add your save action here
                  String qrsEndpoint = qrsEndpointController.text;
                  String tgsEndpoint = tgsEndpointController.text;
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString(kQrsEndpoint, qrsEndpoint);
                  prefs.setString(kTgsEndpoint, tgsEndpoint);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}