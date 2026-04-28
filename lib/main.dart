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
  String response = "";

  input = input.toLowerCase();

  if (input.contains("farmer")) {
    response =
        "You are eligible for PM Kisan scheme. You can receive financial support from the government.";
  } 
  else if (input.contains("job")) {
    response =
        "You can apply for MGNREGA for rural employment opportunities.";
  } 
  else if (input.contains("crop")) {
    response =
        "Based on the season, you can grow rice, millets, or maize.";
  } 
  else if (input.contains("pest")) {
    response =
        "Use organic pesticides and monitor crop health regularly.";
  } 
  else {
    response =
        "Sorry, I can help with farming advice and government schemes.";
  }

  setState(() {
    text = response;
  });

  await tts.speak(response);
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFFA5D6A7),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                Icons.smart_toy,
                size: 90,
                color: Colors.white,
              ),

              SizedBox(height: 20),

              Text(
                "Rural AI Assistant",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Voice-based farming & scheme support",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              SizedBox(height: 50),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 50),

              GestureDetector(
                onTap:
                    isListening ? stopListening : startListening,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isListening ? Colors.red : Colors.green,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Icon(
                    isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                isListening
                    ? "Listening..."
                    : "Tap the mic to speak",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}