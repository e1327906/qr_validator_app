import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pointycastle/export.dart';
import 'package:asn1lib/asn1lib.dart';

// Function to load the public key from PEM format
RSAPublicKey loadPublicKey(String pem) {
  // Remove header, footer, and any whitespace
  final lines = pem.split('\n');
  final base64String = lines
      .where((line) => !line.startsWith('-----') && line.isNotEmpty)
      .join('');

  final decodedBytes = base64.decode(base64String);

  // Parse the ASN.1 structure of the public key
  final asn1Parser = ASN1Parser(decodedBytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  // According to X.509 format, the first element is algorithm identifier, the second is the actual key
  final bitString = topLevelSeq.elements[1] as ASN1BitString;

  // Extract the key sequence from the bit string
  final keyParser = ASN1Parser(bitString.contentBytes());
  final keySeq = keyParser.nextObject() as ASN1Sequence;

  // The first element is modulus (n), second is public exponent (e)
  final modulus = keySeq.elements[0] as ASN1Integer;
  final exponent = keySeq.elements[1] as ASN1Integer;

  return RSAPublicKey(
      modulus.valueAsBigInteger,
      exponent.valueAsBigInteger);
}

// Function to hash data using SHA-256 (matching the Java implementation)
Uint8List hashSHA256(String data) {
  final digest = SHA256Digest();
  final dataBytes = utf8.encode(data);
  final hash = digest.process(Uint8List.fromList(dataBytes));
  return hash;
}

// Function to verify RSA signature matching the Java implementation
bool verifySignature(String data, String signature, RSAPublicKey publicKey) {
  try {
    // Create the signer for verification (SHA256withRSA)
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201'); // OID for SHA-256 with RSA

    // Initialize with public key
    signer.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

    // Hash the data (matching Java's crypto.hashSHA256(plainMessage) step)
    final dataHash = hashSHA256(data);

    // Verify the signature against the hash
    final signatureBytes = base64.decode(signature);

    // In the Java code, the signature is verified against the hash
    return signer.verifySignature(dataHash, RSASignature(Uint8List.fromList(signatureBytes)));
  } catch (e) {
    print('Verification error: $e');
    return false;
  }
}


/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  String pemPublicKey1 = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt1wpx8AxiEd25KO7zRBv
xVlaD+CsctCZPV5ifagyQ+UqFYhng7AVLtg04W4P1ApIh+LFLrxNFfuRMGou9Voz
KtFC1lCW+upzj8DGDANP/mjULEOTtTCPJTMY8vpb1gnFdJWl2nZ5avnK3zZMksQd
DsjBGjKHYkeJN+RAShHUOsqdWZbKiYVPA1J5+pAqa4XGrfxcZrvRUdGINzLyQ2Hh
W7SFLvP4A2C3dhdKTMq07PeALkqbrEgRp+wmrvHe1W90Hm0VeD9FehoFjNaHQlEu
EiyGx0fbZ7iGJjY1UL7mZOwxs4aObvDQHZPx1F0XyM3Yza+MQ33RH3UwGwKjGtNP
uwIDAQAB
-----END PUBLIC KEY-----
''';

  String data = "ugQq3LrIs5cSlzP5fVpfGaMzBAPvib5e8wd68RyX5MSsoRiKzo6YN918qkk8FNTsRt2he/5dltVv08KErBg4qL1+5tv6ENr18egUVnnQKS9HO6VwvyHKZYxBCVLW5eZ8e5hBPihVBacoU5lcgC8u1l9XdquzcuDio225jA1E0VUohfuubmc0SSw4gt0d6hpIx2dHeCwlDCt6lL81MbpTRL/JsvIacOWn/IlGTP7es1J6iKiPSZcXgZdatVH7RUnXS6AQKKUw0+3LZBVr2ktkAXrEKJGW5g+yLGk0gnEGvQvbnjq1QvCmW0ErSrQiuJ6qK13lBkqZi6RLixu592Ivdj4i9u0ZAA4Y41SrmgnXpY3afukM2dISXCdMUTeQ6ezLIWv3m6jWYVdkb6aHA6Y4cr3koZa1LrwazsuSzsMK0MkoUFZ2DwGt7U1dted7Az6mHsegHj1KZsAR/CvCuA6PtnionNddQDfrGNXXPXdrawCuYMz9T53GF1AeYeJws7sh";
  String signature = "LbDTR5ZObQlfzRQYmXngSt2jAPDx8tssaKEDGJcLilPlsOpMUK9XNvjw1xj7xUOT6JDVK+k/JwCejlG8YdELDWLZiNQgk0YEjLDXCnRUsROBu5MXCOX8D37mGY7XPzZjGhiw5s3g0EAcVd7qsclFK9XpOFsU8Y20u3yobhRqHocIJ9TR/tt112CfN4KJb4XC3UpDQXKVMwQGdB1GwUPmXRPajH7EpMTTJYOhot2HtfzHqM/M42gSnf3vm659mLkV8Z+e/EWWEARz50V/mm+uiTr2PyjvmJOl4tkFOYS9VuDGCRFZGOgh2+G9R3wkLtdbRC/m2MfpXyA55poRvZW+jw==";

  String pemPublicKey = GlobalConfiguration().getValue("public_key");

  try {
    RSAPublicKey publicKey = loadPublicKey(pemPublicKey);
    bool isVerified = verifySignature(data, signature, publicKey);
    print('Signature is valid: $isVerified');

    // Debug information
    print('\nDebug info:');
    print('Data hash (hex): ${hashSHA256(data).map((b) => b.toRadixString(16).padLeft(2, '0')).join('')}');
    print('Signature length: ${base64.decode(signature).length}');
  } catch (e) {
    print('Error: $e');
  }
}*/
