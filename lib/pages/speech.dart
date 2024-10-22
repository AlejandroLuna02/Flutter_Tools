import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextView extends StatefulWidget {
  const SpeechToTextView({super.key});

  @override
  State<SpeechToTextView> createState() => _SpeechToTextViewState();
}

class _SpeechToTextViewState extends State<SpeechToTextView> {
  bool _hasSpeech = false;
  final SpeechToText speech = SpeechToText();
  double level = 0.0;
  String lastWords = '';
  String lastError = '';

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
      );
      if (!mounted) return;
      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Error inicializando reconocimiento de voz: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  void startListening() {
    speech.listen(
      onResult: resultListener,
      onSoundLevelChange: soundLevelListener,
      localeId: 'es_ES',
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
    setState(() {
      lastWords = '';
      lastError = '';
    });
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = error.errorMsg;
    });
  }

  void statusListener(String status) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 106, 235, 192),
        title: const Text(
          'Voz a Texto',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SpeechControlWidget(
              hasSpeech: _hasSpeech,
              isListening: speech.isListening,
              startListening: startListening,
              stopListening: stopListening,
            ),
            const SizedBox(height: 20),
            RecognitionResultsWidget(lastWords: lastWords, level: level),
            if (lastError.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('Error: $lastError', style: const TextStyle(color: Color.fromARGB(255, 194, 70, 61))),
            ],
            const SizedBox(height: 20),
            Text(
              speech.isListening ? "Escuchando..." : 'Micrófono apagado',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeechControlWidget extends StatelessWidget {
  final bool hasSpeech;
  final bool isListening;
  final VoidCallback startListening;
  final VoidCallback stopListening;

  const SpeechControlWidget({
    super.key,
    required this.hasSpeech,
    required this.isListening,
    required this.startListening,
    required this.stopListening,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 106, 235, 192)  ,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Escuchar'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: isListening ? stopListening : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 106, 235, 192),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Detener'),
        ),
      ],
    );
  }
}

class RecognitionResultsWidget extends StatelessWidget {
  final String lastWords;
  final double level;

  const RecognitionResultsWidget({super.key, required this.lastWords, required this.level});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Resultado:',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 106, 235, 192),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lastWords.isNotEmpty ? lastWords : 'Habla algo para comenzar...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              if (level > 0) ...[
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: level,
                  backgroundColor: Colors.purple[100],
                  valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 106, 235, 192)!),
                ),
                const SizedBox(height: 5),
                Text(
                  "Nivel de sonido: ${level.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple[800],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
