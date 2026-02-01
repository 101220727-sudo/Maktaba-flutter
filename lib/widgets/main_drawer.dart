import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.userId,// btjeb l user id
    required this.onAddVisit,//
    required this.onViewSchedule,
    required this.onNewsTap,
    required this.onHomePage,
  });
  final String userId;// btjeb l user id
  final void Function() onAddVisit;
  final void Function() onViewSchedule;
  final void Function() onNewsTap;
  final void Function() onHomePage;

  @override
  Widget build(BuildContext context) {// Build the main drawer widget
    return Drawer(
      backgroundColor: Color(0xFF76499C),
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_rounded, size: 80, color: Colors.white),
                Text(
                  'مكتبة مهدي المتجولة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.schedule, color: Colors.white),
            title: Text('جدول الزيارات', style: TextStyle(color: Colors.white)),
            onTap: onViewSchedule,
          ),

          ListTile(
            leading: Icon(Icons.add, color: Colors.white),
            title: Text('إضافة زيارة', style: TextStyle(color: Colors.white)),
            onTap: onAddVisit,
          ),

          ListTile(
            leading: Icon(Icons.newspaper, color: Colors.white),
            title: Text('أخبار المكتبة', style: TextStyle(color: Colors.white)),
            onTap: onNewsTap,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
            onTap: onHomePage,
          ),
        ],
      ),
    );
  }
}
