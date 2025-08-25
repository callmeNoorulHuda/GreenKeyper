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

// Vehicle Model
class Vehicle {
  final String id;
  final String name;
  final String number;

  Vehicle({
    required this.id,
    required this.name,
    required this.number,
  });

  // Add equality and hashCode overrides
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          number == other.number;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ number.hashCode;

  @override
  String toString() => '$name - $number';
}

// Vehicle Checklist Data - stores checklist state for each vehicle
class VehicleChecklistData {
  final List<ChecklistItem> items;
  final String defectDetails;
  final List<File> uploadedImages;
  final String signature;
  final double progress;

  VehicleChecklistData({
    required this.items,
    required this.defectDetails,
    required this.uploadedImages,
    required this.signature,
    required this.progress,
  });

  VehicleChecklistData copyWith({
    List<ChecklistItem>? items,
    String? defectDetails,
    List<File>? uploadedImages,
    String? signature,
    double? progress,
  }) {
    return VehicleChecklistData(
      items: items ?? this.items,
      defectDetails: defectDetails ?? this.defectDetails,
      uploadedImages: uploadedImages ?? this.uploadedImages,
      signature: signature ?? this.signature,
      progress: progress ?? this.progress,
    );
  }
}

// Checklist State Model
class ChecklistState {
  final List<Vehicle> availableVehicles;
  final Vehicle? selectedVehicle;
  final Map<String, VehicleChecklistData> vehicleData; // Store data per vehicle
  final bool isSubmitting;
  final String searchQuery;

  ChecklistState({
    required this.availableVehicles,
    this.selectedVehicle,
    required this.vehicleData,
    this.isSubmitting = false,
    this.searchQuery = "",
  });

  // Get current vehicle's data
  VehicleChecklistData? get currentVehicleData =>
      selectedVehicle != null ? vehicleData[selectedVehicle!.id] : null;

  // Get current items (for current selected vehicle)
  List<ChecklistItem> get items => currentVehicleData?.items ?? [];

  // Get current progress
  double get progress => currentVehicleData?.progress ?? 0.0;

  // Get current defect details
  String get defectDetails => currentVehicleData?.defectDetails ?? '';

  // Get current uploaded images
  List<File> get uploadedImages => currentVehicleData?.uploadedImages ?? [];

  // Get current signature
  String get signature => currentVehicleData?.signature ?? '';

