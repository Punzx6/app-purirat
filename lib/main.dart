import 'package:flutter/material.dart'; // นำเข้าแพ็คเกจ Flutter
// นำเข้า mqtt_service.dart
import 'ui/login_page.dart'; // นำเข้า login_page.dart ด้วย

void main() {
  // ฟังก์ชันหลักของแอปพลิเคชัน
  WidgetsFlutterBinding.ensureInitialized(); // เรียกใช้ WidgetsFlutterBinding
  runApp(const MyApp()); // เรียกใช้ MyApp
}

class MyApp extends StatelessWidget {
  // คลาส MyApp ที่เป็น StatelessWidget
  // คลาส MyApp ที่เป็น StatelessWidget
  const MyApp({super.key}); // คอนสตรัคเตอร์ของ MyApp

  @override // ฟังก์ชัน build ที่สร้าง UI ของแอปพลิเคชัน
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soil Moisture App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginPage(), // เปลี่ยนจาก MoisturePage เป็น LoginPage
    );
  }
}
