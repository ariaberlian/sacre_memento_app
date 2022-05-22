import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LoginApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
          localizedReason: 'Prove you\'re worthy!',
          options: const AuthenticationOptions(useErrorDialogs: false, stickyAuth: true),
          );
    // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      return false;
    }
  }
}
