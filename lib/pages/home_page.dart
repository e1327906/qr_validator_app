// home_page.dart
import 'package:flutter/material.dart';
import 'package:qr_validator_app/pages/entry_page.dart';
import 'package:qr_validator_app/pages/exit_page.dart';
import 'package:qr_validator_app/pages/setting_page.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String username = 'User';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();

      String name = 'User';
      for (final attribute in attributes) {
        if (attribute.userAttributeKey.key == 'name') {
          name = attribute.value;
          break;
        }
      }

      setState(() {
        username = name;
        isLoading = false;
      });
    } catch (e) {
      print('Error getting user info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QR Validator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, $username',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EntryPage()),
                      );
                    },
                    child: const Text('Entry Mode'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExitPage()),
                      );
                    },
                    child: const Text('Exit Mode'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingPage()),
          );
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}