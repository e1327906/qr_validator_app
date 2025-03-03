import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'confirm_password_reset_page.dart';

class RequestPasswordResetPage extends StatefulWidget {
  final String username;
  const RequestPasswordResetPage({Key? key, required this.username}) : super(key: key);

  @override
  _RequestPasswordResetPageState createState() => _RequestPasswordResetPageState();
}

class _RequestPasswordResetPageState extends State<RequestPasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  bool _isLoading = false;
  String? _errorMessage;
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the passed username
    _usernameController = TextEditingController(text: widget.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _requestResetCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call Amplify Auth resetPassword to send a confirmation code
      await Amplify.Auth.resetPassword(
        username: _usernameController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _codeSent = true;
          _isLoading = false;
        });
      }
    } on AuthException catch (e) {
      if (e.message.contains('already been reset')) {
        // Handle the case where a code was already sent
        setState(() {
          _codeSent = true;
          _errorMessage = 'A code was already sent. Please check your email.';
        });
      } else {
        setState(() {
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToConfirmResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmPasswordResetPage(
          username: _usernameController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Enter your username or email address to receive a password reset code.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username or Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_circle_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username or email';
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
                if (_codeSent) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Text(
                      'A confirmation code has been sent to your email.',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (!_codeSent)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _requestResetCode,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Send Reset Code', style: TextStyle(fontSize: 16)),
                  )
                else
                  ElevatedButton(
                    onPressed: _navigateToConfirmResetPassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Continue to Reset Password', style: TextStyle(fontSize: 16)),
                  ),
                if (_codeSent) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _isLoading ? null : _requestResetCode,
                    child: const Text('Resend Code'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}