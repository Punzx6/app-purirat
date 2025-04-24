import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;

    final p = await SharedPreferences.getInstance();
    await p.setString('fullName', fullNameCtrl.text.trim());
    await p.setString('email', emailCtrl.text.trim());
    await p.setString('phone', phoneCtrl.text.trim());
    await p.setString('username', userCtrl.text.trim());
    await p.setString('password', passCtrl.text);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg_leaf.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 10,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create Account',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildText(
                          fullNameCtrl,
                          'Full name',
                          icon: Icons.person,
                          validator: (v) {
                            if (v!.isEmpty) return 'กรุณากรอกชื่อ';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildText(
                          emailCtrl,
                          'Email',
                          icon: Icons.email,
                          keyboard: TextInputType.emailAddress,
                          validator:
                              (v) =>
                                  v!.contains('@') ? null : 'อีเมลไม่ถูกต้อง',
                        ),
                        const SizedBox(height: 12),
                        _buildText(
                          phoneCtrl,
                          'Phone',
                          icon: Icons.phone,
                          keyboard: TextInputType.phone,
                          validator:
                              (v) =>
                                  v!.length < 8
                                      ? 'เบอร์ไม่น้อยกว่า 8 ตัว'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        _buildText(
                          userCtrl,
                          'Username',
                          icon: Icons.account_circle,
                          validator: (v) {
                            if (v!.isEmpty) return 'ตั้งชื่อผู้ใช้';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passCtrl,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed:
                                  () => setState(() => obscure = !obscure),
                            ),
                          ),
                          validator:
                              (v) => v!.length < 4 ? 'อย่างน้อย 4 ตัว' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'REGISTER',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back to Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(
    TextEditingController c,
    String label, {
    IconData? icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: c,
    decoration: InputDecoration(
      prefixIcon: icon != null ? Icon(icon) : null,
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    keyboardType: keyboard,
    validator: validator,
  );
}
