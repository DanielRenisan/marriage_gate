import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignInUseCase(repo);
});

final authProvider = StateProvider<AuthState>((ref) => AuthState.unauthenticated);

enum AuthState { unauthenticated, authenticating, authenticated } 