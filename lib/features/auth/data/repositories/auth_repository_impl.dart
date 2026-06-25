import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login(String username, String password) async {
    final userModel = await remoteDataSource.login(username, password);
    await localDataSource.saveToken(userModel.token);
    return userModel;
  }

  @override
  Future<UserEntity?> checkAuthStatus() async {
    final token = await localDataSource.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        final userModel = await remoteDataSource.getCurrentUser(token);
        return userModel;
      } catch (e) {
        await localDataSource.clearToken();
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }
}