  ChecklistState copyWith({
    List<Vehicle>? availableVehicles,
    Vehicle? selectedVehicle,
    Map<String, VehicleChecklistData>? vehicleData,
    bool? isSubmitting,
    String? searchQuery,
  }) {
    return ChecklistState(
      availableVehicles: availableVehicles ?? this.availableVehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      vehicleData: vehicleData ?? this.vehicleData,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Checklist Notifier
class ChecklistNotifier extends StateNotifier<ChecklistState> {
  ChecklistNotifier() : super(_createInitialState());

  final ImagePicker _picker = ImagePicker();

  static ChecklistState _createInitialState() {
    final vehicles = _getAvailableVehicles();
    final vehicleData = _initializeVehicleData(vehicles);

    return ChecklistState(
      availableVehicles: vehicles,
      selectedVehicle: vehicles.first,
      vehicleData: vehicleData,
      isSubmitting: false,
      searchQuery: "",
    );
  }

  static List<Vehicle> _getAvailableVehicles() {
    return [
      Vehicle(id: '1', name: 'Suzuki Cultus', number: 'BKX 2245'),
      Vehicle(id: '2', name: 'Toyota Corolla', number: 'ABC 1234'),
      Vehicle(id: '3', name: 'Honda Civic', number: 'XYZ 5678'),
      Vehicle(id: '4', name: 'Nissan Sunny', number: 'DEF 9876'),
    ];
  }

  // Store vehicles as a static list to ensure same instances
  static final List<Vehicle> _vehicles = _getAvailableVehicles();

  static List<ChecklistItem> _getInitialItems() {
    return [
      ChecklistItem(
          id: 1,
          title: 'Place Dock/Deck Mats at Nostalgia.',
          isCompleted: true),
      ChecklistItem(
          id: 2,
          title: 'Switch the Shore Power Dock Station Breakers right to "off."',
          isCompleted: true),
      ChecklistItem(
          id: 3,
          title:
              'Remove the Shore Power Cord & store properly on the Shore Power Dock Station.',
          isCompleted: true),
      ChecklistItem(
          id: 4,
          title:
              'Rotate all Three (3) Battery Selectors to "on" with the (1,1,2) Configuration.',
          isCompleted: true),
      ChecklistItem(
          id: 5,
          title:
              'Store all Instrument/Stereo Covers properly on the top shelf of the Cabin.',
          isCompleted: true),
      ChecklistItem(
          id: 6,
          title: 'Switch the Shore Power Dock Station Breakers right to "off."',
          isCompleted: true),
      ChecklistItem(
          id: 7,
          title:
              'Switch "Air/Cooler Pump", "Cabin Air" and "Helm Air" Breakers left to "off."',
          isCompleted: true),
      ChecklistItem(
          id: 8,
          title:
              'Remove the Shore Power Cord & store properly on the Shore Power Dock Station.',
          isCompleted: false),
    ];
  }

  // Initialize data for all vehicles
  static Map<String, VehicleChecklistData> _initializeVehicleData(
      List<Vehicle> vehicles) {
    Map<String, VehicleChecklistData> vehicleData = {};

    for (Vehicle vehicle in vehicles) {
      // Create different initial states for different vehicles for demo
      final items = _getInitialItems();
      int completedCount = 0;

      // Give different vehicles different completion states
      switch (vehicle.id) {
        case '1': // Suzuki Cultus - 88% (7/8 completed)
          completedCount = 7;
          break;
        case '2': // Toyota Corolla - 75% (6/8 completed)
          completedCount = 6;
          for (int i = 6; i < 8; i++) {
            items[i] = items[i].copyWith(isCompleted: false);
          }
          break;
        case '3': // Honda Civic - 50% (4/8 completed)
          completedCount = 4;
          for (int i = 4; i < 8; i++) {
            items[i] = items[i].copyWith(isCompleted: false);
          }
          break;
        case '4': // Nissan Sunny - 100% (8/8 completed)
          completedCount = 8;
          items[7] = items[7].copyWith(isCompleted: true);
          break;
      }

      vehicleData[vehicle.id] = VehicleChecklistData(
        items: items,
        defectDetails: '',
        uploadedImages: [],
        signature: '',
        progress: completedCount / items.length,
      );
    }

    return vehicleData;
  }

  void selectVehicle(Vehicle vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
  }

  void toggleItem(int itemId) {
    if (state.selectedVehicle == null) return;

    final currentData = state.currentVehicleData!;
    final updatedItems = currentData.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    // Calculate progress
    final completedCount =
        updatedItems.where((item) => item.isCompleted).length;
    final progress = completedCount / updatedItems.length;

    // Update the specific vehicle's data
    final updatedVehicleData =
        Map<String, VehicleChecklistData>.from(state.vehicleData);
    updatedVehicleData[state.selectedVehicle!.id] = currentData.copyWith(
      items: updatedItems,
      progress: progress,
    );

    state = state.copyWith(vehicleData: updatedVehicleData);
  }

  void updateDefectDetails(String details) {
    if (state.selectedVehicle == null) return;

    final currentData = state.currentVehicleData!;
    final updatedVehicleData =
        Map<String, VehicleChecklistData>.from(state.vehicleData);
    updatedVehicleData[state.selectedVehicle!.id] = currentData.copyWith(
      defectDetails: details,
    );

    state = state.copyWith(vehicleData: updatedVehicleData);
  }

  void updateSignature(String signature) {
    if (state.selectedVehicle == null) return;

    final currentData = state.currentVehicleData!;
    final updatedVehicleData =
        Map<String, VehicleChecklistData>.from(state.vehicleData);
    updatedVehicleData[state.selectedVehicle!.id] = currentData.copyWith(
      signature: signature,
    );

    state = state.copyWith(vehicleData: updatedVehicleData);
  }

  Future<void> pickImages() async {
    if (state.selectedVehicle == null) return;

    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final List<File> newImages =
            images.map((image) => File(image.path)).toList();
        final currentData = state.currentVehicleData!;
        final List<File> allImages = [
          ...currentData.uploadedImages,
          ...newImages
        ];

        final updatedVehicleData =
            Map<String, VehicleChecklistData>.from(state.vehicleData);
        updatedVehicleData[state.selectedVehicle!.id] = currentData.copyWith(
          uploadedImages: allImages,
        );

        state = state.copyWith(vehicleData: updatedVehicleData);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> pickSingleImage() async {
    if (state.selectedVehicle == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final currentData = state.currentVehicleData!;
        final List<File> allImages = [
          ...currentData.uploadedImages,
          File(image.path)
        ];

        final updatedVehicleData =
            Map<String, VehicleChecklistData>.from(state.vehicleData);
        updatedVehicleData[state.selectedVehicle!.id] = currentData.copyWith(
          uploadedImages: allImages,
        );

        state = state.copyWith(vehicleData: updatedVehicleData);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void removeImage(int index) {
    if (state.selectedVehicle == null) return;

    final currentData = state.currentVehicleData!;
    final List<File> updatedImages = List.from(currentData.uploadedImages);
    updatedImages.removeAt(index);

    final updatedVehicleData =
        Map<String, VehicleChecklistData>.from(state.vehicleData);
    updatedVehicleData[state.selectedVehicle!.id] = currentData.copyWith(
      uploadedImages: updatedImages,
    );

    state = state.copyWith(vehicleData: updatedVehicleData);
  }

  Future<void> submitChecklist() async {
    state = state.copyWith(isSubmitting: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));

      // In real app, you would submit to backend here
      print(
          'Checklist submitted successfully for ${state.selectedVehicle?.name}');
    } catch (e) {
      print('Error submitting checklist: $e');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  void searchChecklist(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

// Provider
final checklistProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>(
  (ref) => ChecklistNotifier(),
);

final filteredItemsProvider = Provider<List<ChecklistItem>>((ref) {
  final state = ref.watch(checklistProvider);
  if (state.searchQuery.isEmpty) return state.items;

  return state.items
      .where((item) =>
          item.title.toLowerCase().contains(state.searchQuery.toLowerCase()))
      .toList();
});
