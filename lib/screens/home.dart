import 'package:flutter/material.dart';
import 'package:library_app/screens/login.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7FB),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ---------------- Top Banner ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF76499C), Color(0xFF9C5ECF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 100,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'مكتبة مهدي المتجولة',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'حافلة ثقافية متنقلة للأطفال والناشئة',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- Info Card ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'مكتبة مهدي تقدم باقة بأكثر من 40 نشاطاً فنياً مختلفاً ومجموعة كبيرة من الألعاب الفكرية وأفلام تعليمية تعرض على الحواسيب وعلى شاشة تلفاز ثلاثية الأبعاد.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF444444),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'للمزيد من المعلومات والأخبار، سجل دخولك إلى التطبيق!',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF76499C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- Action Button ----------------
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  backgroundColor: const Color(0xFF76499C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  elevation: 5,
                  shadowColor: Colors.purple.withOpacity(0.4),
                ),
                child: const Text(
                  'ابدأ الآن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- Feature Cards ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _featureCard(Icons.newspaper, 'الأخبار', Colors.purple.shade300),
                    _featureCard(Icons.event, 'الفعاليات', Colors.purple.shade200),
                    _featureCard(Icons.book, 'المكتبة', Colors.purple.shade100),
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Feature Card Widget ----------------
  Widget _featureCard(IconData icon, String title, Color bgColor) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: Colors.purple.shade900),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF76499C),
            ),
          ),
        ],
      ),
    );
  }
}
