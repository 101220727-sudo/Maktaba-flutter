import 'package:flutter/material.dart';
import 'package:library_app/models/visit.dart';
import 'package:library_app/screens/news_page.dart';
import 'package:library_app/screens/upcoming_event_screen.dart';
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

class _VisitScheduleScreenState extends State<VisitScheduleScreen>
    with WidgetsBindingObserver {
  List<Visit> visitList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadVisits();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🔁 when app returns from background (admin changed status)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadVisits();
    }
  }

  Future<void> _loadVisits() async {
    try {
      final visits = await ApiService.getUserVisits(int.parse(widget.userId));
      debugPrint("Fetched visits: ${visits.length}");
      setState(() {
        visitList = visits;
        loading = false;
      });
    } catch (e) {
      debugPrint("LOAD VISITS ERROR: $e");
      setState(() => loading = false);
    }
  }

  /// 🔁 pull to refresh
  Future<void> _refresh() async {
    await _loadVisits();
  }

  void _openNewVisit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => NewVisitScreen(userId: widget.userId),
      ),
    );

    if (result == true) {
      _loadVisits();
    }
  }

  /// 🗑️ delete from backend + UI
  Future<void> _deleteVisit(Visit visit) async {
    final success = await ApiService.deleteVisit(visit.id);

    if (success) {
      setState(() {
        visitList.removeWhere((v) => v.id == visit.id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل حذف الطلب")),
      );
    }
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
          onUpcomingEventsTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UpcomingEventsPage(userId: widget.userId),
              ),
            );
          },
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

        /// 👇 auto refresh + pull down refresh
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refresh,
                child: VisitList(
                  visitList: visitList,
                  onDeleteVisit: _deleteVisit,
                ),
              ),
      ),
    );
  }
}
