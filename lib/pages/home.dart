import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  void _launchCaller(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }

  void _launchSMS(String number) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: {'body': Uri.encodeComponent('Bienvenido')},
    );
    await launchUrl(launchUri);
  }

  void _launchGitHub() async {
    const url = 'https://github.com/AlejandroLuna02/Flutter_Tools.git';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 106, 235, 192),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MyTextWidget(
                controller: _controller,
                onCall: _launchCaller,
                onSMS: _launchSMS
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: const Icon(FontAwesomeIcons.github, color: Colors.white),
        onPressed: _launchGitHub,
        tooltip: 'GitHub',
      ),
    );
  }
}

class MyTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCall;
  final Function(String) onSMS;

  const MyTextWidget({super.key, required this.controller, required this.onCall, required this.onSMS});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Jesus Alejandro Guillen Luna',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Desarrollador de Software\n'
            '221198\n'
            'Universidad Politécnica de Chiapas',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () => onCall('9651052289'),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.message, color: Colors.blue),
                onPressed: () => onSMS('9651052289'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
