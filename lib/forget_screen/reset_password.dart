// import 'dart:ui';
// import 'package:flutter/material.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

//   final otpController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [

//           // 🖼️ الخلفية
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/ptoot.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // 🌫️ Blur
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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

//                     // 🔙 رجوع
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_back, color: Colors.white),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),

//                     SizedBox(height: 10),

//                     // 🧠 عنوان
//                     Text(
//                       "Reset Password ",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),

//                     SizedBox(height: 30),

//                     // 🧊 Card
//                     Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Column(
//                         children: [

//                           // 🔢 OTP
//                           TextField(
//                             controller: otpController,
//                             keyboardType: TextInputType.number,
//                             style: TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.lock_clock, color: Colors.white),
//                               hintText: "OTP code",
//                               hintStyle: TextStyle(color: Colors.white70),
//                               filled: true,
//                               fillColor: Colors.white.withOpacity(0.1),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 15),

//                           // 🔐 Password
//                           TextField(
//                             controller: passwordController,
//                             obscureText: true,
//                             style: TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.lock, color: Colors.white),
//                               hintText: "New Password",
//                               hintStyle: TextStyle(color: Colors.white70),
//                               filled: true,
//                               fillColor: Colors.white.withOpacity(0.1),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 15),

//                           // 🔐 Confirm Password
//                           TextField(
//                             controller: confirmPasswordController,
//                             obscureText: true,
//                             style: TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
//                               hintText: "Confirm Password",
//                               hintStyle: TextStyle(color: Colors.white70),
//                               filled: true,
//                               fillColor: Colors.white.withOpacity(0.1),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           SizedBox(height: 25),

//                           // 🚀 زر التأكيد
//                           Container(
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color(0xFFf7971e),
//                                   Color(0xFFffd200),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // 🔥 هنا لاحقاً نتحقق ونغير الباسورد
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shadowColor: Colors.transparent,
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                               ),
//                               child: Text("Change "),
//                             ),
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
import 'package:dio/dio.dart';
import 'package:library_app1/core/api/api_client.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    required this.email,
    required this.otp,
    super.key,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordObscure = true;
  bool _isConfirmObscure = true;

  Future<void> _changePassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("كلمة السر وتأكيدها غير متطابقين")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = ApiClient().dio;
      final response = await dio.post('/password/reset', data: {
        'email': widget.email,
        'otp': widget.otp, // 🔑 إرسال الـ OTP المستلم من الواجهة السابقة
        'password': password,
        'password_confirmation': confirmPassword,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message'] ?? "The password has been successfully changed."),
            backgroundColor: Colors.green,
          ),
        );

        // 🔙 العودة لصفحة تسجيل الدخول الرئيسية
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } on DioException catch (e) {
      String errStr = "Password change failed. Check code.";
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errStr = e.response?.data['message'];
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errStr), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼️ الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ptoot.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌫️ Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // 📄 المحتوى
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Reset Password 🔒",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 🧊 Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          // 🔒 New Password
                          TextField(
                            controller: passwordController,
                            obscureText: _isPasswordObscure,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Colors.white),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() => _isPasswordObscure = !_isPasswordObscure);
                                },
                              ),
                              hintText: "New Password",
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // 🔐 Confirm Password
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: _isConfirmObscure,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmObscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() => _isConfirmObscure = !_isConfirmObscure);
                                },
                              ),
                              hintText: "Confirm Password",
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // 🚀 Submit Button
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFf7971e), Color(0xFFffd200)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "Change Password",
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}