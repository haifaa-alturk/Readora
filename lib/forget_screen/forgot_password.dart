// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:library_app1/login/reset_password.dart';

// class ForgotPasswordScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [

//           // 🖼️ الخلفية
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/backgr.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // 🌫️ Blur
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//             child: Container(
//               color: Colors.black.withOpacity(0.3),
//             ),
//           ),

//           // 📄 المحتوى
//           SafeArea(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [

//                     // 🔙 زر الرجوع
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_back, color: Colors.white),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     // 🧠 عنوان
//                     Text(
//                       "Forgot Password  ",
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),

//                     SizedBox(height: 10),

//                     Text(
//                       "Don’t worry! Mr. Ducky will take care of it. Enter your email and we’ll send you a reset link 💛",
//                       textAlign: TextAlign.center,
                      
//                       style: TextStyle(
//                         color: Colors.white70, fontSize: 15
//                       ),
//                     ),

//                     SizedBox(height: 40),

//                     // 🧊 Card
//                     Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(25),
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

//                           SizedBox(height: 25),

//                           // 🔘 زر الإرسال
//                           Container(
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color(0xFFf7971e),
//                                   Color(0xFFffd200),
//                                 ],
//                               ),
//                               borderRadius:
//                                   BorderRadius.circular(15),
//                             ),
//                             child: ElevatedButton(
//                             onPressed: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => ResetPasswordScreen(),
//     ),
//   );
// },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shadowColor: Colors.transparent,
//                                 padding:
//                                     EdgeInsets.symmetric(vertical: 15),
//                               ),
//                               child: Text("Send Link "),
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
import 'package:library_app1/forget_screen/OtpScreen.dart';
import 'package:library_app1/forget_screen/reset_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtpCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pleas enter your Email")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = ApiClient().dio;
      // 💡 افترضي أن الرابط هو /api/send-otp حسب الراوت في Laravel
      final response = await dio.post('/password/forgot', data: {'email': email});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'] ?? "The code was successfully sent")),
        );

        // 🚀 الانتقال لشاشة إعادة التعيين مع تمرير البريد
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(email: email),
          ),
        );
      }
    } on DioException catch (e) {
      String errStr = "An error occurred during transmission.";
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
      
          // 🖼️ الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backgr.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌫️ Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // 📄 المحتوى
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
  
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Don’t worry! Mr. Ducky will take care of it. Enter your email and we’ll send you a reset link 💛",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 40),

                    // 🧊 Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
 
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email, color: Colors.white),
                              hintText: "Email",
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
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(255, 128, 37, 158), Color.fromARGB(255, 232, 162, 225)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendOtpCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("Send Code", style: TextStyle(color: Colors.white, fontSize: 16)),
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