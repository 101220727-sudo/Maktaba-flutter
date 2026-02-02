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
  // Controllers
  final _ageController = TextEditingController();
  //final _locationController = TextEditingController();
  //final _locationController = TextEditingController();
  final _visitorsController = TextEditingController();
  final _phoneController = TextEditingController();

  // ✅ Location dropdown
  String? _selectedLocation;
  final List<String> _locations = [
    "بيروت ",
    "طرابلس ",
    "صور ",
    "النبطية ",
    "بنت جبيل ",
    "الضاحية ",
    "البقاع ",
    "بعلبك ",
    "بقاع غربي ",
    "عكار ",
    "جبيل ",
    "صيدا ",
  ];

  @override
  void initState() {
    super.initState();
    // Set userId in provider
    context.read<VisitProvider>().setUserId(int.parse(widget.userId));
  }

  @override
  void dispose() {
    
    _ageController.dispose();
    //_locationController.dispose();
    _visitorsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Date Picker
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

  // Time Picker
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

  // Submit
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

    // Set provider values
    provider.setLocation(_selectedLocation!);
    provider.setAge(int.parse(_ageController.text));
    provider.setNbOfVisitors(int.parse(_visitorsController.text));
    provider.setPhone(_phoneController.text);
    provider.setGender(provider.gender ?? 'mixed');
    // Optional: activity type if added in provider
    // provider.setActivityType(_activityTypeController.text);

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

  // Styled text field
  Widget _styledField(TextEditingController controller, String label, IconData icon,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLength: 50,
        decoration: InputDecoration(
          label: Text(label, style: const TextStyle(color: Color(0xFF76499C))),
          prefixIcon: Icon(icon, color: const Color(0xFF76499C)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF76499C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF76499C), width: 2),
          ),
        ),
      ),
    );
  }

  // Styled dropdown for location
  Widget _styledDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          label: Text(label, style: const TextStyle(color: Color(0xFF76499C))),
          prefixIcon: Icon(icon, color: const Color(0xFF76499C)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF76499C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF76499C), width: 2),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // Picker box for date/time
  Widget _pickerBox(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF76499C)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(color: Color(0xFF76499C))),
          Icon(icon, color: const Color(0xFF76499C)),
        ],
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ✅ Location dropdown
                _styledDropdown(
                  label: "المكان",
                  icon: Icons.place,
                  items: _locations,
                  selectedValue: _selectedLocation,
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  },
                ),

                _styledField(_ageController, "الفئة العمرية", Icons.groups),
                _styledField(_visitorsController, "عدد الزوار", Icons.people,
                    type: TextInputType.number),
                _styledField(_phoneController, "رقم الهاتف", Icons.phone,
                    type: TextInputType.phone),
                const SizedBox(height: 10),

                // Gender selection
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

                // Date & Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _showDatePicker,
                        child: _pickerBox(
                          provider.eventDate == null
                              ? "اختر التاريخ"
                              : DateFormat.yMd().format(provider.eventDate!),
                          Icons.calendar_month,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _showTimePicker,
                        child: _pickerBox(
                          provider.eventDate == null
                              ? "اختر الوقت"
                              : DateFormat.Hm().format(provider.eventDate!),
                          Icons.access_time,
                        ),
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
                        onPressed: _submitVisitForm, child: const Text("التالي")),
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
