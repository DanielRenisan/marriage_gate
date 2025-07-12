import '../repositories/profile_repository.dart';

class UploadProfilePhotoUseCase {
  final ProfileRepository repository;
  UploadProfilePhotoUseCase(this.repository);

  Future<void> call(String path) async {
    await repository.uploadProfilePhoto(path);
  }
} 