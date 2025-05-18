import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;

  static Future<String?> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await auth.currentUser?.updateDisplayName(name);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('Another account exists with this email.\nTry signing in instead?');
      } else {
        log('catch: $e');
        return ('Something went wrong');
      }
    } catch (e) {
      log('catch: $e');
      await auth.currentUser!.delete();
      return ('Something went wrong');
    }
  }

  static Future<String?> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('We do not have an account with that email.');
      } else if (e.code == 'wrong-password') {
        return ('Password is incorrect');
      } else if (e.code == 'invalid-credential') {
        log(e.code.toString());
        return ('Email or password is incorrect');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return ('Email or password is incorrect');
      } else {
        log('else: $e');
        return ('Something went wrong');
      }
    } catch (e) {
      log('catch: $e');
      return ('Something went wrong');
    }
  }

  static Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is invalid.';
      }
    } catch (e) {
      //
    }

    return 'An error occurred, please try again.';
  }

  static Future<String?> signOut() async {
    try {
      await auth.signOut();
      return null;
    } catch (e) {
      log('catch: $e');
      return ('Something went wrong');
    }
  }
}
