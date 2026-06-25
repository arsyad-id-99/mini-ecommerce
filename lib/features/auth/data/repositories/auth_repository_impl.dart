import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
      debugPrint('Token found: $token');
      try {
        final user = await remoteDataSource.getCurrentUser(token);
        debugPrint('User fetched successfully: ${user?.username}');
        return user;
      } on DioException catch (e) {
        debugPrint(
            'Error fetching user: ${e.response?.data['message'] ?? e.message}');
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          await localDataSource.clearToken();
        }
        return null;
      } catch (e) {
        debugPrint('Unexpected error: $e');
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
