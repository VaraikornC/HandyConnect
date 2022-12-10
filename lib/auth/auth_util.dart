import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_util.dart';

import '../backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_transform/stream_transform.dart';
import 'firebase_user_provider.dart';

export 'anonymous_auth.dart';
export 'apple_auth.dart';
export 'email_auth.dart';
export 'google_auth.dart';
export 'jwt_token_auth.dart';

/// Tries to sign in or create an account using Firebase Auth.
/// Returns the User object if sign in was successful.
Future<User?> signInOrCreateAccount(
  BuildContext context,
  Future<UserCredential?> Function() signInFunc,
  String authProvider,
) async {
  try {
    final userCredential = await signInFunc();
    if (userCredential?.user != null) {
      await maybeCreateUser(userCredential!.user!);
    }
    return userCredential?.user;
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message!}')),
    );
    return null;
  }
}

///Sign out
Future signOut() {
  return FirebaseAuth.instance.signOut();
}

///Delete accout
Future deleteUser(BuildContext context) async {
  try {
    if (currentUser?.user == null) {
      print('Error: delete user attempted with no logged in user!');
      return;
    }

    ///Delete
    await currentUser?.user?.delete();

    ///Error while deleting account
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Too long since most recent sign in. Sign in again before deleting your account.')),
      );
    }
  }
}

///Reset password
Future resetPassword(
    {required String email, required BuildContext context}) async {
  try {
    ///Send password reset via email
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    ///While error
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message!}')),
    );
    return null;
  }

  ///Show text when successfully sending an email
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Password reset email sent')),
  );
}

///Email verification
Future sendEmailVerification() async =>
    currentUser?.user?.sendEmailVerification();

///Get user data
String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.user?.email ?? '';

String get currentUserUid => currentUser?.user?.uid ?? '';

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.user?.displayName ?? '';

String get currentUserPhoto =>
    currentUserDocument?.photoUrl ?? currentUser?.user?.photoURL ?? '';

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.user?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified {
  // Reloads the user when checking in order to get the most up to date
  // email verified status.
  if (currentUser?.user != null && !currentUser!.user!.emailVerified) {
    currentUser!.user!
        .reload()
        .then((_) => currentUser!.user = FirebaseAuth.instance.currentUser);
  }
  return currentUser?.user?.emailVerified ?? false;
}

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

// Set when using phone verification (after phone number is provided).
String? _phoneAuthVerificationCode;
// Set when using phone sign in in web mode (ignored otherwise).
ConfirmationResult? _webPhoneAuthConfirmationResult;

///Verify by phone number
Future beginPhoneAuth({
  required BuildContext context,
  required String phoneNumber,
  required VoidCallback onCodeSent,
}) async {
  if (kIsWeb) {
    _webPhoneAuthConfirmationResult =
        await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
    onCodeSent();
    return;
  }
  final completer = Completer<bool>();

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: Duration(seconds: 5),
    verificationCompleted: (phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    },
    verificationFailed: (e) {
      completer.complete(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.message!}'),
      ));
    },
    codeSent: (verificationId, _) {
      _phoneAuthVerificationCode = verificationId;
      completer.complete(true);
      onCodeSent();
    },
    codeAutoRetrievalTimeout: (_) {},
  );

  return completer.future;
}

///SMS verifying
Future verifySmsCode({
  required BuildContext context,
  required String smsCode,
}) async {
  if (kIsWeb) {
    return signInOrCreateAccount(
      context,
      () => _webPhoneAuthConfirmationResult!.confirm(smsCode),
      'PHONE',
    );
  } else {
    final authCredential = PhoneAuthProvider.credential(
        verificationId: _phoneAuthVerificationCode!, smsCode: smsCode);
    return signInOrCreateAccount(
      context,
      () => FirebaseAuth.instance.signInWithCredential(authCredential),
      'PHONE',
    );
  }
}

DocumentReference? get currentUserReference => currentUser?.user != null
    ? UsersRecord.collection.doc(currentUser!.user!.uid)
    : null;

UsersRecord? currentUserDocument;
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap(
      (uid) => uid.isEmpty
          ? Stream.value(null)
          : UsersRecord.getDocument(UsersRecord.collection.doc(uid))
              .handleError((_) {}),
    )
    .map((user) => currentUserDocument = user)
    .asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => child,
      );
}
