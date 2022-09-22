import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:safelight/asset/resource/auth_resource.dart';
import 'package:safelight/view_model/controller/user_controller.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get getAuth => _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
