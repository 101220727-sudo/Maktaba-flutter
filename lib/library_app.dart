import 'package:flutter/material.dart';
import 'package:library_app/models/visit.dart';
import 'package:library_app/widgets/visit_list.dart';

class LibraryApp extends StatefulWidget {
  const LibraryApp({
    super.key,
    required this.registeredVisitList,
    required this.onDeleteVisit,
    
  });

  final List<Visit> registeredVisitList;
  final void Function(Visit) onDeleteVisit;
  
  @override
  State<LibraryApp> createState() {
    return _LibraryAppState();
  }
}

class _LibraryAppState extends State<LibraryApp> {
  @override
  Widget build(BuildContext context) {
    Widget mainContent = Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
          'لا توجد زيارات مسجلة بعد! ابدأ بإضافة بعض الزيارات.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: const Color.fromARGB(255, 111, 11, 123),
          ),
        ),
      ),
    );
    if (widget.registeredVisitList.isNotEmpty) {
      mainContent = VisitList(
        visitList: widget.registeredVisitList,
        onDeleteVisit: widget.onDeleteVisit,
        
      );
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Column(children: [Expanded(child: mainContent)]),
      ),
    );
  }
}
