import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/sign_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/view_model/controller/user_controller.dart';
import 'package:safelight/view_model/implement/anonymously_sign_impl.dart';
import 'package:safelight/view_model/interface/anonymously_signable_interface.dart';

class SignController with AnonymouslySignImpl {
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
