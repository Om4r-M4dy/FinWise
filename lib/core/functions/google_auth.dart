import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleAuth {
  static bool _initialized = false;

  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize();
      _initialized = true;
    }
  }

  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await _ensureInitialized();

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // Obtain the auth details (idToken)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Attempt to get access token if available without prompting, otherwise pass null
      final GoogleSignInClientAuthorization? authz = await googleUser
          .authorizationClient
          .authorizationForScopes(['email', 'profile']);

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authz?.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in with Google: $e')),
        );
      }
      return null;
    }
  }

  static Future<void> signOut() async {
    await _ensureInitialized();
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
