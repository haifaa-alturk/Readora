import 'dart:async';
import 'package:flutter/material.dart';
import 'package:library_app1/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
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
      duration: Duration(seconds: 4),
    );

    _progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(_progressController);

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2200),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_fadeController);

    _fadeController.forward();
    _progressController.forward();

    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFFE8DCC6),
//                 Color(0xFFB09648),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea( // ✅ مهم
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [

//                   // ✅ الصورة (تم إصلاحها)
//                   SizedBox(
//                     height: 180, // 🔥 أهم تعديل
//                     child: Image.asset(
//                       'assets/images/logof.png',
//                       fit: BoxFit.contain,
//                     ),
//                   ),

//                   SizedBox(height: 20),

//                   Text(
//                     "Your Digital Library",
//                     style: TextStyle(
//                       color: Color(0xFF3B2805),
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   SizedBox(height: 40),

//                   // 🔥 Progress Bar
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     child: AnimatedBuilder(
//                       animation: _progressAnimation,
//                       builder: (context, child) {
//                         return Stack(
//                           children: [

//                             Container(
//                               height: 6,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),

//                             FractionallySizedBox(
//                               widthFactor: _progressAnimation.value,
//                               child: Container(
//                                 height: 6,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Color(0xFF8E7420),
//                                       Color(0xFF73460C),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.orange.withOpacity(0.5),
//                                       blurRadius: 8,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),

//                   SizedBox(height: 15),

//                   AnimatedBuilder(
//                     animation: _progressAnimation,
//                     builder: (_, __) {
//                       return Text(
//                         "${(_progressAnimation.value * 100).toInt()}%",
//                         style: TextStyle(
//                           color: Color(0xFF3B2805),
//                           fontSize: 14,
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack( // استخدمنا Stack لوضع العناصر فوق الصورة
          children: [
            
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/on0.jpg', 
                fit: BoxFit.cover, 
              ),
            ),

           
           
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3), // تظليل بنسبة 30%
              ),
            ),

         
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // وضع العناصر في الأسفل
                children: [
                  

                  SizedBox(height: 80),

                  // الـ Progress Bar كما هو في كودك
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: _progressAnimation.value,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color.fromARGB(255, 54, 51, 39), Color.fromARGB(255, 17, 12, 6)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${(_progressAnimation.value * 100).toInt()}%",
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: 50), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}