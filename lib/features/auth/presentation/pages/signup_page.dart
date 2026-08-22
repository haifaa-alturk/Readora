import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:library_app1/features/auth/data/models/Category_Model.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_state.dart';
import 'package:library_app1/features/home/presentation/pages/main_screen.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_event.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  File? _image;

  List<CategoryModel> categories = [];
  List<int> selectedInterests = [];
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(GetCategoriesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signupp.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black45, blurRadius: 4),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: Colors.white24,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : null,
                              child: _image == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 28,
                                    )
                                  : null,
                            ),
                          ),

                          const SizedBox(height: 15),

                          _buildField(_nameController, "Name", Icons.person),

                          _buildField(_emailController, "Email", Icons.email),

                          _buildField(
                            _passwordController,
                            "Password",
                            Icons.lock,
                            isPass: true,
                          ),

                          _buildField(
                            _confirmController,
                            "Confirm Password",
                            Icons.lock_outline,
                            isPass: true,
                          ),

                          const SizedBox(height: 5),

                          InkWell(
                            onTap: _showInterestsSheet,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    189,
                                    113,
                                    239,
                                  ).withOpacity(0.6),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Color.fromARGB(
                                          255,
                                          189,
                                          187,
                                          189,
                                        ),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        isLoadingCategories
                                            ? "Loading Categories..."
                                            : selectedInterests.isEmpty
                                            ? "Select Interests"
                                            : "${selectedInterests.length} Selected",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isLoadingCategories)
                                    const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color.fromARGB(255, 234, 7, 255),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is CategoriesLoaded) {
                                setState(() {
                                  categories = state.categories;
                                  isLoadingCategories = false;
                                });
                              } else if (state is AuthSuccess) {
                                context.read<ProfileBloc>().add(
                                  const LoadProfileEvent(),
                                );

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 206, 125, 239),
                                );
                              }

                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    246,
                                    244,
                                    216,
                                    240,
                                  ),
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _onRegisterPressed,
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a profile image")),
      );
      return;
    }

    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one interest")),
      );
      return;
    }

    String? fcmToken;

    try {
      fcmToken = await FirebaseMessaging.instance.getToken();

      debugPrint("FCM Token: $fcmToken");
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
    }

    if (!mounted) return;

    context.read<AuthBloc>().add(
      RegisterEvent(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmController.text.trim(),
        interests: selectedInterests,
        imagePath: _image?.path,
        fcmToken: fcmToken,
      ),
    );
  }

  void _showInterestsSheet() {
    if (isLoadingCategories) {
      return;
    }

    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Categories still loading or empty...")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Choose Your Interests",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: categories.map((cat) {
                          final isSelected = selectedInterests.contains(cat.id);

                          return FilterChip(
                            label: Text(
                              cat.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : const Color.fromARGB(255, 255, 0, 195),
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (val) {
                              setSheetState(() {
                                if (val) {
                                  if (!selectedInterests.contains(cat.id)) {
                                    selectedInterests.add(cat.id);
                                  }
                                } else {
                                  selectedInterests.remove(cat.id);
                                }
                              });

                              setState(() {});
                            },
                            selectedColor: const Color.fromARGB(
                              255,
                              218,
                              165,
                              239,
                            ),
                            checkmarkColor: Colors.black,
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 163, 248),
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPass = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPass,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }

          if (hint == "Email" && !_isValidEmail(value)) {
            return "Enter a valid email";
          }

          if (hint == "Password" && value.length < 8) {
            return "Min 8 characters";
          }

          if (hint == "Confirm Password" && value != _passwordController.text) {
            return "Passwords do not match";
          }

          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 219, 211, 219),
            size: 20,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.35),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 197, 7, 255),
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
          errorStyle: const TextStyle(
            color: Colors.amberAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
