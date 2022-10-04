// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/auth_resource.dart';
import 'package:safelight/asset/resource/sign_resource.dart';
import 'package:safelight/view_model/implement/anonymously_sign_impl.dart';
import 'package:safelight/view_model/implement/bluetooth_permission_authorized_impl.dart';
import 'package:safelight/view_model/implement/location_permission_authorized_impl.dart';

class UserController extends GetxController {
  late _SignController _signController;
  late _AuthController _authController;

  UserController() {
    _signController = _SignController();
    _authController = _AuthController();
  }

  _SignController get sign => _signController;
  _AuthController get auth => _authController;
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
