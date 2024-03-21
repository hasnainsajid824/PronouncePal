import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';

enum TtsState { playing, stopped }

class StateMachineMuscot extends StatefulWidget {
  const StateMachineMuscot({Key? key}) : super(key: key);

  @override
  _StateMachineMuscotState createState() => _StateMachineMuscotState();
}

class _StateMachineMuscotState extends State<StateMachineMuscot> {
  Artboard? riveArtboard;
  SMIBool? isDance;
  SMITrigger? isLookUp;
  late stt.SpeechToText _speech;
  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  String text = '';
  final _confetti = ConfettiController(duration: const Duration(seconds: 5));
  bool isTwoWordMode = false; // Track the mode

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    flutterTts = FlutterTts();

    rootBundle.load('assets/dash_flutter_muscot.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          var controller =
              StateMachineController.fromArtboard(artboard, 'birb');
          if (controller != null) {
            artboard.addController(controller);
            isDance = controller.findSMI('dance');
            isLookUp = controller.findSMI('look up');
          }
          setState(() => riveArtboard = artboard);
        } catch (e) {
          print(e);
        }
      },
    );
  }

  void toggleDance(bool newValue) {
    setState(() => isDance!.value = newValue);
  }

  Future<String> processText(String text) async {
    // Split the recognized text into words
    List<String> words = text.split(' ');

    // Take the first word
    String firstWord = words.isNotEmpty ? words.first : '';
    final url = Uri.parse('http://192.168.69.94:5000/process_text');
    try {
      final response = await http.post(
        url,
        body: isTwoWordMode && words.length > 1
            ? '${words[0]} ${words[1]}'
            : firstWord,
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return response.body;
        // Handle the response as needed
      } else {
        print('Request failed with status: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error occurred during HTTP request: $e');
      return '';
    }
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (error) {
        print('Speech recognition error: $error');
        speak('دوبارہ بولیں');
      },
    );
    if (available) {
      _speech.listen(
        onResult: (result) async {
          if (result.finalResult) {
            setState(() {
              text = result.recognizedWords;
            });
            print(text);
            if (text == '') {
              speak(text);
            } else {
              String processedText = await processText(text);
              if (processedText.trim() == text.trim()) {
                speak('شہباش');
                playConfettiAnimation();
              } else {
                setState(() {
                  text = processedText;
                });

                speak(text);
              }
            }
          }
        },
        listenFor: Duration(seconds: 5),
        localeId: 'ur_PK', // Urdu (Pakistan)
      );
    } else {
      print('The user denied the use of speech recognition.');
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  void playConfettiAnimation() {
    _confetti.play();
  }

  Future<void> speak(String speaktext) async {
    toggleDance(true);
    await flutterTts.setLanguage('ur-PK');
    await flutterTts.setPitch(1.7);
    await flutterTts.setSpeechRate(0.30);
    await flutterTts.setVolume(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    flutterTts.setCompletionHandler(() {
      toggleDance(false); // Toggle dance off when speaking is complete
      setState(() {
        text = '';
      });
    });
    if (speaktext == '') {
      await flutterTts.speak('دوبارہ بولیں');
    } else {
      await flutterTts.speak(speaktext);
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'),
            fit: BoxFit.cover,
          ),
        ),
          child: Stack(
            children: [
              riveArtboard == null
                  ? const SizedBox()
                  : Column(
                      children: [
                        Expanded(
                          child: Rive(
                            artboard: riveArtboard!,
                          ),
                        ),
                        ConfettiWidget(
                          confettiController: _confetti,
                          blastDirectionality: BlastDirectionality.explosive,
                          maxBlastForce: 30, // Adjust maximum blast force
                          minBlastForce: 10,
                          shouldLoop: false,
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.pink,
                            Colors.orange,
                            Colors.purple
                          ],
                        ),
                        const SizedBox(height: 12),
                        FloatingActionButton(
                          onPressed: () {
                            if (_speech.isListening) {
                              stopListening();
                            } else {
                              startListening();
                              isLookUp?.value = true;
                            }
                          },
                          backgroundColor: Color.fromARGB(255, 87, 175, 247),
                          child:
                              Icon(Icons.mic),
          
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
              Positioned(
                top: 20,
                right: 20,
                child: Row(
                  children: [
                    Text(isTwoWordMode ? 'Multiple words' : 'Single word'),
                    Switch(
                      value: isTwoWordMode,
                      onChanged: (newValue) {
                        setState(() {
                          isTwoWordMode = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
