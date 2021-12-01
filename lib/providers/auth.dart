import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';

class AuthProvider with ChangeNotifier {
  final googleSignin = GoogleSignIn();
  GoogleSignInAccount? _googleSignInAccount;
  GoogleSignInAccount get googleSignInAccount => _googleSignInAccount!;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId;
  String? uid;
  bool isNew = false;
  List<String> admins = [];

  Future googleLogin() async {
    final googleUser = await googleSignin.signIn();
    if (googleUser == null) return;
    _googleSignInAccount = googleUser;
    final googleAuth = await _googleSignInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final userCredential = await auth.signInWithCredential(credential);
    isNew = userCredential.additionalUserInfo!.isNewUser;
    uid = userCredential.user!.uid;
    notifyListeners();
  }

  Future<bool> sendOTP(String phoneNumber) async {
    try {
      print(phoneNumber);
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            if (e.code == 'invalid-phone-number') showToast('msg');
          },
          codeSent: _codeSent,
          codeAutoRetrievalTimeout: (String verificationId) {},
          timeout: const Duration(seconds: 120));
      return true;
    } catch (e) {
      return false;
    }
  }

  void _codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
  }

  Future<bool> signInWithPhoneNumber(String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otp);
      final userCredential = await auth.signInWithCredential(credential);
      isNew = userCredential.additionalUserInfo!.isNewUser;
      uid = userCredential.user!.uid;

      notifyListeners();
      return true;
    } catch (e) {
      print('${e.toString()}');
    }
    notifyListeners();
    return false;
  }

  void getAdmins() {
    admins = UserSheetApi.admins;
  }

  bool isAdmin(String? email) {
    if (email == null) return false;
    return admins.contains(email);
  }

  Future<void> signOut() async {
    auth.authStateChanges().last.then((value) => print(value.toString()));

    return await auth.signOut();
  }
}
