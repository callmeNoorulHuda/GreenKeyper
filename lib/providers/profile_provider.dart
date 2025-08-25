// lib/providers/profile_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Profile Model
class UserProfile {
  final String fullName;
  final String email;
  final String contact;
  final File? profileImage;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.contact,
    this.profileImage,
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? contact,
    File? profileImage,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      contact: contact ?? this.contact,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

// Profile State Notifier
class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
      : super(
          UserProfile(
            fullName: 'Jane Cooper',
            email: 'janecooper@gmail.com',
            contact: '',
          ),
        );

  final ImagePicker _picker = ImagePicker();

  void updateFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateContact(String contact) {
    state = state.copyWith(contact: contact);
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        state = state.copyWith(profileImage: File(image.path));
      }
    } catch (e) {
      // Handle error - could emit to a separate error state
      throw Exception('Failed to pick image');
    }
  }

  Future<void> saveProfile() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // In real app, you would save to backend here
  }
}

// Provider
final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
  (ref) => ProfileNotifier(),
);

// Loading state for save operation
final profileSaveLoadingProvider = StateProvider<bool>((ref) => false);
