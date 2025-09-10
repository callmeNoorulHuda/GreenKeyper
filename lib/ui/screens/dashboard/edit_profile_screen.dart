// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';
import '../../../viewmodels/providers/profile_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../auth/login_screen.dart';
import '../auth/new_password_screen.dart';
import 'demo_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(profileProvider);
    //_fullNameController = TextEditingController(text: profile.fullName);
    //   _emailController = TextEditingController(text: profile.email);
    //   _contactController = TextEditingController(text: profile.contact);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF017B7B)),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await ref
                        .read(profileProvider.notifier)
                        .pickProfileImage(ImageSource.camera);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Failed to pick image. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Color(0xFF017B7B)),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await ref
                        .read(profileProvider.notifier)
                        .pickProfileImage(ImageSource.gallery);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Failed to pick image. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    ref.watch(profileSaveLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Icon(
            Icons.home,
            color: Color(0xFFE79F31),
            size: 30,
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1), // height of the line
          child: Container(
            color: Colors.grey[300], // color of the line
            height: 1,
          ),
        ),
        toolbarHeight: 80,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF017B7B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.logout,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Section
              Container(
                margin: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 20),
                      child: Stack(
                        children: [
                          Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withAlpha(255)),
                              image: profile.profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(profile.profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                              "assets/profile_default_image.png")
                                          as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE79F31),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          profile.email,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF006666),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              Container(
                height: 1, // thickness of the line
                color: Colors.grey[300], // color of the line
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40, top: 30),
                child: Column(
                  children: [
                    // Form Fields
                    CustomTextField(
                      label: 'Full Name',
                      hint: profile.fullName,
                      prefixIcon: Icons.person,
                      controller: _fullNameController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    CustomTextField(
                      label: 'Email',
                      hint: profile.email,
                      prefixIcon: Icons.email_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Email is required';
                        }
                        if (!value!.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    CustomTextField(
                      label: 'Contact',
                      hint: 'Enter your contact',
                      prefixIcon: Icons.phone,
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Contact is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    // Change Password Button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // background for the button
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25), // shadow color
                              blurRadius: 8, // softness of the shadow
                              offset:
                                  const Offset(0, 4), // how much shadow moves
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white, // must match container
                            elevation: 0, // we’ll handle shadow via BoxShadow
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NewPasswordScreen()),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lock, color: Color(0xFF017B7B)),
                              SizedBox(width: 12),
                              Text(
                                'Change password',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // background for the button
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withAlpha(25), // shadow color
                                  blurRadius: 8, // softness of the shadow
                                  offset: const Offset(
                                      0, 4), // how much shadow moves
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF006666), // must match container
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DemoScreen()),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // background for the button
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withAlpha(25), // shadow color
                                  blurRadius: 8, // softness of the shadow
                                  offset: const Offset(
                                      0, 4), // how much shadow moves
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.white, // must match container
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DemoScreen()),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
