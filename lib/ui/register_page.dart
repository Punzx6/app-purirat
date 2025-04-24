import 'package:flutter/material.dart';
import 'package:myproject/ui/user_store.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final fullCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final userCtrl  = TextEditingController();
  final passCtrl  = TextEditingController();
  bool obscure = true;

  Future<void> _register() async {
    if (!formKey.currentState!.validate()) return;

    // ตรวจ username ซ้ำ
    final exists = await UserStore.find(userCtrl.text.trim());
    if (exists != null && exists.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username นี้ถูกใช้แล้ว')),
      );
      return;
    }

    // เก็บลง UserStore (SharedPreferences)
    await UserStore.add({
      'fullName':  fullCtrl.text.trim(),
      'email':     emailCtrl.text.trim(),
      'phone':     phoneCtrl.text.trim(),
      'username':  userCtrl.text.trim(),
      'password':  passCtrl.text,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')),
    );
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลังจาง
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
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Create Account',
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(color: theme.primaryColor)),
                        const SizedBox(height: 20),
                        _field(fullCtrl, 'Full name', Icons.person),
                        _field(emailCtrl, 'Email', Icons.email,
                            keyType: TextInputType.emailAddress,
                            validator: (v) =>
                                v!.contains('@') ? null : 'อีเมลไม่ถูกต้อง'),
                        _field(phoneCtrl, 'Phone', Icons.phone,
                            keyType: TextInputType.phone,
                            validator: (v) =>
                                v!.length < 8 ? 'เบอร์ไม่น้อยกว่า 8 ตัว' : null),
                        _field(userCtrl, 'Username', Icons.account_circle),
                        // Password
                        TextFormField(
                          controller: passCtrl,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  obscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () =>
                                  setState(() => obscure = !obscure),
                            ),
                          ),
                          validator: (v) =>
                              v!.length < 4 ? 'อย่างน้อย 4 ตัว' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('REGISTER',
                                style: TextStyle(fontSize: 16)),
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

  // ----- helper widget -------
  Widget _field(TextEditingController c, String label, IconData ic,
      {TextInputType keyType = TextInputType.text,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          prefixIcon: Icon(ic),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyType,
        validator: validator ?? (v) => v!.isEmpty ? 'กรอก $label' : null,
      ),
    );
  }
}
