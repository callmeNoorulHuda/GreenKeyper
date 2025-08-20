// lib/providers/checklist_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Checklist Item Model
class ChecklistItem {
  final int id;
  final String title;
  final bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  ChecklistItem copyWith({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Checklist State Model
class ChecklistState {
  final String vehicleName;
  final String vehicleNumber;
  final List<ChecklistItem> items;
  final String defectDetails;
  final List<File> uploadedImages;
  final String signature;
  final bool isSubmitting;
  final double progress;

  ChecklistState({
    required this.vehicleName,
    required this.vehicleNumber,
    required this.items,
    required this.defectDetails,
    required this.uploadedImages,
    required this.signature,
    required this.isSubmitting,
    required this.progress,
  });

  ChecklistState copyWith({
    String? vehicleName,
    String? vehicleNumber,
    List<ChecklistItem>? items,
    String? defectDetails,
    List<File>? uploadedImages,
    String? signature,
    bool? isSubmitting,
    double? progress,
  }) {
    return ChecklistState(
      vehicleName: vehicleName ?? this.vehicleName,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      items: items ?? this.items,
      defectDetails: defectDetails ?? this.defectDetails,
      uploadedImages: uploadedImages ?? this.uploadedImages,
      signature: signature ?? this.signature,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      progress: progress ?? this.progress,
    );
  }
}

// Checklist Notifier
class ChecklistNotifier extends StateNotifier<ChecklistState> {
  ChecklistNotifier()
      : super(ChecklistState(
    vehicleName: 'Suzuki Cultus',
    vehicleNumber: 'BKX 2245',
    items: _getInitialItems(),
    defectDetails: '',
    uploadedImages: [],
    signature: '',
    isSubmitting: false,
    progress: 0.8, // 80% completion
  ));

  final ImagePicker _picker = ImagePicker();

  static List<ChecklistItem> _getInitialItems() {
    return [
      ChecklistItem(id: 1, title: 'Place Dock/Deck Mats at Nostalgia.', isCompleted: true),
      ChecklistItem(id: 2, title: 'Switch the Shore Power Dock Station Breakers right to "off."', isCompleted: true),
      ChecklistItem(id: 3, title: 'Remove the Shore Power Cord & store properly on the Shore Power Dock Station.', isCompleted: true),
      ChecklistItem(id: 4, title: 'Rotate all Three (3) Battery Selectors to "on" with the (1,1,2) Configuration.', isCompleted: true),
      ChecklistItem(id: 5, title: 'Store all Instrument/Stereo Covers properly on the top shelf of the Cabin.', isCompleted: true),
      ChecklistItem(id: 6, title: 'Switch the Shore Power Dock Station Breakers right to "off."', isCompleted: true),
      ChecklistItem(id: 7, title: 'Switch "Air/Cooler Pump", "Cabin Air" and "Helm Air" Breakers left to "off."', isCompleted: true),
      ChecklistItem(id: 8, title: 'Remove the Shore Power Cord & store properly on the Shore Power Dock Station.', isCompleted: false),
    ];
  }

  void toggleItem(int itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    // Calculate progress
    final completedCount = updatedItems.where((item) => item.isCompleted).length;
    final progress = completedCount / updatedItems.length;

    state = state.copyWith(items: updatedItems, progress: progress);
  }

  void updateDefectDetails(String details) {
    state = state.copyWith(defectDetails: details);
  }

  void updateSignature(String signature) {
    state = state.copyWith(signature: signature);
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final List<File> newImages = images.map((image) => File(image.path)).toList();
        final List<File> allImages = [...state.uploadedImages, ...newImages];
        state = state.copyWith(uploadedImages: allImages);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final List<File> allImages = [...state.uploadedImages, File(image.path)];
        state = state.copyWith(uploadedImages: allImages);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void removeImage(int index) {
    final List<File> updatedImages = List.from(state.uploadedImages);
    updatedImages.removeAt(index);
    state = state.copyWith(uploadedImages: updatedImages);
  }

  Future<void> submitChecklist() async {
    state = state.copyWith(isSubmitting: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));

      // In real app, you would submit to backend here
      print('Checklist submitted successfully');

    } catch (e) {
      print('Error submitting checklist: $e');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

// Provider
final checklistProvider = StateNotifierProvider<ChecklistNotifier, ChecklistState>(
      (ref) => ChecklistNotifier(),
);