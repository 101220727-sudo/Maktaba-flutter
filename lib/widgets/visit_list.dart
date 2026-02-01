import 'package:flutter/material.dart';
import 'package:library_app/models/visit.dart';
import 'package:intl/intl.dart';

class VisitList extends StatelessWidget {
  const VisitList({
    super.key,
    required this.visitList,
    required this.onDeleteVisit,
  });

  final List<Visit> visitList;
  final void Function(Visit) onDeleteVisit;

  @override
  Widget build(BuildContext context) {
    if (visitList.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد زيارات حتى الآن',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: visitList.length,
      itemBuilder: (context, index) {
        final visit = visitList[index];

        return Dismissible(
          key: ValueKey(visit.id),
          background: Container(
            padding: const EdgeInsets.only(left: 12),
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.delete, color: Colors.white, size: 25),
          ),
          onDismissed: (direction) {
            onDeleteVisit(visit);
          },
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('حذف النشاط', style: TextStyle(color: Colors.purple)),
                content: const Text(
                  'هل أنت متأكد أنك تريد حذف هذا النشاط؟',
                  style: TextStyle(color: Colors.purple),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('كلا'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('نعم'),
                  ),
                ],
              ),
            );
          },
          child: ListTile(
            title: Text(visit.location, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              '${DateFormat.yMd().format(visit.eventDate)} - ${DateFormat.Hm().format(visit.eventDate)}',
            ),
          ),
        );
      },
    );
  }
}
