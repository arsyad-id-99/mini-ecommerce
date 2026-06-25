import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mini_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:mini_ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:mini_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:mini_ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';

// 1. Buat Mock Repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;

  // Data dummy untuk test
  const tUsername = 'testuser';
  const tPassword = 'password123';
  const tUserEntity = UserEntity(
    id: 1,
    username: tUsername,
    email: 'test@example.com',
    token: 'dummy_token_123',
  );

  // setUp dijalankan sebelum setiap fungsi test() dieksekusi
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(mockAuthRepository);
  });

  // tearDown dijalankan setelah setiap fungsi test() selesai
  tearDown(() {
    authBloc.close();
  });

  // 2. Test Initial State
  test('initial state harus AuthInitial', () {
    expect(authBloc.state, equals(AuthInitial()));
  });

  // 3. Group Test untuk Event LoginRequested
  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'harus emit [AuthLoading, AuthSuccess] ketika login berhasil',
      build: () {
        // Atur behavior mock: ketika repository.login dipanggil, kembalikan tUserEntity
        when(() => mockAuthRepository.login(tUsername, tPassword))
            .thenAnswer((_) async => tUserEntity);
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(tUsername, tPassword)),
      expect: () => [
        AuthLoading(),
        const AuthSuccess(tUserEntity),
      ],
      verify: (_) {
        // Verifikasi bahwa fungsi login pada repository benar-benar dipanggil 1 kali
        verify(() => mockAuthRepository.login(tUsername, tPassword)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'harus emit [AuthLoading, AuthFailure] ketika login gagal',
      build: () {
        // Atur behavior mock: ketika repository.login dipanggil, lempar Exception
        when(() => mockAuthRepository.login(tUsername, tPassword))
            .thenThrow(Exception('Invalid credentials'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(tUsername, tPassword)),
      expect: () => [
        AuthLoading(),
        const AuthFailure('Exception: Invalid credentials'),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.login(tUsername, tPassword)).called(1);
      },
    );
  });
}
