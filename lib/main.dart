import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoiceScreen(),
    );
  }
}

class VoiceScreen extends StatefulWidget {
  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  SpeechToText speech = SpeechToText();
  FlutterTts tts = FlutterTts();

  bool isListening = false;
  String text = "Press mic and speak";

  void startListening() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() => isListening = true);

      speech.listen(onResult: (result) {
        setState(() {
          text = result.recognizedWords;
        });
      });
    }
  }

  void stopListening() async {
    await speech.stop();
    setState(() => isListening = false);
    speakResponse(text);
  }

  void speakResponse(String input) async {
    String response = "You said: $input";
    setState(() => text = response);

    await tts.speak(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rural AI Assistant"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              FloatingActionButton(
                onPressed: isListening ? stopListening : startListening,
                backgroundColor: Colors.green,
                child: Icon(isListening ? Icons.stop : Icons.mic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}