import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_validator_app/models/json_property_name.dart';
import 'package:qr_validator_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/base_api_service.dart';
import 'about_page.dart';
import 'help_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  TextEditingController qrsEndpointController = TextEditingController();
  TextEditingController tgsEndpointController = TextEditingController();
  bool _showEndpointFields = false;
  int _tapCount = 0;
  bool isNotificationsEnabled = false;

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

  void _handleTripleTap() {
    _tapCount++;

    // Reset tap count after a delay if not reaching 3 taps
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_tapCount < 3) {
        _tapCount = 0;
      }
    });

    // Show endpoint fields if triple tap detected
    if (_tapCount >= 3) {
      setState(() {
        _showEndpointFields = !_showEndpointFields;
        _tapCount = 0;
      });

      // Show a snackbar to indicate developer mode was toggled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_showEndpointFields
              ? 'Developer settings enabled'
              : 'Developer settings disabled'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    qrsEndpointController.dispose();
    tgsEndpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: GestureDetector(
          onTap: _handleTripleTap,
          child: const Text('Settings'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Regular settings that always show
              const Text(
                'Application Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Add your regular settings here
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  subtitle: const Text('App version and information'),
                  onTap: () {
                    // Handle About action
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help'),
                  subtitle: const Text('How to use this application'),
                  onTap: () {
                    // Handle Help action
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive alerts and updates'),
                  value: isNotificationsEnabled, // Set this based on your stored preferences
                  onChanged: (value) {
                    // Handle notification toggle
                    setState(() {
                      isNotificationsEnabled = value; // Correctly update the state
                    });

                    // Show a snackbar to indicate developer mode was toggled
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isNotificationsEnabled
                            ? 'Notifications enabled'
                            : 'Notifications disabled'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),

              // Developer settings section that only appears after triple tap
              if (_showEndpointFields) ...[
                const SizedBox(height: 32),
                const Divider(),
                const Text(
                  'Developer Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: qrsEndpointController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'QR Server URL',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontSize: 13),
                  ),
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: tgsEndpointController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'TG Server URL',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontSize: 13),
                  ),
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Save action
                        String qrsEndpoint = qrsEndpointController.text;
                        String tgsEndpoint = tgsEndpointController.text;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString(kQrsEndpoint, qrsEndpoint);
                        prefs.setString(kTgsEndpoint, tgsEndpoint);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Server URLs saved successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('Save URLs'),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                      ),
                      onPressed: () {
                        // Reset to defaults
                        setState(() {
                          qrsEndpointController.text = BaseAPIService.qrsUrl;
                          tgsEndpointController.text = BaseAPIService.tgsUrl;
                        });
                      },
                      child: const Text('Reset to Default'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),

                // Additional developer options
                Card(
                  elevation: 2,
                  color: Colors.grey[100],
                  child: ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text('Debug Mode'),
                    subtitle: const Text('Enable additional logging'),
                    trailing: Switch(
                      value: false, // Set based on stored preferences
                      onChanged: (value) {
                        // Handle debug mode toggle
                      },
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Navigation buttons at the bottom
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('Return to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}