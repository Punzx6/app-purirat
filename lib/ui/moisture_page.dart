import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mqtt_service.dart';

class MoisturePage extends StatefulWidget {
  const MoisturePage({super.key});

  @override
  State<MoisturePage> createState() => _MoisturePageState();
}

class _MoisturePageState extends State<MoisturePage> {
  String humidity = "รอข้อมูล...";
  String temperature = "รอข้อมูล...";
  String connectionStatus = "⏳ กำลังเชื่อมต่อ...";
  List<String> humidityHistory = [];
  List<String> temperatureHistory = [];

  final MQTTService mqttService = MQTTService();

  @override
  void initState() {
    super.initState();
    loadHistory();

    mqttService.connect(
      (h, t) {
        final timestamp = TimeOfDay.now().format(context);

        setState(() {
          humidity = "$h%";
          temperature = "$t°C";

          humidityHistory.insert(0, "Humidity: $h% @ $timestamp");
          temperatureHistory.insert(0, "Temp: $t°C @ $timestamp");

          saveHistory();
        });
      },
      (status) {
        setState(() {
          connectionStatus = status;
        });
      },
    );
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('humidityHistory', humidityHistory);
    prefs.setStringList('temperatureHistory', temperatureHistory);
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      humidityHistory = prefs.getStringList('humidityHistory') ?? [];
      temperatureHistory = prefs.getStringList('temperatureHistory') ?? [];
    });
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('humidityHistory');
    await prefs.remove('temperatureHistory');
    setState(() {
      humidityHistory.clear();
      temperatureHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature & Humidity"),
        backgroundColor: Colors.green.shade700,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Text(
                connectionStatus,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCard("💧 ความชื้น", humidity),
            const SizedBox(height: 10),
            buildCard("🌡️ อุณหภูมิ", temperature),
            const Divider(height: 30),

            const Text(
              "📊 ประวัติความชื้น:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: humidityHistory.length,
                itemBuilder:
                    (context, index) =>
                        ListTile(title: Text(humidityHistory[index])),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "📊 ประวัติอุณหภูมิ:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: temperatureHistory.length,
                itemBuilder:
                    (context, index) =>
                        ListTile(title: Text(temperatureHistory[index])),
              ),
            ),

            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: clearHistory,
                icon: const Icon(Icons.delete_forever),
                label: const Text("ล้างประวัติ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, String value) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.thermostat_outlined),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
