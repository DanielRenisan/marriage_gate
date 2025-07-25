import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final clientTokenProvider = FutureProvider<String?>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  final token = await authRepository.getClientToken();
  return token;
});
