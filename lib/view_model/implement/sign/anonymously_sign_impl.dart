import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:safelight/view_model/interface/anonymously_signable_interface.dart';

class AnonymouslySignImpl implements IAnonymouslySignable {
  @override
  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> signOutAnonymously() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }
}
