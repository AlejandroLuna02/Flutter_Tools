import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechView extends StatefulWidget {
  const TextToSpeechView({super.key});

  @override
  State<TextToSpeechView> createState() => _TextToSpeechViewState();
}

enum TtsState { playing, stopped, paused, continued }

class _TextToSpeechViewState extends State<TextToSpeechView> {
  late FlutterTts flutterTts;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText;
  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  void initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<void> _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null && _newVoiceText!.isNotEmpty) {
      await flutterTts.speak(_newVoiceText!);
    }
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future<void> _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 106, 235, 192),
        title: const Text(
          'Texto a Voz',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _inputSection(),
            const SizedBox(height: 20),
            _btnSection(),
            const SizedBox(height: 20),
            _buildSliders(),
          ],
        ),
      ),
    );
  }

  Widget _inputSection() => TextField(
        maxLines: 4,
        onChanged: _onChange,
        decoration: InputDecoration(
          hintText: 'Escribe aquí para convertir en voz...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.all(10),
        ),
      );

  Widget _btnSection() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(Icons.play_arrow, 'PLAY', _speak, Colors.green),
          _buildButton(Icons.stop, 'STOP', _stop, Colors.red),
          _buildButton(Icons.pause, 'PAUSE', _pause, Colors.blue),
        ],
      );

  Widget _buildButton(IconData icon, String label, Function() onPressed, Color color) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
          Text(label, style: TextStyle(color: color)),
        ],
      );

  Widget _buildSliders() => Column(
        children: [
          _buildSlider('Volume', volume, 0.0, 1.0, (val) => setState(() => volume = val)),
          _buildSlider('Pitch', pitch, 0.5, 2.0, (val) => setState(() => pitch = val)),
          _buildSlider('Rate', rate, 0.0, 1.0, (val) => setState(() => rate = val)),
        ],
      );

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) => Slider(
        value: value,
        min: min,
        max: max,
        divisions: 10,
        label: '$label: ${value.toStringAsFixed(2)}',
        onChanged: onChanged,
      );
}
