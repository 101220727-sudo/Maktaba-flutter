import 'package:flutter/material.dart';
import 'package:library_app/models/visit.dart';

class VisitItem extends StatelessWidget {
  const VisitItem(this.visit, {super.key, required this.onUpdateVisit});

  final Visit visit;
  final void Function(Visit) onUpdateVisit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 4,
      shadowColor: Color.fromARGB(255, 151, 28, 141).withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          onUpdateVisit(visit);// Call the update visit callback when tapped
        },

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_note,
                    color: Color.fromARGB(255, 151, 28, 141),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    visit.activityType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Divider(),

              Row(
                children: [
                  Icon(Icons.place, color: Color.fromARGB(255, 151, 28, 141)),
                  const SizedBox(width: 8),
                  Text(
                    visit.location,
                    style: TextStyle(color: Color.fromARGB(255, 151, 28, 141)),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Icon(Icons.people, color: Color.fromARGB(255, 151, 28, 141)),
                  const SizedBox(width: 6),
                  Text(
                    " الفئة العمرية: ${visit.age}",
                    style: TextStyle(color: Color.fromARGB(255, 151, 28, 141)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 191, 128, 186),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Color.fromARGB(255, 151, 28, 141),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${visit.eventDate.hour}:${visit.eventDate.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 151, 28, 141),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 191, 128, 186),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: Color.fromARGB(255, 151, 28, 141),
                        ),
                        const SizedBox(width: 6),

                        Text(
                          "${visit.eventDate.day}/${visit.eventDate.month}/${visit.eventDate.year}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 151, 28, 141),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
