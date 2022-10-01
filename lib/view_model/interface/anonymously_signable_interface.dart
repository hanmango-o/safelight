import 'package:safelight/view_model/interface/signable_interface.dart';

abstract class IAnonymouslySignable extends ISignable {
  Future<void> signInAnonymously();
  Future<void> signOutAnonymously();
}
