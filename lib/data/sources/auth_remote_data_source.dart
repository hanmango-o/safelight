import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/exceptions.dart';

/// [AuthRemoteDataSource]는 사용자 인증(로그인/로그아웃)과 관련된 기능을 수행한다.
///
/// 모든 사용자 인증은 [FirebaseAuth]를 사용하며,
///
/// ---
/// ## Functions
/// [AuthRemoteDataSource]는 아래의 메소드를 호출하여 기능을 수행할 수 있다.
///
/// |기능||설명|
/// |:-------|-|:--------|
/// |[signInAnonymously]||FirebaseAuth를 통한 익명 로그인|
/// |[signOutAnonymously]||FirebaseAuth를 통한 익명 로그아웃|
abstract class AuthRemoteDataSource {
  Future<void> signInAnonymously();
  Future<void> signOutAnonymously();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  FirebaseAuth auth;

  AuthRemoteDataSourceImpl({required this.auth});

  @override
  Future<void> signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOutAnonymously() async {
    try {
      // await auth.currentUser!.delete();
      await auth.signOut();
    } catch (e) {
      throw ServerException();
    }
  }
}
