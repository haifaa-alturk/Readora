import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:library_app1/login/reset_password.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🖼️ الخلفية
          Container(
            decoration: BoxDecoration(
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
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // 🔙 زر الرجوع
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    // 🧠 عنوان
                    Text(
                      "Forgot Password  ",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Don’t worry! Mr. Ducky will take care of it. Enter your email and we’ll send you a reset link 💛",
                      textAlign: TextAlign.center,
                      
                      style: TextStyle(
                        color: Colors.white70, fontSize: 15
                      ),
                    ),

                    SizedBox(height: 40),

                    // 🧊 Card
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [

                          // 📧 Email
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.white),
                              hintText: " Email",
                              hintStyle:
                                  TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor:
                                  Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          SizedBox(height: 25),

                          // 🔘 زر الإرسال
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFf7971e),
                                  Color(0xFFffd200),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                            onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ResetPasswordScreen(),
    ),
  );
},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding:
                                    EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Text("Send Link "),
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