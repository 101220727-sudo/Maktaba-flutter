import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_app/providers/visit_provider.dart';
import 'package:library_app/models/package.dart';
import 'package:library_app/services/api_service.dart';

class PackageScreen extends StatefulWidget {
  final int age;
  final int visitors;
  final String gender;

  const PackageScreen({
    super.key,
    required this.age,
    required this.visitors,
    required this.gender,
  });

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  List<EventPackage> packages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      final result = await ApiService.getPackages(
        age: widget.age,
        visitors: widget.visitors,
        gender: widget.gender,
      );

      setState(() {
        packages = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading packages: $e');
      setState(() => isLoading = false);
    }
  }

  String _formatSeconds(int seconds) {
   final h = seconds ~/ 3600;
   final m = (seconds % 3600) ~/ 60;
   return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
    final visitProvider = context.watch<VisitProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF76499C),
          title: const Text(
            'اختيار الباقة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : packages.isEmpty
                ? const Center(child: Text('لا توجد باقات مناسبة'))
                : Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: packages.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final package = packages[index];
                            final isSelected =
                                visitProvider.packageId ==
                                    package.id;

                            return _buildAnimatedPackageCard(
                              package: package,
                              isSelected: isSelected,
                              onTap: () {
                                visitProvider
                                    .setPackageId(package.id);
                              },
                            );
                          },
                        ),
                      ),

                      // CONFIRM BUTTON
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                visitProvider.packageId == null
                                    ? null
                                    : () async {
                                        try {
                                          debugPrint("CLICK CONFIRM BUTTON");

                                          final bool ok = await visitProvider.submitVisit();
                                          debugPrint("SUBMIT RESULT: $ok");
                                          
                                          if (!mounted) return; // Ensure widget is still in tree
                                          if (ok) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('تم إرسال الزيارة بنجاح'),
                                                backgroundColor: Color(0xFF4ABC9D),
                                              ),
                                            );
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('فشل إرسال الزيارة'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                         } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('حدث خطأ: $e'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          }
                                    },
                                          
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF76499C),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'تأكيد الباقة', 
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  // ================== PACKAGE CARD ==================

  Widget _buildAnimatedPackageCard({
    required EventPackage package,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF76499C) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF76499C).withOpacity(0.25)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 25 : 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
             
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE + CHECK
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            package.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF76499C),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isSelected ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF76499C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    Text(
                      package.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF444444),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Divider(),

                    // PRICE
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            size: 16, color: Color(0xFF4ABC9D)),
                        const SizedBox(width: 4),
                        Text(
                          package.price != null && package.price! > 0
                              ? '${package.price}'
                              : 'مجاني',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4ABC9D),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // TIME
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 14, color: Color(0xFF4ABC9D)),
                        const SizedBox(width: 4),
                         Text(
                          package.eventTime > 0
                          ? _formatSeconds(package.eventTime)
                          : '--:--',
                         
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4ABC9D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
