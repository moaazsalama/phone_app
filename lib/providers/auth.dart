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
  UserCredential? userCredential;
  Future<bool> googleLogin() async {
    try {
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) return false;
      _googleSignInAccount = googleUser;
      final googleAuth = await _googleSignInAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      userCredential = await auth.signInWithCredential(credential);
      isNew = userCredential!.additionalUserInfo!.isNewUser;
      uid = userCredential!.user!.uid;
      notifyListeners();
      return true;

      // ignore: empty_catches
    } on Exception {}
    return false;
  }

  Future<bool> sendOTP(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (e) {
            if (e.code == 'invalid-phone-number') showToast('msg');
          },
          codeSent: _codeSent,
          timeout: const Duration(seconds: 120),
          codeAutoRetrievalTimeout: (String verificationId) {});
      print('sended');
      return true;
    } catch (e) {
      print('verify phone ${e.toString()}');
      return false;
    }
  }

  void _codeSent(String verificationId, int? resendToken) {
    print(verificationId);
    this.verificationId = verificationId;
  }

  Future<bool> signInWithPhoneNumber(String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otp);
      print(credential.toString());
      userCredential = await auth.signInWithCredential(credential);
      isNew = userCredential!.additionalUserInfo!.isNewUser;
      uid = userCredential!.user!.uid;
      notifyListeners();
      return true;
    } catch (e) {
      print('${e.toString()} signInWithPhoneNumber');
    }
    notifyListeners();
    return false;
  }

  void getAdmins() {
    admins = UserSheetApi.admins;
  }

  void clear() {
    this.isNew = false;
    this.uid = null;
    this.verificationId = null;
    notifyListeners();
  }

  Future<bool> isAdmin(String? email) async {
    if (email == null) return false;
    final list = await UserSheetApi.fetchAdmins();
    return list!.contains(email);
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on Exception catch (e) {
      print('${e.toString()} signOut');
    }

    clear();
  }
}
