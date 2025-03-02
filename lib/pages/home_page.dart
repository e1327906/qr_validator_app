// home_page.dart
import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:qr_validator_app/pages/entry_page.dart';
import 'package:qr_validator_app/pages/exit_page.dart';
import 'package:qr_validator_app/pages/setting_page.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_failure_page.dart';
import 'fare_calculator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String username = 'User';
  String userGroup = 'No group';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserGroup();
  }

  Future<void> _fetchUserGroup() async {
    setState(() {
      isLoading = true;
    });

    try {

      // Fetch session and tokens
      final session = await Amplify.Auth.fetchAuthSession(
        options: FetchAuthSessionOptions(),
      );

      if (session is CognitoAuthSession) {
        final idToken = session.userPoolTokensResult.value.idToken.raw;
        userGroup = _extractUserGroup(idToken);  // Extract the user group from the ID token

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("idToken", idToken);

        // Immediately check the user group after getting the session
        _checkUserGroup(userGroup);
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the current user and attributes
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();

      // Extract username (email in this case) from the attributes
      String name = 'User';
      for (final attribute in attributes) {
        if (attribute.userAttributeKey.key == 'email') {
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
  void _checkUserGroup(String userGroup) {
    // Immediately check if user is in the correct group
    if (!userGroup.contains('ROLE_OPERATOR')) {
      _showAuthFailure(); // Show failure if they don't belong to the required group
    }else{
      _fetchUserInfo();
    }
  }

  void _showAuthFailure() {
    // Replace all previous routes with the auth failure page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => AuthFailurePage(onSignOut: _signOut),
      ),
          (route) => false, // This predicate returns false for all routes, removing them all
    );
  }

  String _extractUserGroup(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) {
        return 'Invalid Token';
      }

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> decodedToken = jsonDecode(payload);

      if (decodedToken.containsKey('cognito:groups')) {
        return decodedToken['cognito:groups'].toString();
      } else {
        return 'No group assigned';
      }
    } catch (e) {
      return 'Error decoding token';
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
        elevation: 2,
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
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome, ',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Font size for username
                        ),
                      ),
                      Text(
                        username.substring(0, username.indexOf('@')),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15, // Font size for username
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select an operation mode',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildMenuCard(
                      context,
                      title: 'Entry Mode',
                      icon: Icons.login,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EntryPage()),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: 'Exit Mode',
                      icon: Icons.logout,
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExitPage()),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: 'Fare',
                      icon: Icons.monetization_on,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FareCalculatorPage()),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: 'History',
                      icon: Icons.history,
                      color: Colors.purple,
                      onTap: () {
                        // Add history functionality
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingPage()),
          );
        },
        tooltip: 'Settings',
        child: const Icon(Icons.settings),
        elevation: 4,
      ),
    );
  }

// Helper method to create menu cards
  Widget _buildMenuCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}