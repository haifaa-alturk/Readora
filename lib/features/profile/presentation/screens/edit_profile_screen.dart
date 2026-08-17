import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_event.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_state.dart';
import 'package:library_app1/features/profile/domain/entities/profile_entity.dart';

// const String _profileImageBaseUrl = 'http://127.0.0.1:8000/storage/';
const String _profileImageBaseUrl = 'http://192.168.90.2:8000/storage/';

bool _isLocalImagePath(String path) {
  return path.startsWith('/') ||
      path.startsWith('file://') ||
      RegExp(r'^[A-Za-z]:[\\/]').hasMatch(path);
}

String _resolveProfileImageUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  final normalized = path.startsWith('/') ? path.substring(1) : path;
  return '$_profileImageBaseUrl$normalized';
}

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _picker = ImagePicker();
  File? _pickedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    context.read<ProfileBloc>().add(
      UpdateProfileRequested(
        newName: _nameController.text.trim(),
        newEmail: _emailController.text.trim(),
        newImage: _pickedImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: const Text(
                'Edit Profile',
              
              ),
            ),
            body: BlocConsumer<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  _isSaving &&
                  (current is ProfileLoaded || current is ProfileUpdateError),
              listener: (context, state) {
                setState(() => _isSaving = false);
                if (state is ProfileLoaded) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                    ),
                  );
                } else if (state is ProfileUpdateError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 52,
                                      backgroundColor: const Color(0xfff9aabf),
                                      child: ClipOval(
                                        child: _buildAvatarContent(),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final file = await _picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 85,
                                          );
                                          if (file != null) {
                                            setState(() {
                                              _pickedImage = File(file.path);
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(
                                            color: Color(0xfff9aabf),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                          
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _nameController,
                               
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: const TextStyle(
                                 
                                  ),
                                  filled: true,
                                  fillColor:
                                   const Color.fromARGB(120, 250, 219, 251),
                              
          
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color(
                                        0xff2d2d2d,
                                      ).withValues(alpha: 0.12),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color(
                                        0xff2d2d2d,
                                      ).withValues(alpha: 0.12),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffe61b72),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(
                                 
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                  
                                  ),
                                  filled: true,
                                  fillColor:    const Color.fromARGB(120, 250, 219, 251),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color(
                                        0xff2d2d2d,
                                      ).withValues(alpha: 0.12),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 45, 45, 45).withValues(alpha: 0.12),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffe61b72),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email cannot be empty';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _save,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffe61b72),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAvatarContent() {
    const double diameter = 104;
    final initial = widget.profile.name.isNotEmpty
        ? widget.profile.name[0].toUpperCase()
        : '?';

    if (_pickedImage != null) {
      return Image.file(
        _pickedImage!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
      );
    }

    final profilePath = widget.profile.imagePath;
    if (profilePath == null || profilePath.trim().isEmpty) {
      return SizedBox(
        width: diameter,
        height: diameter,
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
             
            ),
          ),
        ),
      );
    }

    if (_isLocalImagePath(profilePath)) {
      return Image.file(
        File(profilePath),
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      _resolveProfileImageUrl(profilePath),
      width: diameter,
      height: diameter,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: diameter,
          height: diameter,
          child: const Center(
            child: Icon(
              Icons.person,
              size: 42,
             
            ),
          ),
        );
      },
    );
  }
}
