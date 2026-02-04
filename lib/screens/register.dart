import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/user_storage.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType; // stores selected user type ID
  String? _typeError;

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();

    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == null) {
      setState(() {
        _typeError = "يرجى اختيار نوع المستخدم";
      });
      return;
    }

    setState(() => _isLoading = true);

    final emailExists = await checkEmailExists(_emailController.text.trim());

    if (emailExists) {
      setState(() => _isLoading = false);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('البريد الإلكتروني مسجل مسبقاً'),
          backgroundColor: Color(0xFFF2C94C),
        ),
      );
      return;
    }

    final newUser = User(
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      name: _nameController.text.trim(),
      type: _selectedType!,
      password: _passwordController.text,
    );

    try {

      insertUser(newUser);


      await ApiService.registerUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        type: _selectedType!,
      );

      setState(() => _isLoading = false);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم التسجيل بنجاح! يمكنك الآن تسجيل الدخول'),
          backgroundColor: Color(0xFF4ABC9D),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل التسجيل. حاول مرة أخرى'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7FB),

        appBar: AppBar(
          backgroundColor: const Color(0xFF76499C),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'إنشاء حساب',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'إنشاء حساب جديد',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF76499C),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: const Text(
                              "البريد الإلكتروني",
                              style: TextStyle(color: Color(0xFF76499C)),
                            ),
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF76499C)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Phone
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            label: const Text(
                              "رقم الهاتف",
                              style: TextStyle(color: Color(0xFF76499C)),
                            ),
                            prefixIcon: const Icon(Icons.phone, color: Color(0xFF76499C)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال رقم الهاتف';
                            }
                            if (value.length < 10) {
                              return 'يجب أن يكون رقم الهاتف صحيحاً';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Full Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            label: const Text(
                              "الاسم الكامل",
                              style: TextStyle(color: Color(0xFF76499C)),
                            ),
                            prefixIcon: const Icon(Icons.person, color: Color(0xFF76499C)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم الكامل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // User Type (Radio buttons)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: "2",
                                  groupValue: _selectedType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedType = value;
                                      _typeError = null;
                                    });
                                  },
                                ),
                                const Text("مدرسة", style: TextStyle(color: Color(0xFF76499C))),
                                Radio<String>(
                                  value: "4",
                                  groupValue: _selectedType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedType = value;
                                      _typeError = null;
                                    });
                                  },
                                ),
                                const Text("كشافة", style: TextStyle(color: Color(0xFF76499C))),
                                Radio<String>(
                                  value: "3",
                                  groupValue: _selectedType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedType = value;
                                      _typeError = null;
                                    });
                                  },
                                ),
                                const Text("جمعية", style: TextStyle(color: Color(0xFF76499C))),
                              ],
                            ),
                            if (_typeError != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 12, top: 4),
                                child: Text(
                                  _typeError!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            label: const Text(
                              "كلمة المرور",
                              style: TextStyle(color: Color(0xFF76499C)),
                            ),
                            prefixIcon: const Icon(Icons.password, color: Color(0xFF76499C)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),

                            ),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),

                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF76499C),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        // Submit button
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF76499C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'إنشاء الحساب',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'هل لديك حساب؟ ',
                              style: TextStyle(
                                color: Color(0xFF76499C),
                                fontSize: 15,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                ' سجل دخول',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF76499C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
