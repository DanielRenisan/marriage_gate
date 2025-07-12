import '../repositories/profile_repository.dart';
import '../entities/user.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<void> call(User user) async {
    await repository.updateProfile(user);
  }
} 