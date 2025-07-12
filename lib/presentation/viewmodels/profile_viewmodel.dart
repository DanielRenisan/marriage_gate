import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileViewModel {
  final String name;
  final String age;
  final String gender;
  final String religion;
  final String caste;
  final String bio;
  final String? photoUrl;
  final bool isVerified;
  final bool isLoading;
  final String? nameError;
  final String? ageError;
  final String? religionError;
  final String? casteError;
  final String? bioError;
  final String? errorMessage;

  const ProfileViewModel({
    this.name = '',
    this.age = '',
    this.gender = 'Male',
    this.religion = '',
    this.caste = '',
    this.bio = '',
    this.photoUrl,
    this.isVerified = false,
    this.isLoading = false,
    this.nameError,
    this.ageError,
    this.religionError,
    this.casteError,
    this.bioError,
    this.errorMessage,
  });

  ProfileViewModel copyWith({
    String? name,
    String? age,
    String? gender,
    String? religion,
    String? caste,
    String? bio,
    String? photoUrl,
    bool? isVerified,
    bool? isLoading,
    String? nameError,
    String? ageError,
    String? religionError,
    String? casteError,
    String? bioError,
    String? errorMessage,
  }) {
    return ProfileViewModel(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      isVerified: isVerified ?? this.isVerified,
      isLoading: isLoading ?? this.isLoading,
      nameError: nameError,
      ageError: ageError,
      religionError: religionError,
      casteError: casteError,
      bioError: bioError,
      errorMessage: errorMessage,
    );
  }
}

class ProfileViewModelNotifier extends StateNotifier<ProfileViewModel> {
  ProfileViewModelNotifier() : super(const ProfileViewModel());

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final religionController = TextEditingController();
  final casteController = TextEditingController();
  final bioController = TextEditingController();

  void onNameChanged(String value) {
    state = state.copyWith(name: value, nameError: null, errorMessage: null);
  }
  void onAgeChanged(String value) {
    state = state.copyWith(age: value, ageError: null, errorMessage: null);
  }
  void onGenderChanged(String? value) {
    if (value != null) {
      state = state.copyWith(gender: value, errorMessage: null);
    }
  }
  void onReligionChanged(String value) {
    state = state.copyWith(religion: value, religionError: null, errorMessage: null);
  }
  void onCasteChanged(String value) {
    state = state.copyWith(caste: value, casteError: null, errorMessage: null);
  }
  void onBioChanged(String value) {
    state = state.copyWith(bio: value, bioError: null, errorMessage: null);
  }

  Future<void> onChangePhoto() async {
    // TODO: Implement image picker and upload
    state = state.copyWith(errorMessage: 'Photo upload not implemented');
  }

  Future<void> onSave() async {
    // Simple validation
    if (state.name.isEmpty) {
      state = state.copyWith(nameError: 'Enter your name');
      return;
    }
    if (state.age.isEmpty || int.tryParse(state.age) == null) {
      state = state.copyWith(ageError: 'Enter a valid age');
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // TODO: Call use case to update profile
      await Future.delayed(const Duration(seconds: 2)); // Simulate network
      // On success, show success or update state
    } catch (e) {
      state = state.copyWith(errorMessage: 'Save failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    religionController.dispose();
    casteController.dispose();
    bioController.dispose();
    super.dispose();
  }
}

final profileViewModelProvider = StateNotifierProvider<ProfileViewModelNotifier, ProfileViewModel>((ref) {
  return ProfileViewModelNotifier();
}); 