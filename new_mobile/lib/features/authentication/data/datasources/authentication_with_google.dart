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
  // if (googleSignInAccount != null) {
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );

  //   print('googleIdToken: ${googleSignInAuthentication.idToken}');

  //   try {
  //     final UserCredential userCredential =
  //         await auth.signInWithCredential(credential);

  //     print('userCredential: ${userCredential}');

  //     user = userCredential.user;
  //     if (user != null) {
  //       print('token: ${await user.getIdToken()}');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'account-exists-with-different-credential') {
  //       throw SignInWithGoogleException(
  //         errorMessage: 'Account exists with different credential',
  //       );
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   customSnackBar(
  //       //     content: 'The account already exists with a different credential',
  //       //   ),
  //       // );
  //     } else if (e.code == 'invalid-credential') {
  //       throw SignInWithGoogleException(errorMessage: 'Invalid credential');
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   customSnackBar(
  //       //     content: 'Error occurred while accessing credentials. Try again.',
  //       //   ),
  //       // );
  //     }
  //   } catch (e) {
  //     throw SignInWithGoogleException(errorMessage: e.toString());
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   customSnackBar(
  //     //     content: 'Error occurred using Google Sign In. Try again.',
  //     //   ),
  //     // );
  //   }
  // }

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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   customSnackBar(
      //     content: 'Error signing out. Try again.',
      //   ),
      // );
    }
  }

  // static SnackBar customSnackBar({required String content}) {
  //   return SnackBar(
  //     backgroundColor: Colors.black,
  //     content: Text(
  //       content,
  //       style: GoogleFonts.poppins(
  //         color: Colors.redAccent,
  //         letterSpacing: 0.5,
  //       ),
  //     ),
  //   );
  // }
}
