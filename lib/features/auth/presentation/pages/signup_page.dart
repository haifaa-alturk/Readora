// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:library_app1/features/auth/presentation/bloc/auth_state.dart';
// import 'package:library_app1/features/home/presentation/pages/home_page.dart';
// import 'dart:ui';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmController = TextEditingController();
  
//   File? _image;
//   // اهتمامات تجريبية (يُفضل جلبها من السيرفر لاحقاً)
//   final List<Map<String, dynamic>> categories = [
//     {'id': 1, 'name': 'Literature'},
//     {'id': 2, 'name': 'Horror'},
//     {'id': 3, 'name': 'History'},
//     {'id': 4, 'name': 'science'},
//     {'id': 5, 'name': 'sports'},
//     {'id': 6,'name': 'romance'},
//     {'id': 7,'name': 'fantasy'},
//     {'id': 8,'name': 'education'},

//   ];
//   List<int> selectedInterests = [];

//   Future _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) setState(() => _image = File(pickedFile.path));
//   }

// // دالة التحقق من صحة الإيميل باستخدام RegExp
//   bool _isValidEmail(String email) {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // الخلفية (استخدمي نفس صورتك)
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(image: AssetImage('assets/images/signupp.jpg'), fit: BoxFit.cover),
//             ),
//           ),
//           Center(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
//                         SizedBox(height: 20),
//                         // اختيار الصورة
//                         GestureDetector(
//                           onTap: _pickImage,
//                           child: CircleAvatar(
//                             radius: 40,
//                             backgroundColor: Colors.white24,
//                             backgroundImage: _image != null ? FileImage(_image!) : null,
//                             child: _image == null ? Icon(Icons.camera_alt, color: Colors.white) : null,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         _buildField(_nameController, "Name", Icons.person),
//                         _buildField(_emailController, "Email", Icons.email),
//                         _buildField(_passwordController, "Password", Icons.lock, isPass: true),
//                         _buildField(_confirmController, "Confirm Password", Icons.lock_outline, isPass: true),
//                         SizedBox(height: 15),
//                         Text("Interests", style: TextStyle(color: Colors.white70)),
//                         // Wrap(
//                         //   spacing: 8,
//                         //   children: categories.map((cat) {
//                         //     return FilterChip(
//                         //       label: Text(cat['name']),
//                         //       selected: selectedInterests.contains(cat['id']),
//                         //       onSelected: (val) {
//                         //         setState(() {
//                         //           val ? selectedInterests.add(cat['id']) : selectedInterests.remove(cat['id']);
//                         //         });
//                         //       },
//                         //     );
//                         //   }).toList(),
//                         // ),
//                         // ... داخل الـ Column
// // SizedBox(height: 15),

// // // تغليف الاهتمامات بـ Theme لتغيير لون الأيقونة والنص داخل القائمة المنسدلة
// // Theme(
// //   data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // لإزالة الخط الفاصل
// //   child: ExpansionTile(
// //     leading: const Icon(Icons.favorite, color: Colors.amber, size: 20),
// //     title: const Text(
// //       "Select Your Interests",
// //       style: TextStyle(color: Colors.white, fontSize: 14),
// //     ),
// //     subtitle: Text(
// //       "${selectedInterests.length} Selected",
// //       style: const TextStyle(color: Colors.white54, fontSize: 12),
// //     ),
// //     children: [
// //       Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //         decoration: BoxDecoration(
// //           color: Colors.white.withOpacity(0.05),
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Wrap(
// //           spacing: 8,
// //           runSpacing: 4,
// //           children: categories.map((cat) {
// //             final isSelected = selectedInterests.contains(cat['id']);
// //             return FilterChip(
// //               label: Text(
// //                 cat['name'],
// //                 style: TextStyle(
// //                   color: isSelected ? Colors.black : Colors.white,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //               selected: isSelected,
// //               selectedColor: Colors.amber,
// //               checkmarkColor: Colors.black,
// //               backgroundColor: Colors.white12,
// //               onSelected: (val) {
// //                 setState(() {
// //                   val 
// //                     ? selectedInterests.add(cat['id']) 
// //                     : selectedInterests.remove(cat['id']);
// //                 });
// //               },
// //             );
// //           }).toList(),
// //         ),
// //       ),
// //     ],
// //   ),
// // ),


// // // ... كملي باقي الكود (زر التسجيل)
// // ... داخل الـ Column
// const SizedBox(height: 15),
// InkWell(
//   onTap: _showInterestsSheet,
//   child: Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(0.05),
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.white.withOpacity(0.1)),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.favorite, color: Colors.amber, size: 20),
//             const SizedBox(width: 10),
//             Text(
//               selectedInterests.isEmpty 
//                   ? "Select Interests" 
//                   : "${selectedInterests.length} Interests Selected",
//               style: const TextStyle(color: Colors.white, fontSize: 14),
//             ),
//           ],
//         ),
//         const Icon(Icons.arrow_drop_down, color: Colors.white54),
//       ],
//     ),
//   ),
// ),
// const SizedBox(height: 25),
// // ... زر الـ Register
//                         SizedBox(height: 25),
//                         // زر التسجيل مع الـ Bloc
//                         BlocConsumer<AuthBloc, AuthState>(
//   listener: (context, state) {
//     if (state is AuthSuccess) {
//       // 1. طباعة للتأكد من أننا وصلنا لهنا
//       print("Navigation to Home triggered!");

