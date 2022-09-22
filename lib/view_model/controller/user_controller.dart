import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:safelight/view_model/controller/auth_controller.dart';
import 'package:safelight/view_model/controller/sign_controller.dart';

class UserController extends GetxController {
  late SignController _signController;
  late AuthController _authController;

  UserController() {
    _signController = SignController();
    _authController = AuthController();
  }

  SignController get sign => _signController;
  AuthController get auth => _authController;
}
