import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Help'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to Use the QR Validator App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _buildHelpSection(
                'Scanning QR Codes',
                'Tap the scan button on the home page to activate the camera. Position the QR code within the frame and hold steady until it scans.',
                Icons.qr_code_scanner,
              ),

              _buildHelpSection(
                'Validating Results',
                'After scanning, the app will automatically validate the QR code and display the result. Green indicates valid, red indicates invalid.',
                Icons.check_circle,
              ),

              _buildHelpSection(
                'History',
                'All scans are saved in the history tab. Tap on any entry to view the full details of that scan.',
                Icons.history,
              ),

              _buildHelpSection(
                'Settings',
                'Customize app behavior in the settings page. Advanced options are available for technical users.',
                Icons.settings,
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),

              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildFaqItem(
                'Why isn\'t my QR code scanning?',
                'Ensure you have good lighting and the QR code is fully visible in the frame. The code should not be damaged or blurry.',
              ),

              _buildFaqItem(
                'How do I export my scan history?',
                'Go to the History tab, tap the menu icon in the top right, and select "Export" to save your scan history as a CSV file.',
              ),

              _buildFaqItem(
                'Can I scan multiple codes at once?',
                'Currently, the app only supports scanning one QR code at a time.',
              ),

              _buildFaqItem(
                'How do I update the server URLs?',
                'Server URLs can be configured by administrators through the settings page.',
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),

              const Text(
                'Need More Help?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Email: support@qrvalidator.example.com'),
                      Text('Phone: +1 (555) 123-4567'),
                      Text('Hours: Monday-Friday, 9am-5pm EST'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.blue[700],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}