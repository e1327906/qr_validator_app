// main.dart
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:qr_validator_app/pages/home_page.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  await _configureAmplify();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    // Add Auth plugin
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugin(auth);

    // Configure Amplify
    await Amplify.configure(amplifyconfig);
    print('Successfully configured Amplify');
  } catch (e) {
    print('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      // Set initial step to sign in
      initialStep: AuthenticatorStep.signIn,
      authenticatorBuilder: (context, state) {
        if (state.currentStep == AuthenticatorStep.signIn) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Left and right padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  children: [
                    // Logo at the top
                    Image.asset(
                      'assets/animations/logo.png', // Replace with your logo path
                      height: 100, // Adjust the size as needed
                    ),
                    const SizedBox(height: 20), // Add some space between logo and text
                    const Text(
                      'AFC Staff Sign In',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20), // Add space between text and sign-in form
                    SignInForm(),
                  ],
                ),
              ),
            ),
          );
        }
        return null; // Default Authenticator UI for web
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        title: 'QR Validator',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}