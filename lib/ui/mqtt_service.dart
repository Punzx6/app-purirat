import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final client = MqttServerClient('mqtt.eclipseprojects.io', '');
  String latestHumidity = '';
  String latestTemperature = '';

  Future<void> connect(
    Function(String humidity, String temperature) onDataReceived,
    Function(String status) onStatusChanged,
  ) async {
    client.logging(on: true); // ✅ เปิด log ภายใน library

    client.port = 1883;
    client.keepAlivePeriod = 20;

    client.onDisconnected = () {
      print("❌ [MQTT] Disconnected from broker");
      onStatusChanged("❌ ตัดการเชื่อมต่อ");
    };

    client.onConnected = () {
      print("✅ [MQTT] Connected to mqtt.eclipseprojects.io");
      onStatusChanged("✅ เชื่อมต่อแล้ว");
    };

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
          'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
        )
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      print("🔌 [MQTT] Attempting connection...");
      await client.connect();
    } catch (e) {
      print("🚫 [MQTT] Connection failed: $e");
      onStatusChanged("❌ เชื่อมต่อล้มเหลว");
      client.disconnect();
      return;
    }

    client.subscribe("esp32/humi", MqttQos.atMostOnce);
    client.subscribe("esp32/temp", MqttQos.atMostOnce);

    print("📡 [MQTT] Subscribed to topics: esp32/humi, esp32/tempe");

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMsg = messages[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMsg.payload.message,
      );
      final topic = messages[0].topic;

      print("📥 [MQTT] Received message on topic [$topic]: $payload");

      if (topic == "esp32/humi") {
        latestHumidity = payload;
      } else if (topic == "esp32/temp") {
        latestTemperature = payload;
      }

      if (latestHumidity.isNotEmpty && latestTemperature.isNotEmpty) {
        print(
          "📊 [MQTT] Passing data to UI -> Humi: $latestHumidity, Temp: $latestTemperature",
        );
        onDataReceived(latestHumidity, latestTemperature);
      }
    });
  }
}
