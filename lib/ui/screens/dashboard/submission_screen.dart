// lib/screens/submission_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../viewmodels/providers/checklist_provider.dart';
import '../../widgets/common/custom_button.dart';

class SubmissionScreen extends ConsumerStatefulWidget {
  const SubmissionScreen({super.key});

  @override
  ConsumerState<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends ConsumerState<SubmissionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _signatureController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final checklist = ref.read(checklistProvider);
    _signatureController.text = checklist.signature;
    _notesController.text = checklist.defectDetails;
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> canSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF4A9B8E)),
      ),
    );

    await ref.read(checklistProvider.notifier).submitChecklist();

    Navigator.pop(context);
    _showSuccessDialog();
  }

  Widget _buildInputSection(
      {required String title,
      required String hintText,
      required TextEditingController controller,
      required Function(String) onChanged,
      bool required = false,
      bool signature = false,
      int maxLines = 1,
      final String? Function(String?)? validator}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                signature
                    ? Image.asset(
                        "assets/signature_icon.png",
                        height: 35,
                        width: 35,
                      )
                    : Image.asset(
                        "assets/add_note_icon.png",
                        height: 35,
                        width: 35,
                      ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  required ? '(Required)' : '(Optional)',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: TextFormField(
                validator: validator,
                controller: controller,
                onChanged: onChanged,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF4A9B8E), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding: EdgeInsets.all(maxLines > 1 ? 16 : 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    final checklist = ref.watch(checklistProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/add_image_icon.png",
                  height: 35,
                  width: 35,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add Images',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '(Optional)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                //color: Colors.white,
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                    //style: BorderStyle.dashed,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: checklist.uploadedImages.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                              onTap: () {
                                _showImagePickerOptions();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    dashPattern: const [6, 3],
                                    color:
                                        const Color(0xFF4A9B8E).withAlpha(77),
                                    strokeWidth: 2,
                                    radius: const Radius.circular(12),
                                  ),
                                  child: Container(
                                      width: 140,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_rounded,
                                              size: 40,
                                              color: Color(0xFF4A9B8E),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '    Click to upload \n          image',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF4A9B8E),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ])),
                                ),
                              ));
                        }
                        final image = checklist.uploadedImages[index - 1];
                        return Stack(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: 170,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: const Color(0xFF4A9B8E).withAlpha(77),
                                  width: 1,
                                ),
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
                                    .removeImage(index - 1);
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ]);
                      }),
                ),
              ),
            ),
          ],
        ),
      ),

      // Upload area
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(checklistProvider.notifier).pickSingleImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A9B8E).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Color(0xFF4A9B8E),
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Camera',
                              style: TextStyle(
                                color: Color(0xFF4A9B8E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(checklistProvider.notifier).pickImages();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A9B8E).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: Color(0xFF4A9B8E),
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                color: Color(0xFF4A9B8E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final checklist = ref.watch(checklistProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF057B99),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/submission_icon.png",
              height: 33,
              width: 33,
            ),
            const SizedBox(width: 14),
            const Text(
              'Submission',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          //padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // Signature section (required)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildInputSection(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Signature is required';
                    }
                    return null;
                  },
                  signature: true,
                  title: 'Add Signature',
                  hintText: 'Add Signature here',
                  controller: _signatureController,
                  onChanged: (value) {
                    ref.read(checklistProvider.notifier).updateSignature(value);
                    setState(() {}); // Update submit button state
                  },
                  required: true,
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xFFD9D9D9),
                height: 1,
              ),

              // Notes section (optional)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildInputSection(
                  title: 'Add Note',
                  hintText: 'Enter Defect details here...',
                  controller: _notesController,
                  onChanged: (value) {
                    ref
                        .read(checklistProvider.notifier)
                        .updateDefectDetails(value);
                  },
                  maxLines: 3,
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xFFD9D9D9),
                height: 1,
              ),

              // Image upload section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildImageUploadSection(),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xFFD9D9D9),
                height: 1,
              ),

              const SizedBox(height: 20),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(
                  text: 'Submit',
                  onPressed: canSubmit,
                  width: double.infinity,
                  height: 50,
                  isLoading: checklist.isSubmitting,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success checkmark
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B8E).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4A9B8E),
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Checklist submitted!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Your checklist has been successfully submitted and saved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: 'Done',
                  onPressed: () {
                    // Close dialog and navigate back to previous screens
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close submission screen
                    Navigator.of(context).pop(); // Close checklist screen
                  },
                  gradientColors: const [
                    Color(0xFF4A9B8E),
                    Color(0xFF4A9B8E),
                  ],
                  width: double.infinity,
                  height: 45,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
