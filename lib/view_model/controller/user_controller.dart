// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/auth_resource.dart';
import 'package:safelight/asset/resource/sign_resource.dart';
import 'package:safelight/view_model/implement/sign/anonymously_sign_impl.dart';

import '../implement/permission/bluetooth_permission_authorized_impl.dart';
import '../implement/permission/location_permission_authorized_impl.dart';

class UserController extends GetxController {
  late _SignController _signController;
  late _AuthController _authController;
  late _SettingController _settingController;

  UserController() {
    _signController = _SignController();
    _authController = _AuthController();
    _settingController = _SettingController();
  }

  _SignController get sign => _signController;
  _AuthController get auth => _authController;
  _SettingController get setting => _settingController;
}

class _AuthController
    with BluetoothPermissionAuthorizedImpl, LocationPermissionAuthorizedImpl {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get getAuth => _auth;

  Stream<bool> get getBlueStream => super.checkBluePermission();
  Stream<bool> get getLocationStream => super.checkLocationPermission();

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> permissionAuthorized(PermissionType type) async {
    switch (type) {
      case PermissionType.bluetooth:
        await super.blueAuthorized();
        break;
      case PermissionType.location:
        await super.locationAuthorized();
        break;
    }
  }
}

class _SignController with AnonymouslySignImpl {
  Future<void> signIn(SignType type, {String? id, String? pw}) async {
    switch (type) {
      case SignType.anonymously:
        Get.showOverlay(
          asyncFunction: () => super.signInAnonymously(),
          loadingWidget: const Center(child: CircularProgressIndicator()),
        );
        break;
    }
  }

  Future<void> signOut(SignType type) async {
    switch (type) {
      case SignType.anonymously:
        Get.showOverlay(
          asyncFunction: () => super.signOutAnonymously(),
          loadingWidget: const Center(child: CircularProgressIndicator()),
        );
        break;
    }
  }
}

class _SettingController {
  Rx<String> mode = ''.obs;

  setMode(String mode) {
    switch (ThemeMode.values.byName(mode)) {
      case ThemeMode.system:
        mode = '시스템 설정';
        break;
      case ThemeMode.light:
        mode = '라이트 모드';
        break;
      case ThemeMode.dark:
        mode = '다크 모드';
        break;
    }
  }
}
