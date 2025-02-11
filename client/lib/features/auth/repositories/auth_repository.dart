import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexdoor/core/theme/color_pallete.dart';
import 'package:nexdoor/features/auth/models/user.dart';
import 'package:nexdoor/features/user_profile/repositories/user_repository.dart';
import 'package:toastification/toastification.dart';

// Contains Firebase Authentication handling functions and token initialisation
// **Firebase functions --- Signing in -- Signing up -- Firebase Signout -- Firebase id generation -- email verification --  Reset password
// **Other functions --- Credential clearing and Log out -- Token intialisation
// **Firebase error handling function
class AuthService {
// instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
// Sign in
  Future<bool> signin(String email, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      notifier("Login successful", isSuccess: true);
      return true;
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
      return false;
    }
  }

  get checkLogin{
    var user = _auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

//Sign up
  Future<bool> signUp(String email, String pass,UserModel user) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      UserDataService us = UserDataService();
      bool status = await us.addUser(user: user);
      notifier("Welcome $email", isSuccess: status);
      return status;
      // userCredential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
      return false;
    }
  }

//Firebase Sign out - done at first itself to avoid unneccessary calls from firebase service inApp
  Future<void> fsignOut() async {
    await _auth.signOut();
  }

// Email verification
  verification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        try {
          if (!_auth.currentUser!.emailVerified) {
            _auth.currentUser?.sendEmailVerification();
          } else {
            UserDataService us = UserDataService();
            us.updateUser({'isVerified': _auth.currentUser?.emailVerified});
          }
        } on FirebaseAuthException catch (e) {
          handleFirebaseAuthError(e);
        }
        return AlertDialog(
          title: const Text(
            'Email verification',
            style: TextStyle(
                fontSize: 20,
               ),
          ),
          content: const Text(
            "An email has been sent to your mail,\nCheck your inbox for verification link",
            style: TextStyle(
                fontSize: 16,
                ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 3),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Center(child: Text(
                    'OK',
                    style: TextStyle(
                        ),
                ),
              ),
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  // Check verification
  bool get checkVerification {
    try {
      if (_auth.currentUser!.emailVerified) {
        UserDataService us = UserDataService();
        us.updateUser({'isVerified': true});
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
      throw (400);
    }
  }

// Get token
  Future<String?> getId() async {
    try {
      String? token = await _auth.currentUser?.getIdToken();
      return token;
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
      throw Exception(e.code);
    }
  }

// Password Resetting
  void resetPassword(String mail) async {
    try {
      await _auth.sendPasswordResetEmail(email: mail);
      notifier("Check your mail inbox for password updating link");
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    }
  }

// Account deletion
  Future<bool> deleteAccount(BuildContext context) async {
    try {
      return true;
    } catch (e, s) {
      errorNotifier("Account deletion unsucceessful", e, s);
      return false;
    }
  }

// errors
  void handleFirebaseAuthError(FirebaseAuthException error) {
    String errorMessage = "";
    if (error.code == 'email-already-in-use') {
      errorMessage =
          'The email address has already been registered, try logging in.';
    } else if (error.code == 'channel-error') {
      errorMessage = "Invalid credentials";
    } else if (error.code == 'invalid-email') {
      errorMessage = 'The email address is invalid.';
    } else if (error.code == 'operation-not-allowed') {
      errorMessage =
          'Email/password sign-in is not allowed,please contact us for further measures.';
    } else if (error.code == 'wrong-password') {
      errorMessage = 'The password seems to be weak or incorrect.';
    } else if (error.code == 'network-request-failed') {
      errorMessage =
          'There is a problem with the internet connection or server communication.';
    } else if (error.code == 'user-not-found') {
      errorMessage =
          'The email address does not correspond to an existing account.';
    } else if (error.code == 'invalid-credential') {
      errorMessage =
          'Provided email and password does not match each other\nplease try again';
    } else if (error.code == 'user-disabled') {
      errorMessage = 'The user\'s account has been disabled.';
    } else if (error.code == 'too-many-requests') {
      errorMessage =
          'There have been too many failed sign-in attempts. Try again later.';
    } else {
      errorMessage = "Error occurred: ${error.code}";
    }
    notifier(errorMessage, isError: true);
  }
}

// Showing toast
notifier(String message,
    {bool isSuccess = false, bool isError = false, bool isWarning = false}) {
  if (isSuccess) {
    toastification.show(
      primaryColor: ColorPalette.primaryText.withValues(alpha: 0.4),
      backgroundColor: ColorPalette.primaryColor,
      foregroundColor: ColorPalette.primaryText,
        title: const Text("Success!"),
        description: Text(message),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success);
  } else if (isError) {
    toastification.show(
      primaryColor: ColorPalette.error.withValues(alpha: 0.4),
      backgroundColor: ColorPalette.primaryColor,
      foregroundColor: ColorPalette.error,
        title: const Text("Error!"),
        description: Text(message),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.flatColored,
        type: ToastificationType.error);
  } else if (isWarning) {
    toastification.show(
      primaryColor: ColorPalette.secondaryText.withValues(alpha: 0.4),
      backgroundColor: ColorPalette.primaryColor,
      foregroundColor: ColorPalette.secondaryText,
        title: const Text("Warning!"),
        description: Text(message),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.flatColored,
        type: ToastificationType.warning);
  } else {
    toastification.show(
      primaryColor: ColorPalette.primaryText.withValues(alpha: 0.4),
      backgroundColor: ColorPalette.primaryColor,
      foregroundColor: ColorPalette.primaryText,
        title: const Text("!!"),
        description: Text(message),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.flatColored,
        type: ToastificationType.info);
  }
  log("🟩Notifier - $message");
}

errorNotifier(String errorPoint, e, s) async {
  log("🟩Error notifier $errorPoint - $e");
}
