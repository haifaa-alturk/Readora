
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:library_app1/login/forgot_password.dart';

// class LoginScreen extends StatelessWidget {
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