import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:torch_light/torch_light.dart';

class SensorPlusPage extends StatefulWidget {
  const SensorPlusPage({super.key});

  @override
  _SensorPlusPageState createState() => _SensorPlusPageState();
}

class _SensorPlusPageState extends State<SensorPlusPage> {
  List<double> _accelerometerValues = [0.0, 0.0, 0.0];
  List<double> _gyroscopeValues = [0.0, 0.0, 0.0];
  List<double> _magnetometerValues = [0.0, 0.0, 0.0];
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    });

    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometerValues = <double>[event.x, event.y, event.z];
      });
    });
  }

  Future<void> _toggleTorch() async {
    try {
      if (_isTorchOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer = _accelerometerValues.map((double v) => v.toStringAsFixed(1)).toList();
    final List<String> gyroscope = _gyroscopeValues.map((double v) => v.toStringAsFixed(1)).toList();
    final List<String> magnetometer = _magnetometerValues.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 106, 235, 192),
        title: const Text(
          'Sensores',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: ListView(
          children: [
            _buildSensorCard('Accelerometer', accelerometer),
            _buildSensorCard('Gyroscope', gyroscope),
            _buildSensorCard('Magnetometer', magnetometer),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleTorch,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: _isTorchOn ? const Color.fromARGB(255, 194, 70, 61) : const Color.fromARGB(255, 106, 235, 192),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(_isTorchOn ? 'Apagar linterna' : 'Encender linterna'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(String title, List<String> values) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              values.join(', '),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
