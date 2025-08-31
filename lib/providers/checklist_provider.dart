// lib/providers/checklist_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Checklist Item Model
class ChecklistItem {
  final int id;
  final String title;
  final bool isCompleted;
  final bool isFlagged; // New field for fault flag

  ChecklistItem({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.isFlagged = false,
  });

  ChecklistItem copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    bool? isFlagged,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isFlagged: isFlagged ?? this.isFlagged,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'isFlagged': isFlagged,
    };
  }

  // Create from JSON
  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      isFlagged: json['isFlagged'] ?? false,
    );
  }
}

// Simplified Checklist State
class ChecklistState {
  final List<ChecklistItem> items;
  final String defectDetails;
  final List<File> uploadedImages;
  final String signature;
  final bool isSubmitting;

  ChecklistState({
    required this.items,
    required this.defectDetails,
    required this.uploadedImages,
    required this.signature,
    this.isSubmitting = false,
  });

  ChecklistState copyWith({
    List<ChecklistItem>? items,
    String? defectDetails,
    List<File>? uploadedImages,
    String? signature,
    bool? isSubmitting,
  }) {
    return ChecklistState(
      items: items ?? this.items,
      defectDetails: defectDetails ?? this.defectDetails,
      uploadedImages: uploadedImages ?? this.uploadedImages,
      signature: signature ?? this.signature,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

// Simplified Checklist Notifier
class ChecklistNotifier extends StateNotifier<ChecklistState> {
  ChecklistNotifier() : super(_createInitialState()) {
    _loadFromSharedPreferences();
  }

  final ImagePicker _picker = ImagePicker();

  static ChecklistState _createInitialState() {
    return ChecklistState(
      items: _getInitialItems(),
      defectDetails: '',
      uploadedImages: [],
      signature: '',
      isSubmitting: false,
    );
  }

  static List<ChecklistItem> _getInitialItems() {
    return [
      ChecklistItem(
        id: 1,
        title: 'Place Dock/Deck Mats at Nostalgia.',
        isCompleted: false,
      ),
      ChecklistItem(
        id: 2,
        title: 'Switch the Shore Power Dock Station Breakers right to "off."',
        isCompleted: false,
      ),
      ChecklistItem(
        id: 3,
        title:
            'Remove the Shore Power Cord & store properly on the Shore Power Dock Station.',
        isCompleted: false,
      ),
      ChecklistItem(
        id: 4,
        title:
            'Rotate all Three (3) Battery Selectors to "on" with the (1,1,2) Configuration.',
        isCompleted: false,
      ),
      ChecklistItem(
        id: 5,
        title:
            'Store all Instrument/Stereo Covers properly on the top shelf of the Cabin.',
        isCompleted: false,
      ),
      ChecklistItem(
        id: 6,
        title:
            'Switch "Air/Cooler Pump", "Cabin Air" and "Helm Air" Breakers left to "off."',
        isCompleted: false,
      ),
      ChecklistItem(
        id: 7,
        title:
            'Time Beverages with fresh water that Helm Air Breakers left to "off."',
        isCompleted: false,
      ),
      ChecklistItem(
        id: 8,
        title:
            'Switch "Air/Cooler Pump", "Cabin Air" and "Helm Air" Breakers left to "off."',
        isCompleted: false,
      ),
    ];
  }

  // Load checklist data from SharedPreferences
  Future<void> _loadFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? checklistData = prefs.getString('checklist_data');

      if (checklistData != null) {
        final Map<String, dynamic> data = json.decode(checklistData);
        final List<dynamic> itemsJson = data['items'] ?? [];

        final List<ChecklistItem> loadedItems =
            itemsJson.map((item) => ChecklistItem.fromJson(item)).toList();

        state = state.copyWith(
          items: loadedItems,
          defectDetails: data['defectDetails'] ?? '',
          signature: data['signature'] ?? '',
        );
      }
    } catch (e) {
      print('Error loading checklist from SharedPreferences: $e');
    }
  }

  // Save checklist data to SharedPreferences
  Future<void> _saveToSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> data = {
        'items': state.items.map((item) => item.toJson()).toList(),
        'defectDetails': state.defectDetails,
        'signature': state.signature,
      };

      await prefs.setString('checklist_data', json.encode(data));

      // Update fault counts
      final flaggedItems = state.items.where((item) => item.isFlagged).length;
      final resolvedItems = state.items
          .where((item) => item.isFlagged && item.isCompleted)
          .length;
      final pendingItems = flaggedItems - resolvedItems;

      await prefs.setInt('resolved_faults', resolvedItems);
      await prefs.setInt('pending_faults', pendingItems);
    } catch (e) {
      print('Error saving checklist to SharedPreferences: $e');
    }
  }

  void toggleItem(int itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    _saveToSharedPreferences();
  }

  void toggleFlag(int itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isFlagged: !item.isFlagged);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    _saveToSharedPreferences();
  }

  void updateDefectDetails(String details) {
    state = state.copyWith(defectDetails: details);
    _saveToSharedPreferences();
  }

  void updateSignature(String signature) {
    state = state.copyWith(signature: signature);
    _saveToSharedPreferences();
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final List<File> newImages =
            images.map((image) => File(image.path)).toList();
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
        final List<File> allImages = [
          ...state.uploadedImages,
          File(image.path)
        ];

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
      await Future.delayed(const Duration(seconds: 2));

      // In real app, you would submit to backend here
      print('Checklist submitted successfully');
      print('Signature: ${state.signature}');
      print('Notes: ${state.defectDetails}');
      print('Images: ${state.uploadedImages.length}');
      print(
          'Flagged items: ${state.items.where((item) => item.isFlagged).length}');

      // Clear SharedPreferences after successful submission
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('checklist_data');
    } catch (e) {
      print('Error submitting checklist: $e');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  void resetChecklist() {
    state = _createInitialState();
    _clearSharedPreferences();
  }

  Future<void> _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('checklist_data');
    await prefs.setInt('resolved_faults', 0);
    await prefs.setInt('pending_faults', 0);
  }
}

// Provider
final checklistProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>(
  (ref) => ChecklistNotifier(),
);
