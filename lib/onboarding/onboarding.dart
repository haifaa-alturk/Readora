
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
    "image": "assets/images/buyB.jpg",
    "title": "Welcome to Library",
    "desc": "أهلا بك في شراء وتصفح الكتب بسهولة",
    "color": Color.fromARGB(255, 239, 247, 208),
  },
  {
    "image": "assets/images/tenentB.jpg",
    "title": "Borrowing Books",
    "desc": "مع ميزة استعارة الكتب لمدة معينة",
    "color": Color(0xFFD6EAF8),
  },
  {
    "image": "assets/images/raceB.jpg",
    "title": "Competition System",
    "desc": "المزيد من الحماس والقراءة للفوز بالمسابقات",
    "color": Color.fromARGB(255, 208, 231, 198),
  },
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
      MaterialPageRoute(builder: (_) => SplashScreen()),
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
                child: Text("تخطي"),
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

                     
ClipRRect(
  borderRadius: BorderRadius.circular(10), 
  child: Image.asset(
    data[i]['image']!,
    height: 250,
   // width: 800,
    fit: BoxFit.cover, 
  ),
),
                        SizedBox(height: 40),

                     
                        Text(
                          data[i]['title']!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      currentPage == data.length - 1
                          ? "ابدأ"
                          : "التالي",
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