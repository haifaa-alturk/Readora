// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:library_app1/onboarding/onboarding.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {

//   late AnimationController _progressController;
//   late AnimationController _fadeController;

//   late Animation<double> _progressAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _progressController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 4),
//     );

//     _progressAnimation =
//         Tween<double>(begin: 0, end: 1).animate(_progressController);

//     _fadeController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 2200),
//     );

//     _fadeAnimation =
//         Tween<double>(begin: 0, end: 1).animate(_fadeController);

//     _fadeController.forward();
//     _progressController.forward();

//     Timer(Duration(seconds: 6), () {
//       Navigator.pushReplacement(
//         context,
//         PageRouteBuilder(
//           transitionDuration: Duration(milliseconds: 800),
//           pageBuilder: (_, __, ___) => OnboardingScreen(),
//           transitionsBuilder: (_, animation, __, child) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _progressController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }



// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Stack( // استخدمنا Stack لوضع العناصر فوق الصورة
//           children: [
            
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               child: Image.asset(
//                 'assets/images/on0.jpg', 
//                 fit: BoxFit.cover, 
//               ),
//             ),

           
           
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.3), // تظليل بنسبة 30%
//               ),
//             ),

         
//             SafeArea(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center, // وضع العناصر في الأسفل
//                 children: [
                  

//                   SizedBox(height: 80),

//                   // الـ Progress Bar كما هو في كودك
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     child: AnimatedBuilder(
//                       animation: _progressAnimation,
//                       builder: (context, child) {
//                         return Column(
//                           children: [
//                             Stack(
//                               children: [
//                                 Container(
//                                   height: 10,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.3),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                 ),
//                                 FractionallySizedBox(
//                                   widthFactor: _progressAnimation.value,
//                                   child: Container(
//                                     height: 6,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [Color.fromARGB(255, 54, 51, 39), Color.fromARGB(255, 17, 12, 6)],
//                                       ),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "${(_progressAnimation.value * 100).toInt()}%",
//                               style: TextStyle(color: Colors.white, fontSize: 14),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
                  
//                   SizedBox(height: 50), 
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:library_app1/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _progressController;
  late AnimationController _fadeController;

  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(_progressController);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_fadeController);

    _fadeController.forward();
    _progressController.forward();

    // الانتقال بعد 6 ثوانٍ إلى شاشة OnboardingScreen
    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => OnboardingScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء نقية
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // خلفية الأنيميشن Lottie مع التوهج والحواف الدائرية
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // جعل الحاوية دائرية بالكامل
                  color: Colors.white,
                  boxShadow: [
                    // توهج زهري ناعم خارجي
                    BoxShadow(
                      color: const Color(0xFFFF80AB).withOpacity(0.4), // لون زهري متوهج
                      blurRadius: 40, // مدى التغبيش والانتشار
                      spreadRadius: 10, // حجم هالة التوهج
                    ),
                    // توهج بنفسجي ثانوي لإضفاء عمق جمالي
                    BoxShadow(
                      color: const Color(0xFFE1BEE7).withOpacity(0.5),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: ClipOval( // قص حواف الأنيميشن بشكل دائري
                  child: ShaderMask( // دمج حواف الأنيميشن مع لون الخلفية
                    shaderCallback: (rect) {
                      return const RadialGradient(
                        colors: [
                          Colors.black, // المركز شفاف يظهر الأنيميشن
                          Colors.transparent, // الأطراف تتلاشى
                        ],
                        stops: [0.75, 1.0], // يبدأ التلاشي عند 75% من القطر
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Lottie.asset(
                      'assets/animations/splash_animation.json',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF80AB),
                          ),
                          
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // الطبقة العلوية التي تحتوي على Progress Bar في الأسفل
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: AnimatedBuilder(
                      
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Column(
                          children: [
                                        
                            Center(
                              child: Text(
                               "Readora",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 121, 0, 109),
                                ),
                                
                              ),
                            ),
                             const SizedBox(height: 20),
                            Stack(
                              children: [
                       
                             const SizedBox(height: 10),
                                Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.pink.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: _progressAnimation.value,
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF80AB), // زهري متوهج
                                          Color(0xFFB89CFA), // بنفسجي ناعم
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF80AB).withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${(_progressAnimation.value * 100).toInt()}%",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
    }