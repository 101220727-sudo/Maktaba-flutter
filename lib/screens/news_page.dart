import 'package:flutter/material.dart';
import 'home.dart';
import '../widgets/main_drawer.dart';
import 'package:library_app/screens/visits_screen.dart';
import 'package:library_app/screens/new_visit_screen.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../models/news.dart';



class NewsPage extends StatefulWidget {
  const NewsPage({
    super.key,
    required this.isLoggedIn,
    this.onLogout,
    required this.userId,
  });

  final bool isLoggedIn;
  final VoidCallback? onLogout;
  final String userId;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NewsProvider>().loadNews());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF76499C),
          title: const Text(
            'صفحة الأخبار',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: MainDrawer(
          userId: widget.userId,
          onAddVisit: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewVisitScreen(userId: widget.userId),
              ),
            );
          },
          onViewSchedule: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    VisitScheduleScreen(userId: widget.userId),
              ),
            );
          },
          onNewsTap: () {
            Navigator.pop(context);
          },
          onHomePage: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
              (route) => false,
            );
          },
        ),

        body: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.error != null
                ? Center(child: Text(provider.error!))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.news.length,
                    itemBuilder: (context, index) {
                      final News news = provider.news[index];
                      return Column(
                        children: [
                          _buildNewsCard(
                            title: news.title,
                            date: (news.publishedAt ?? '').toString(),
                            description: news.description,
                            icon: Icons.article,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String date,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF76499C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    color: const Color(0xFF76499C), size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF76499C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Color(0xFF4ABC9D)),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4ABC9D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF444444),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
