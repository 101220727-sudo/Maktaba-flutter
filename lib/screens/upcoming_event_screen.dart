import 'package:flutter/material.dart';
import '../models/upcoming_event.dart';
import '../services/api_service.dart';
import '../widgets/main_drawer.dart';
import 'home.dart';
import 'package:library_app/screens/visits_screen.dart';
import 'package:library_app/screens/new_visit_screen.dart';


class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key,
  required this.userId,
  });

  final String userId;

  @override
  State<UpcomingEventsPage> createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage> {
  late Future<List<UpcomingEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = ApiService.fetchUpcomingEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF76499C),
          title: const Text(
            'الأنشطة القادمة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
            onUpcomingEventsTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpcomingEventsPage(userId: widget.userId)),
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
        body: FutureBuilder<List<UpcomingEvent>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No upcoming events'));
            } else {
              final events = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Column(
                    children: [
                      _buildEventCard(event),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
    
  }

  Widget _buildEventCard(UpcomingEvent event) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF76499C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event,
                  color: Color(0xFF76499C),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF76499C),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 10),

          /// Description 1
          Text(
            event.description1,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF444444),
              height: 1.6,
            ),
          ),

          /// Description 2 (optional)
          if (event.description2 != null) ...[
            const SizedBox(height: 8),
            Text(
              event.description2!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.6,
              ),
            ),
          ],

          const SizedBox(height: 12),

          /// Date
          
        ],
      ),
    );
  }
}
