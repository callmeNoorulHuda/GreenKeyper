// lib/screens/checklist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenkeyper/widgets/common/custom_button.dart';
import '../../providers/checklist_provider.dart';

class ChecklistScreen extends ConsumerStatefulWidget {
  const ChecklistScreen({super.key});

  @override
  ConsumerState<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends ConsumerState<ChecklistScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _defectController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final checklist = ref.read(checklistProvider);
    _defectController.text = checklist.defectDetails;
    _signatureController.text = checklist.signature;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _defectController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      width: double.infinity,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF006666),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDropdown() {
    final checklist = ref.watch(checklistProvider);

    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25), // shadow color
                blurRadius: 8, // softness
                offset: const Offset(0, 4), // vertical offset
              ),
            ],
          ),
          child: DropdownButton<Vehicle>(
            dropdownColor: Colors.white,
            value: null,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            hint: const Text(
              'Select Assigned Vehicle',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF282828),
                fontWeight: FontWeight.w500,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            items: checklist.availableVehicles.map((Vehicle vehicle) {
              return DropdownMenuItem<Vehicle>(
                value: vehicle,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_car,
                            color: Color(0xFF17A2B8), size: 18),
                        const SizedBox(width: 8),
                        Text('${vehicle.name} - ${vehicle.number}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (Vehicle? newValue) {
              if (newValue != null) {
                ref.read(checklistProvider.notifier).selectVehicle(newValue);
              }
            },
          ),
        ),
        // Show selected vehicle below dropdown
        if (checklist.selectedVehicle != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF2FBFB),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car,
                  color: Color(0xFF006666),
                  size: 22,
                ),
                const SizedBox(width: 60),
                Text(
                  '${checklist.selectedVehicle!.name} - ${checklist.selectedVehicle!.number}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChecklistItem(ChecklistItem item, int originalIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$originalIndex',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Yes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              ref.read(checklistProvider.notifier).toggleItem(item.id);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: item.isCompleted
                    ? const Color(0xFF17A2B8)
                    : Colors.transparent,
                border: Border.all(
                  color: item.isCompleted
                      ? const Color(0xFF17A2B8)
                      : Colors.grey[400]!,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: item.isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefectDetailsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Defect Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _defectController,
            maxLines: 3,
            onChanged: (value) {
              ref.read(checklistProvider.notifier).updateDefectDetails(value);
            },
            decoration: InputDecoration(
              hintText: 'Enter Defect details here...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF17A2B8), width: 1),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadImagesSection() {
    final checklist = ref.watch(checklistProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Images',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Upload Button
          GestureDetector(
            onTap: () {
              ref.read(checklistProvider.notifier).pickImages();
            },
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: Color(0xFF17A2B8),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Upload Image Here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Display uploaded images
          if (checklist.uploadedImages.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: checklist.uploadedImages.asMap().entries.map((entry) {
                int index = entry.key;
                var image = entry.value;

                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(checklistProvider.notifier)
                              .removeImage(index);
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Signature',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _signatureController,
            onChanged: (value) {
              ref.read(checklistProvider.notifier).updateSignature(value);
            },
            decoration: InputDecoration(
              hintText: 'Add Signature Here',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF17A2B8),
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF17A2B8), width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checklist = ref.watch(checklistProvider);
    final filteredItems =
        ref.watch(filteredItemsProvider); // Watch filtered items

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp,
              size: 25, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFFE79F31),
              size: 25,
            ),
            SizedBox(width: 8),
            Text(
              'Checklist - ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Beginning of Day',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Bar Section
          Container(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: _buildProgressBar(checklist.progress)),
                    const SizedBox(width: 10),
                    Text(
                      '${(checklist.progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25), // shadow color
                  blurRadius: 8, // softness
                  offset: const Offset(0, 4), // vertical offset
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                ref.read(checklistProvider.notifier).searchChecklist(value);
              },
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search in Checklist',
                hintStyle: const TextStyle(
                  color: Color(0xFF282828),
                  fontSize: 14,
                ),
                suffixIcon: Icon(Icons.search, color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.white, // same as container bg
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // remove default border
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 0),

          // Vehicle Selection Dropdown
          Container(
            child: _buildVehicleDropdown(),
          ),

          const SizedBox(height: 8),

          // Checklist Items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Mandatory Beginning of Day Procedure',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Display filtered checklist items
                  ...filteredItems.map((item) {
                    // Find original index for display
                    int originalIndex = checklist.items.indexWhere(
                            (originalItem) => originalItem.id == item.id) +
                        1;
                    return _buildChecklistItem(item, originalIndex);
                  }),

                  // Show message if no items found
                  if (filteredItems.isEmpty && checklist.searchQuery.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try different search terms',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Only show these sections if not searching or if search is empty
                  if (checklist.searchQuery.isEmpty) ...[
                    // Defect Details Section
                    _buildDefectDetailsSection(),

                    // Upload Images Section
                    _buildUploadImagesSection(),

                    // Signature Section
                    _buildSignatureSection(),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 80),
                      child: CustomButton(
                        text: 'Submit',
                        onPressed: () async {
                          await ref
                              .read(checklistProvider.notifier)
                              .submitChecklist();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Checklist submitted successfully!'),
                                backgroundColor: Color(0xFF17A2B8),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        isLoading: checklist.isSubmitting,
                        width: double.infinity,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
