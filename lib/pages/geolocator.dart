import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationStatusScreen extends StatefulWidget {
  const LocationStatusScreen({super.key});

  @override
  _LocationStatusScreenState createState() => _LocationStatusScreenState();
}

class _LocationStatusScreenState extends State<LocationStatusScreen> {
  final double _thresholdDistance = 5.0;
  Position? _lastPosition;
  DateTime? _lastUpdateTime;
  final int _minTimeBetweenUpdates = 5;
  String _locationStatus = 'Desconocido';

  @override
  void initState() {
    super.initState();
    _getLocationStatus();
  }

  Future<void> _getLocationStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationStatus = 'Servicio de localización deshabilitado');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationStatus = 'Permiso de localización denegado');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _locationStatus = 'Permiso de localización denegado permanentemente');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    DateTime currentTime = DateTime.now();
    if (_lastPosition != null && _lastUpdateTime != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude, _lastPosition!.longitude, position.latitude, position.longitude);
      int timeDifference = currentTime.difference(_lastUpdateTime!).inSeconds;
      if (distance > _thresholdDistance && timeDifference < _minTimeBetweenUpdates) {
        setState(() => _locationStatus = 'Movimiento rápido detectado: ${distance.toStringAsFixed(2)} m en $timeDifference s');
      } else {
        setState(() => _locationStatus = 'Ubicación actual: ${position.latitude}, ${position.longitude}');
      }
    } else {
      setState(() => _locationStatus = 'Ubicación inicial: ${position.latitude}, ${position.longitude}');
    }

    _lastPosition = position;
    _lastUpdateTime = currentTime;
  }

  Future<void> _openInGoogleMaps() async {
    if (_lastPosition != null) {
      final String url = 'https://www.google.com/maps/search/?api=1&query=${_lastPosition!.latitude},${_lastPosition!.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'No se pudo abrir Google Maps';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación en Tiempo Real', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: const Color.fromARGB(255, 106, 235, 192),
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 106, 235, 192)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 80,
                color: _locationStatus.contains('detectado') ? const Color.fromARGB(255, 194, 70, 61) : const Color.fromARGB(255, 106, 235, 192),
              ),
              SizedBox(height: 20),
              Text(
                _locationStatus,
                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 181, 141, 250), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getLocationStatus,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 181, 141, 250),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Actualizar Ubicación'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _lastPosition != null ? _openInGoogleMaps : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 181, 141, 250),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Ver en Google Maps'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
