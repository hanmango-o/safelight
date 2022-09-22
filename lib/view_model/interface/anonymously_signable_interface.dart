import 'package:safelight/view_model/interface/signable_interface.dart';

abstract class IAnonymouslySignable implements ISignable {
  Future<void> signInAnonymously();
  Future<void> signOutAnonymously();
}
