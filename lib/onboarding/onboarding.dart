
import 'package:flutter/material.dart';
import 'package:library_app1/features/auth/presentation/pages/login_page.dart';
// import 'package:library_app1/features/auth/views/login.dart';
import 'package:library_app1/login/login.dart';
import 'package:library_app1/onboarding/splash_screen.dart';
// import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _controller = PageController();
  int currentPage = 0;
final List<Map<String, dynamic>> data = [
  {
    "image": "assets/images/on1.jpg",
    "title": "YOUR DIGITAL LIBRARY",
    "desc":"Access your reading list on any device.",
   // "color": Color.fromARGB(255, 239, 247, 208),
   "color": Color(0xFFC8E6C9)
  },
  {
  "image": "assets/images/on2.jpg",
    "title": "COMPETATION SYSTEM",
    "desc": "More excitement and reading to win competitions",
    // "color": Color(0xFFD6EAF8),
     "color": Color(0xFFFFF9C4)
  },
  {
      "image": "assets/images/on3.jpg",
    "title": "CHOOSE A BOOK",
    "desc": "Select and Borrow your book",
    // "color": Color.fromARGB(255, 208, 231, 198),
     "color": Color(0xFFE1F5FE)
  }
];

  void nextPage() {
    if (currentPage == data.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: data[currentPage]["color"],  
     
      body: SafeArea(
        child: Column(
          children: [
         
Align(
  alignment: Alignment.topRight,
  child: TextButton(
    onPressed: skip,
    child: Text(
      "Skip",
      style: TextStyle(
        color: Color(0xFF463716), // متناسق مع لون الوصف
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: data.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                    
Container(
  height: 250,
  width: 250,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(
      image: AssetImage(data[i]['image']!),
      fit: BoxFit.cover,
    ),
    // إضافة ظل خفيف لإبراز الصورة
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 20,
        spreadRadius: 6,
      ),
    ],
  ),
),
                        SizedBox(height: 40),

                     
                       
                       
Text(
  data[i]['title']!,
  style: TextStyle(
    fontSize: 24, // أكبر قليلاً
    color: const Color(0xFF2F3C43),
    fontWeight: FontWeight.w900, // أثقل
    letterSpacing: 1.5, // تباعد عصري
  ),
  textAlign: TextAlign.center,
),
                        SizedBox(height: 15),

                       
                        Text(
                          data[i]['desc']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 70, 55, 22),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  
                  Row(
                    children: List.generate(data.length, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: 6),
                        width: currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? const Color.fromARGB(255, 234, 149, 12)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),

                  ElevatedButton(
                    
                    onPressed: nextPage,
                   style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF7CB9B9), // لون ثيم Readora
  foregroundColor: Colors.white, // نص أبيض
  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  elevation: 5, // ظل خفيف للزر
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30), // حواف أنعم
  ),
),
                    child: Text(
                      currentPage == data.length - 1
                          ? "Get Started"
                          : "Next",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}