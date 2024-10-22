import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController controller = MobileScannerController();
  bool _dialogIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 106, 235, 192),
        title: const Text(
          'Escáner de QR',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: MobileScanner(
          controller: controller,
          onDetect: (BarcodeCapture capture) {
            final List<Barcode> barcodes = capture.barcodes;

            for (final barcode in barcodes) {
              if (barcode.rawValue != null && !_dialogIsOpen) {
                _dialogIsOpen = true; // Evita que se abra el diálogo múltiples veces
                controller.stop(); // Pausa el escáner
                _handleQrContent(context, barcode.rawValue!);
              }
            }
          },
        ),
      ),
    );
  }

  void _handleQrContent(BuildContext context, String qrContent) {
    // Verificamos si es un enlace
    final Uri? url = Uri.tryParse(qrContent);
    if (url != null && (url.scheme == 'http' || url.scheme == 'https')) {
      _showDialog(
        context,
        'Enlace Detectado',
        qrContent,
        actionButton: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No se puede abrir esta URL')),
              );
            }
          },
          child: const Text('Abrir en Navegador'),
        ),
      );
    } else if (qrContent.startsWith('tel:')) {
      // Verificamos si es un número de teléfono
      final String phoneNumber = qrContent.replaceFirst('tel:', '');
      _showDialog(
        context,
        'Número de Teléfono Detectado',
        phoneNumber,
        actionButton: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.green),
          onPressed: () async {
            final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
            if (await canLaunchUrl(telUri)) {
              await launchUrl(telUri);
            }
          },
          child: const Text('Llamar'),
        ),
      );
    } else if (qrContent.startsWith('sms:')) {
      // Verificamos si es un mensaje SMS
      final String messageData = qrContent.replaceFirst('sms:', '');
      _showDialog(
        context,
        'Acción de Mensaje Detectada',
        messageData,
        actionButton: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.orange),
          onPressed: () async {
            final Uri smsUri = Uri(scheme: 'sms', path: messageData);
            if (await canLaunchUrl(smsUri)) {
              await launchUrl(smsUri);
            }
          },
          child: const Text('Enviar SMS'),
        ),
      );
    } else {
      // Si no es ninguno de los anteriores, tratamos el contenido como texto simple
      _showDialog(
        context,
        'Contenido Detectado',
        qrContent,
        actionButton: null,
      );
    }
  }

  void _showDialog(BuildContext context, String title, String qrContent, {TextButton? actionButton}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            qrContent,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            if (actionButton != null) Center(child: actionButton),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                onPressed: () {
                  Navigator.of(context).pop();
                  _dialogIsOpen = false; // Permite reabrir diálogos en futuras detecciones
                  controller.start(); // Reactiva el escáner al cerrar el diálogo
                },
                child: const Text('Cerrar'),
              ),
            ),
          ],
        );
      },
    );
  }
}