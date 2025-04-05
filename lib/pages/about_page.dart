import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appVersion = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  Future<void> _getAppInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    } catch (e) {
      setState(() {
        appVersion = '1.0.0';
        buildNumber = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // App logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.qr_code,
                  size: 80,
                  color: Colors.blue[800],
                ),
              ),

              const SizedBox(height: 24),

              // App name
              const Text(
                'QR Validator App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Version info
              Text(
                'Version $appVersion (Build $buildNumber)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Platform: ${Platform.isIOS ? "iOS" : "Android"}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),

              // App description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'QR Validator is a secure and efficient tool for scanning, validating, and managing QR codes. '
                      'It provides real-time verification against our secure servers to ensure the authenticity of scanned codes.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Features
              _buildSection(
                'Key Features',
                [
                  'Fast and accurate QR code scanning',
                  'Secure validation against QRS and TGS servers',
                  'Comprehensive scan history with detailed reports',
                  'Customizable settings for administrators',
                ],
              ),

              const SizedBox(height: 24),

              // Legal
              _buildInfoSection(
                'Legal',
                [
                  'Terms of Service',
                  'Privacy Policy',
                  'License Information',
                ],
                isClickable: true,
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),

              // Credits
              const Text(
                'Developed by',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SE32 Students',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '© 2025 All Rights Reserved',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items, {bool isClickable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildInfoItem(item, isClickable)),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items, {bool isClickable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildInfoItem(item, isClickable)),
      ],
    );
  }

  Widget _buildInfoItem(String text, bool isClickable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: isClickable
          ? InkWell(
        onTap: () {
          // Handle tap for legal docs
          _showLegalDialog(text);
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.blue[700],
            decoration: TextDecoration.underline,
          ),
        ),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green[700],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _showLegalDialog(String documentType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(documentType),
        content: SingleChildScrollView(
          child: Text(
            'This is the $documentType for the QR Validator App. '
                'This is placeholder text and should be replaced with actual legal content in a production app.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}