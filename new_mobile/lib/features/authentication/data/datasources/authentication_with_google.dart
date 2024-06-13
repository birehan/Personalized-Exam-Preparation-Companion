import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/core.dart';

class AuthenticationWithGoogle {
  static Future<String?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication authentication =
            await googleSignInAccount.authentication;
        final String? idToken = authentication.idToken;
        return idToken;
      }
      return null; // Return null if Google sign-in fails
    } catch (e) {
      print(e.toString());
      throw SignInWithGoogleException(errorMessage: e.toString());
    }
  }

  static Future<bool> isAuthenticatedWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      return true;
    }
    return false;
  }

  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw SignInWithGoogleException(errorMessage: e.toString());
    }
  }

}
