import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:library_app1/core/api/api_client.dart';
import 'package:library_app1/forget_screen/reset_password.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({required this.email, super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _startSeconds = 2 * 60; // 15 دقيقة كما حدد الباك إند
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _startSeconds = 2 * 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _startSeconds--);
      }
    });
  }

  String get _timerString {
    final minutes = (_startSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_startSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // إعادة إرسال الرمز عند انتهاء المؤقت أو بالطلب
  Future<void> _resendCode() async {
    setState(() => _isResending = true);
    try {
      final dio = ApiClient().dio;
      await dio.post('/password/forgot', data: {'email': widget.email});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The code was successfully resent")),
      );
      _startTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code resending failed")),
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  void _verifyOtp() {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the complete 6-digit code. ")),
      );
      return;
    }

    // الانتقال لواجهة تعيين كلمة السر الجديدة مع تمرير الـ OTP والبريد
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(email: widget.email, otp: otp),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ptoot.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
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
                      "Enter Verification Code 🔑",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Enter the 6-digit code sent to:\n${widget.email}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 30),

                    // 🧊 Container المربوط بـ Glassmorphic Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          // 🔢 حقول المربعات الـ 6 للـ OTP
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => SizedBox(
                                width: 42,
                                height: 50,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          //  المؤقت والتوقيت
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.timer_outlined, color: Colors.white70, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "The code expires within: $_timerString",
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // 🔄 زر إعادة الإرسال
                          TextButton(
                            onPressed: (_startSeconds == 0 && !_isResending) ? _resendCode : null,
                            child: Text(
                              _isResending ? "Sending ..." : "Resend code  ",
                              style: TextStyle(
                                color: _startSeconds == 0 ? const Color(0xFFFFD200) : Colors.white38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // 🚀 زر التأكيد والانتقال
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFf7971e), Color(0xFFffd200)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: _verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text("Verify & Continue", style: TextStyle(color: Colors.white, fontSize: 16)),
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