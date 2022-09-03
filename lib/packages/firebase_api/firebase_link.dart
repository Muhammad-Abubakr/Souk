import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// ignore: unnecessary_late
late final GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

// INTERMEDIARIES
Stream<User?> get user => FirebaseAuth.instance.userChanges();

// ? Authenticate With Google
Future<UserCredential> authWithGoogle() async => kIsWeb
    ? await FirebaseAuth.instance.signInWithPopup(_googleAuthProvider)
    : await FirebaseAuth.instance.signInWithAuthProvider(_googleAuthProvider);

// ? Verify that there is not any user with the same email and password
Future<UserCredential> signInWithEmailPassword(String email, String password) async =>
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

// ? Create a User with the given DisplayName, Email and Password
Future<UserCredential> signUpWithEmailPassword(
        String displayName, String email, String password) async =>
    await FirebaseAuth.instance
        // try and create a user with the given email and password
        .createUserWithEmailAndPassword(email: email, password: password)

        // then when the user is created update the users display name
        .then((userCredential) {
      userCredential.user?.updateDisplayName(displayName);
      return userCredential;
    });

// ?  Reset the user password
Future<void> resetPassword(String email) async =>
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

// ? Sign Out
void signOut() async =>
    // Sign out of firebase
    await FirebaseAuth.instance.signOut();
