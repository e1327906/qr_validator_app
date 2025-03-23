# qr_validator_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## build command to prevent reverse-engineer
- flutter build apk --release --obfuscate --split-debug-info=./debug-info

###
- keytool -genkeypair -v -keystore release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=example, OU=example, O=example, L=singapore, S=singapore, C=singapore" -alias example
- jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA-256 -keystore release-key.keystore app-release.apk example
- P@ssw0rd
- apksigner sign --ks release-key.keystore --ks-key-alias example --ks-pass pass:P@ssw0rd --key-pass pass:P@ssw0rd --v2-signing-enabled true --v3-signing-enabled true app-release.apk

