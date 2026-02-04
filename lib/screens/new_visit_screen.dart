import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:library_app/providers/visit_provider.dart';
import 'package:library_app/screens/package_screen.dart';

class NewVisitScreen extends StatefulWidget {
  final String userId;

  const NewVisitScreen({super.key, required this.userId});

  @override
  State<NewVisitScreen> createState() => _NewVisitScreenState();
}

class _NewVisitScreenState extends State<NewVisitScreen> {

  final _ageController = TextEditingController();

  final _visitorsController = TextEditingController();
  final _phoneController = TextEditingController();


  String? _selectedLocation;
  final List<String> _locations = [
    "بيروت", "طرابلس", "صور", "النبطية", "بنت جبيل", "الضاحية",
    "البقاع", "بعلبك", "بقاع غربي", "عكار", "جبيل", "صيدا",
  ];

  @override
  void initState() {
    super.initState();

    context.read<VisitProvider>().setUserId(int.parse(widget.userId));
  }

  @override
  void dispose() {

    _ageController.dispose();

    _visitorsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // 📅 Date Picker
  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final provider = context.read<VisitProvider>();
      final currentTime = provider.eventDate ?? DateTime.now();
      provider.setEventDate(DateTime(
        picked.year,
        picked.month,
        picked.day,
        currentTime.hour,
        currentTime.minute,
      ));
    }
  }

  // ⏰ Time Picker
  void _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final provider = context.read<VisitProvider>();
      final currentDate = provider.eventDate ?? DateTime.now();
      provider.setEventDate(DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        picked.hour,
        picked.minute,
      ));
    }
  }

  // 📍 Location Picker
  Future<void> _showLocationPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: 320,
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              "اختر المكان",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (_, index) => ListTile(
                  title: Text(_locations[index]),
                  onTap: () => Navigator.pop(context, _locations[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedLocation = result);
    }
  }

  // 📤 Submit
  void _submitVisitForm() {
    final provider = context.read<VisitProvider>();

    if (_selectedLocation == null ||
        _ageController.text.isEmpty ||
        _visitorsController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        provider.eventDate == null) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("خطأ", style: TextStyle(color: Colors.red)),
          content: Text("يرجى ملء جميع الحقول"),
        ),
      );
      return;
    }


    provider.setLocation(_selectedLocation!);
    provider.setAge(int.parse(_ageController.text));
    provider.setNbOfVisitors(int.parse(_visitorsController.text));
    provider.setPhone(_phoneController.text);
    provider.setGender(provider.gender ?? 'mixed');




    // Navigate to PackageScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PackageScreen(
          age: provider.age!,
          visitors: provider.nbOfVisitors!,
          gender: provider.gender!,
        ),
      ),
    );
  }

  // 🔹 Unified styled box for both fields and pickers
  Widget _styledBox({
    required String label,
    IconData? icon,
    TextEditingController? controller,
    TextInputType type = TextInputType.text,
    bool isPicker = false,
    VoidCallback? onTap,
    String? value, // For pickers
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: isPicker,
        onTap: onTap,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF76499C)),
          hintText: value,
          hintStyle: const TextStyle(color: Color(0xFF76499C)),
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF76499C)) : null,
          suffixIcon: isPicker
              ? const Icon(Icons.arrow_drop_down, color: Color(0xFF76499C))
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF76499C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF76499C), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        style: const TextStyle(fontSize: 16, color: Color(0xFF76499C)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VisitProvider>();

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF76499C),
          title: const Text("حجز زيارة", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Location picker
                _styledBox(
                  label: "اختر المكان",
                  icon: Icons.place,
                  isPicker: true,
                  onTap: _showLocationPicker,
                  value: _selectedLocation,
                ),

                // Age
                _styledBox(
                  label: "الفئة العمرية",
                  icon: Icons.groups,
                  controller: _ageController,
                  type: TextInputType.number,
                ),

                // Visitors
                _styledBox(
                  label: "عدد الزوار",
                  icon: Icons.people,
                  controller: _visitorsController,
                  type: TextInputType.number,
                ),

                // Phone
                _styledBox(
                  label: "رقم الهاتف",
                  icon: Icons.phone,
                  controller: _phoneController,
                  type: TextInputType.phone,
                ),

                // Gender
                Row(
                  children: [
                    Radio(
                      value: "male",
                      groupValue: provider.gender,
                      onChanged: (v) => provider.setGender(v!),
                    ),
                    const Text("ذكر"),
                    Radio(
                      value: "female",
                      groupValue: provider.gender,
                      onChanged: (v) => provider.setGender(v!),
                    ),
                    const Text("أنثى"),
                    Radio(
                      value: "mixed",
                      groupValue: provider.gender,
                      onChanged: (v) => provider.setGender(v!),
                    ),
                    const Text("كلاهما"),
                  ],
                ),

                // Date & Time pickers
                Row(
                  children: [
                    Expanded(
                      child: _styledBox(
                        label: "اختر التاريخ",
                        icon: Icons.calendar_month,
                        isPicker: true,
                        onTap: _showDatePicker,
                        value: provider.eventDate == null
                            ? null
                            : DateFormat.yMd().format(provider.eventDate!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _styledBox(
                        label: "اختر الوقت",
                        icon: Icons.access_time,
                        isPicker: true,
                        onTap: _showTimePicker,
                        value: provider.eventDate == null
                            ? null
                            : DateFormat.Hm().format(provider.eventDate!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("إلغاء")),
                    const SizedBox(width: 12),
                    ElevatedButton(
                        onPressed: _submitVisitForm,
                        child: const Text("التالي")),
                        
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
