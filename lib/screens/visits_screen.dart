import 'package:flutter/material.dart';
import 'package:library_app/models/visit.dart';
import 'package:library_app/screens/news_page.dart';
import 'package:library_app/services/api_service.dart';
import 'package:library_app/widgets/visit_list.dart';
import 'package:library_app/widgets/main_drawer.dart';
import 'home.dart';
import 'new_visit_screen.dart';

class VisitScheduleScreen extends StatefulWidget {
  const VisitScheduleScreen({super.key, required this.userId});
  final String userId;

  @override
  State<VisitScheduleScreen> createState() => _VisitScheduleScreenState();
}

class _VisitScheduleScreenState extends State<VisitScheduleScreen> {
  List<Visit> visitList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    try {
      final visits = await ApiService.getUserVisits(int.parse(widget.userId));
      setState(() {
        visitList = visits;
        loading = false;
      });
    } catch (e) {
      debugPrint("LOAD VISITS ERROR: $e");
      setState(() => loading = false);
    }
  }

  void _openNewVisit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => NewVisitScreen(userId: widget.userId),
      ),
    );

    if (result == true) {
      _loadVisits(); // 🔁 refresh from Laravel
    }
  }

  void _deleteVisit(Visit visit) {
    setState(() {
      visitList.remove(visit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'جدول الزيارات',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF76499C),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _openNewVisit,
            ),
          ],
        ),
        drawer: MainDrawer(
          userId: widget.userId,
          onAddVisit: _openNewVisit,
          onViewSchedule: () => Navigator.pop(context),
          onNewsTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewsPage(
                  isLoggedIn: true,
                  userId: widget.userId,
                ),
              ),
            );
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
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : VisitList(
                visitList: visitList,
                onDeleteVisit: _deleteVisit,
              ),
      ),
    );
  }
}
