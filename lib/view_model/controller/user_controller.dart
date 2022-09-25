import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:safelight/asset/resource/sign_resource.dart';
import 'package:safelight/view_model/controller/auth_controller.dart';
import 'package:safelight/view_model/controller/sign_controller.dart';
import 'package:safelight/view_model/implement/anonymously_sign_impl.dart';

class UserController extends GetxController {
  late _SignController _signController;
  late AuthController _authController;

  UserController() {
    _signController = _SignController();
    _authController = AuthController();
  }

  _SignController get sign => _signController;
  AuthController get auth => _authController;
}

class _SignController with AnonymouslySignImpl {
  Future<void> signIn(SignType type, {String? id, String? pw}) async {
    switch (type) {
      case SignType.anonymously:
        Get.showOverlay(
          asyncFunction: () => super.signInAnonymously(),
          loadingWidget: Center(child: CircularProgressIndicator()),
        );
        break;
    }
  }

  Future<void> signOut(SignType type) async {
    switch (type) {
      case SignType.anonymously:
        Get.showOverlay(
          asyncFunction: () => super.signOutAnonymously(),
          loadingWidget: Center(child: CircularProgressIndicator()),
        );
        break;
    }
  }
}
