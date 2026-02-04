import 'package:flutter/material.dart';
import 'package:library_app/models/package.dart';
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

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange; // pending
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'قيد الانتظار';
    }
  }

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
      padding: const EdgeInsets.all(12),
      itemCount: visitList.length,
      itemBuilder: (context, index) {
        final visit = visitList[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(visit.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusText(visit.status),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    Text(
                      visit.activityType.isNotEmpty
                          ? visit.activityType
                          : "نشاط",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Purple Info Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow("تاريخ الفعالية",
                          DateFormat.yMd().format(visit.eventDate)),
                      _infoRow(" تاريخ الطلب ", 
                          DateFormat.yMd().format(visit.date)),
                      

                      _infoRow("الوصف",
                          "${visit.location} "),
                      _infoRow("عدد الزوار", "${visit.nbOfVisitors}"),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// Cancel button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => onDeleteVisit(visit),
                      child: const Text("إلغاء الطلب",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),  
              ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
