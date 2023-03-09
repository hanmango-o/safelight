part of data_source;

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
      await auth.signOut();
    } catch (e) {
      throw ServerException();
    }
  }
}
