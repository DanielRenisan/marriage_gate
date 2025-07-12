import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    final notifier = ref.read(profileViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (viewModel.isVerified)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.verified, color: Colors.blue),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: viewModel.photoUrl != null
                      ? NetworkImage(viewModel.photoUrl!)
                      : null,
                  child: viewModel.photoUrl == null
                      ? const Icon(Icons.person, size: 48)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: notifier.onChangePhoto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: const OutlineInputBorder(),
                errorText: viewModel.nameError,
              ),
              controller: notifier.nameController,
              onChanged: notifier.onNameChanged,
              enabled: !viewModel.isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Age',
                border: const OutlineInputBorder(),
                errorText: viewModel.ageError,
              ),
              controller: notifier.ageController,
              keyboardType: TextInputType.number,
              onChanged: notifier.onAgeChanged,
              enabled: !viewModel.isLoading,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: viewModel.gender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: viewModel.isLoading ? null : notifier.onGenderChanged,
              decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Religion',
                border: const OutlineInputBorder(),
                errorText: viewModel.religionError,
              ),
              controller: notifier.religionController,
              onChanged: notifier.onReligionChanged,
              enabled: !viewModel.isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Caste',
                border: const OutlineInputBorder(),
                errorText: viewModel.casteError,
              ),
              controller: notifier.casteController,
              onChanged: notifier.onCasteChanged,
              enabled: !viewModel.isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bio',
                border: const OutlineInputBorder(),
                errorText: viewModel.bioError,
              ),
              controller: notifier.bioController,
              maxLines: 3,
              onChanged: notifier.onBioChanged,
              enabled: !viewModel.isLoading,
            ),
            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: viewModel.isLoading ? null : notifier.onSave,
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 