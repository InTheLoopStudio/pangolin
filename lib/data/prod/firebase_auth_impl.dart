import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;
final _analytics = FirebaseAnalytics.instance;
final usersRef = _fireStore.collection('users');

extension on User {
  Future<UserModel> get toUserModel async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await usersRef.doc(uid).get();
    UserModel user = UserModel.fromDoc(userSnapshot);

    return user;
  }
}

String _generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String _sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class FirebaseAuthImpl extends AuthRepository {
  Stream<UserModel> get authUserChanges =>
      _auth.authStateChanges().asyncMap((firebaseUser) async {
        final UserModel user = firebaseUser == null
            ? UserModel.empty
            : await firebaseUser.toUserModel;

        return user;
      });
  // ignore: close_sinks
  StreamController<UserModel> manualUserUpdates = StreamController.broadcast();

  Stream<UserModel> get user {
    return MergeStream([authUserChanges, manualUserUpdates.stream]);
  }

  Future<void> updateUserData({required UserModel userData}) async {
    manualUserUpdates.sink.add(userData);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  @override
  Future<String> getAuthUserId() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }

    return '';
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    User? signedInUser = authResult.user;

    if (signedInUser != null) {
      _analytics.logEvent(name: 'sign_in', parameters: {'provider': 'Google'});
      _analytics.setUserId(id: signedInUser.uid);
      return UserModel.empty.copyWith(
        id: signedInUser.uid,
        email: signedInUser.email ?? '',
        username: signedInUser.displayName ?? 'anonymous',
        profilePicture: signedInUser.photoURL ?? '',
      );
    }

    return UserModel.empty;
  }

  @override
  Future<void> reauthenticateWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Reauthenticate
    _auth.currentUser?.reauthenticateWithCredential(credential);
  }

  @override
  Future<UserModel> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.intheloopstudio.intheloopapp',
        redirectUri: Uri.parse(
          'https://in-the-loop-306520.firebaseapp.com/__/auth/handler',
        ),
      ),
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final UserCredential authResult =
        await _auth.signInWithCredential(oauthCredential);

    User? signedInUser = authResult.user;

    if (signedInUser != null) {
      _analytics.logEvent(name: 'sign_in', parameters: {'provider': 'Apple'});
      _analytics.setUserId(id: signedInUser.uid);
      return UserModel.empty.copyWith(
        id: signedInUser.uid,
        email: signedInUser.email ?? '',
      );
    }

    return UserModel.empty;
  }

  @override
  Future<void> reauthenticateWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.intheloopstudio.intheloopapp',
        redirectUri: Uri.parse(
          'https://in-the-loop-306520.firebaseapp.com/__/auth/handler',
        ),
      ),
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    _auth.currentUser?.reauthenticateWithCredential(oauthCredential);
  }

  @override
  Future<void> logout() async {
    try {
      _auth.signOut();
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  Future<void> recoverPassword({String email = ''}) async {
    _auth.sendPasswordResetEmail(email: email);
    return;
  }

  @override
  Future<void> deleteUser() async {
    try {
      _analytics.logEvent(name: 'delete_user');
      _auth.currentUser?.delete();
    } catch (e) {
      print(e);
    }
  }
}
