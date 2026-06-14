
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:library_app1/login/forgot_password.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }


// class _LoginScreenState extends State<LoginScreen> {
//   final emailController = TextEditingController();
// final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [

//           // 🖼️ الخلفية
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/MrDuck.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // 🌫️ Blur effect
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//             child: Container(
//               color: Colors.black.withOpacity(0.3),
//             ),
//           ),

//           // 📄 المحتوى
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   children: [

//                     // 🔥 Logo أو عنوان
//                     Text(
//                       "Welcome To Readora ",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         letterSpacing: 1.0,
//                       ),
//                     ),

//                     SizedBox(height: 10),

//     Text(
//                       "Hi sir...it looks like you love books,so Mr.ducky made this app just for you 🐤 ",
//                       style: TextStyle(
//                         fontSize: 15,
//                         // fontWeight: FontWeight.bold,
//                         color: const Color.fromARGB(255, 233, 230, 226),
//                         letterSpacing: 1.0,
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     // 🧊 Glass Card
//                     Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(25),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.2),
//                         ),
//                       ),
//                       child: Column(
//                         children: [

//                           // 📧 Email
//                           TextField(
//                             style: TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                               prefixIcon:
//                                   Icon(Icons.email, color: Colors.white),
//                               hintText: " Email",
//                               hintStyle:
//                                   TextStyle(color: Colors.white70),
//                               filled: true,
//                               fillColor:
//                                   Colors.white.withOpacity(0.1),
//                               border: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(15),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 20),

//                           // 🔒 Password
//                           TextField(
//                             obscureText: true,
//                             style: TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                               prefixIcon:
//                                   Icon(Icons.lock, color: Colors.white),
//                               hintText: "Password ",
//                               hintStyle:
//                                   TextStyle(color: Colors.white70),
//                               filled: true,
//                               fillColor:
//                                   Colors.white.withOpacity(0.1),
//                               border: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(15),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 10),

//                           // ❓ forgot password
//                           Align(
//                             alignment: Alignment.center,
//                             child: TextButton(
//                             onPressed: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => ForgotPasswordScreen(),
//     ),
//   );
// },
//                               child: Text(
//                                 " Forgot Password?",
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 20),

//                           // 🚀 Login Button (Gradient)
//                           Container(
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color.fromARGB(255, 222, 173, 12),
//                                   Color.fromARGB(255, 212, 196, 124),
//                                 ],
//                               ),
//                               borderRadius:
//                                   BorderRadius.circular(15),
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shadowColor: Colors.transparent,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: Text(
//                                 " Login",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 20),

//                           // 🆕 Register
//                           Row(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 " You dont have acount?",
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () {},
//                                 child: Text(
//                                   " Sign Up",
//                                   style: TextStyle(
//                                     color: Colors.amber,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/auth/presentation/pages/signup_page.dart';
import 'package:library_app1/features/home/presentation/pages/home_page.dart';
import 'package:library_app1/features/home/presentation/pages/main_screen.dart';
import 'package:library_app1/login/forgot_password.dart';

// استيراد ملفات الـ Bloc الخاصة بك (تأكدي من صحة المسارات)
import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_event.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // المتحكمات لقراءة النصوص
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // مفتاح للتحقق من الحقول (Validation)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // نجاح التسجيل: رسالة ترحيب ثم انتقال
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Welcome back, ${state.user.name}!"
                ),
                backgroundColor: Colors.green,
              ),
            );
          //    Navigator.pushReplacementNamed(context, '/home'); // فكي التعليق عند تجهيز الهوم
          // } else if (state is AuthError) {
          //   // فشل التسجيل: إظهار الخطأ القادم من الباك إيند
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(state.message),
          //       backgroundColor: Colors.red,
          //     ),
          //   );
          // }
          // 2. الانتقال لصفحة الهوم وحذف كل ما قبلها من الـ Stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (route) => false,
    );
  } else if (state is AuthError) {
    // عرض الخطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message)),
    );
  }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // 🖼️ الخلفية
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/MrDuck.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 🌫️ تأثير التغبيش
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),

              // 📄 المحتوى الرئيسي
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey, // ربط الـ Form للمصادقة
                      child: Column(
                        children: [
                          const Text(
                            "Welcome To Readora",
                            style: TextStyle(
                           fontSize: 24, // أكبر قليلاً
    fontWeight: FontWeight.w900, // أثقل
    letterSpacing: 1.5, // تباعد عصري,
                              color: Colors.white,
                             
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Hi sir... Mr.Ducky made this app just for you 🐤",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 233, 230, 226),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 🧊 Glass Card (صندوق المدخلات)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                // 📧 Email Field
                                TextFormField(
                                  controller: emailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _buildInputDecoration("Email", Icons.email),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return "Email is required";
                                    if (!value.contains('@')) return "Enter a valid email";
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // 🔒 Password Field
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _buildInputDecoration("Password", Icons.lock),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return "Password is required";
                                    if (value.length < 8) return "Password must be at least 8 characters";
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 10),

                                // ❓ Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // 🚀 Login Button
                                state is AuthLoading
                                    ? const CircularProgressIndicator(color: Colors.amber)
                                    : _buildLoginButton(context),

                                const SizedBox(height: 20),

                                // 🆕 Register Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account? ",
                                        style: TextStyle(color: Colors.white70)),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) =>RegisterScreen ()));
                                      },
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ميثود لتنسيق المدخلات
  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      errorStyle: const TextStyle(color: Colors.amberAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ميثود لبناء الزر
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 222, 173, 12),
            Color.fromARGB(255, 212, 196, 124),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // إرسال الأكشن للـ Bloc
            context.read<AuthBloc>().add(
                  LoginEvent(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  ),
                );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}