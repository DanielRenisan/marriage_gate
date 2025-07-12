import '../repositories/profile_repository.dart';
import '../entities/user.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getProfile();
  }
} 