//       // 2. الانتقال فوراً للهوم
//       Navigator.pushAndRemoveUntil(
//         context, 
//         MaterialPageRoute(builder: (context) => HomePage()),
//         (route) => false, // يحذف كل الصفحات السابقة (Login, Register)
//       );
//     } else if (state is AuthError) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//       );
//     }
//   },
 
//   //                       BlocConsumer<AuthBloc, AuthState>(
//   //                         listener: (context, state) {
//   //                           // if (state is AuthSuccess) {
//   //                           //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success!")));
//   //                           //   // انتقلي للشاشة الرئيسية هنا
//   //                           // } else if (state is AuthError) {
//   //                           //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
//   //                           if (state is AuthSuccess) {
//   //   // إذا نجح: اذهب للهوم
//   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
//   // } else if (state is AuthError) {
//   //   // إذا فشل (مثل إيميل مكرر): اظهر الرسالة للمستخدم
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //       content: Text(state.message), // ستظهر هنا رسالة "The email has already been taken"
//   //       backgroundColor: Colors.red,
//   //     ),
//   //   );
//   //                           }
//   //                         },
//                           builder: (context, state) {
//                             if (state is AuthLoading) return CircularProgressIndicator();
//                             return ElevatedButton(
//                               style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: Size(double.infinity, 45)),
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   context.read<AuthBloc>().add(RegisterEvent(
//                                     name: _nameController.text,
//                                     email: _emailController.text,
//                                     password: _passwordController.text,
//                                     confirmPassword: _confirmController.text,
//                                     interests: selectedInterests,
//                                     imagePath: _image?.path,
//                                   ));
//                                 }
//                               },
//                               child: Text("Register"),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPass,
//         style: const TextStyle(color: Colors.white),
//         // --- إضافة الـ Validation هنا ---
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return "This field is required";
//           }
//           if (hint == "Email" && !_isValidEmail(value)) {
//             return "Please enter a valid email (must contain @)";
//           }
//           if (hint == "Password" && value.length < 8) {
//             return "Password must be at least 8 characters";
//           }
//           if (hint == "Confirm Password" && value != _passwordController.text) {
//             return "Passwords do not match";
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.amber, size: 20),
//           hintText: hint,
//           hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.05),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           // تحسين شكل رسالة الخطأ لتناسب الـ Glassmorphism
//           errorStyle: const TextStyle(color: Colors.orangeAccent),
//         ),
//       ),
//     );
//   }

//   // داخل زر الـ Register، يجب أن نتأكد من اختيار صورة واهتمامات أيضاً
//   void _onRegisterPressed() {
//     if (_formKey.currentState!.validate()) {
//       if (_image == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select a profile image")),
//         );
//         return;
//       }
//       if (selectedInterests.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select at least one interest")),
//         );
//         return;
//       }

//       context.read<AuthBloc>().add(RegisterEvent(
//             name: _nameController.text,
//             email: _emailController.text,
//             password: _passwordController.text,
//             confirmPassword: _confirmController.text,
//             interests: selectedInterests,
//             imagePath: _image?.path,
//           ));
//     }
//   }

//   void _showInterestsSheet() {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent, // لجعل الحواف دائرية مع الخلفية
//     isScrollControlled: true,
//     builder: (context) {
//       return StatefulBuilder( // ضروري لتحديث الحالة داخل الـ Sheet
//         builder: (context, setSheetState) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.5, // تأخذ نصف الشاشة
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A1A1A), // لون داكن يتناسب مع تصميمك
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//             ),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10))),
//                 const SizedBox(height: 20),
//                 const Text("Choose Your Interests", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Wrap(
//                       spacing: 10,
//                       children: categories.map((cat) {
//                         final isSelected = selectedInterests.contains(cat['id']);
//                         return FilterChip(
//                           label: Text(cat['name']),
//                           selected: isSelected,
//                           onSelected: (val) {
//                             // تحديث الحالة داخل الـ Sheet
//                             setSheetState(() {
//                               val ? selectedInterests.add(cat['id']) : selectedInterests.remove(cat['id']);
//                             });
//                             // تحديث الحالة في الواجهة الأساسية
//                             setState(() {});
//                           },
//                           selectedColor: Colors.amber,
//                           checkmarkColor: Colors.black,
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 45)),
//                   child: const Text("Done", style: TextStyle(color: Colors.black)),
//                 )
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app1/features/auth/data/models/Category_Model.dart'; // تأكدي من المسار
import 'package:library_app1/features/auth/presentation/bloc/auth_state.dart';
import 'package:library_app1/features/home/presentation/pages/home_page.dart';
import 'package:library_app1/features/home/presentation/pages/main_screen.dart';
import 'dart:ui';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  File? _image;
  
  // القائمة الآن فارغة وستمتلئ من السيرفر
  List<CategoryModel> categories = []; 
  List<int> selectedInterests = [];
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    // طلب جلب الأقسام من السيرفر فور تشغيل الشاشة
    context.read<AuthBloc>().add(GetCategoriesEvent());
  }

  Future _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
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
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/signupp.jpg'), fit: BoxFit.cover),
            ),
          ),
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white24,
                            backgroundImage: _image != null ? FileImage(_image!) : null,
                            child: _image == null ? Icon(Icons.camera_alt, color: Colors.white) : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildField(_nameController, "Name", Icons.person),
                        _buildField(_emailController, "Email", Icons.email),
                        _buildField(_passwordController, "Password", Icons.lock, isPass: true),
                        _buildField(_confirmController, "Confirm Password", Icons.lock_outline, isPass: true),
                        SizedBox(height: 15),
                        Text("Interests", style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 15),
                        
                        // حقل اختيار الاهتمامات
                        InkWell(
                          onTap: _showInterestsSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.favorite, color: Colors.amber, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      isLoadingCategories 
                                          ? "Loading Categories..." 
                                          : (selectedInterests.isEmpty 
                                              ? "Select Interests" 
                                              : "${selectedInterests.length} Selected"),
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                                if (isLoadingCategories)
                                  const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber))
                                else
                                  const Icon(Icons.arrow_drop_down, color: Colors.white54),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 25),

                        // الـ BlocConsumer للتعامل مع الحالات المختلفة
                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is CategoriesLoaded) {
                              setState(() {
                                categories = state.categories;
                                isLoadingCategories = false;
                              });
                              print("✅ UI Updated with ${categories.length} categories");
                            } else if (state is AuthSuccess) {

  //                             Navigator.pushAndRemoveUntil(
  //   context,
  //   MaterialPageRoute(builder: (context) => const MainScreen()),
  //   (route) => false, // لحذف شاشات التسجيل من الذاكرة
  // );
                              Navigator.pushAndRemoveUntil(
                                context, 
                                MaterialPageRoute(builder: (context) => MainScreen()),
                                (route) => false,
                              );
                            } else if (state is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) return CircularProgressIndicator(color: Colors.amber);
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: Size(double.infinity, 45)),
                              onPressed: _onRegisterPressed,
                              child: Text("Register", style: TextStyle(color: Colors.black)),
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
        ],
      ),
    );
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a profile image")));
        return;
      }
      if (selectedInterests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least one interest")));
        return;
      }

      context.read<AuthBloc>().add(RegisterEvent(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmController.text,
            interests: selectedInterests,
            imagePath: _image?.path,
          ));
    }
  }

  void _showInterestsSheet() {
    if (isLoadingCategories) return;

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
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 20),
                  const Text("Choose Your Interests", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        children: categories.map((cat) {
                          final isSelected = selectedInterests.contains(cat.id);
                          return FilterChip(
                            label: Text(cat.name, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
                            selected: isSelected,
                            onSelected: (val) {
                              setSheetState(() {
                                val ? selectedInterests.add(cat.id) : selectedInterests.remove(cat.id);
                              });
                              setState(() {}); 
                            },
                            selectedColor: Colors.amber,
                            checkmarkColor: Colors.black,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 45)),
                    child: const Text("Done", style: TextStyle(color: Colors.black)),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPass,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) return "This field is required";
          if (hint == "Email" && !_isValidEmail(value)) return "Enter a valid email";
          if (hint == "Password" && value.length < 8) return "Min 8 characters";
          if (hint == "Confirm Password" && value != _passwordController.text) return "Passwords do not match";
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.amber, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          errorStyle: const TextStyle(color: Colors.orangeAccent),
        ),
      ),
    );
  }
}