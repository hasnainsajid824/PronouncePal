import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';
import '../Services/api.dart';

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
  // List to hold asset paths for images
  List<String> imageAssets = [];
  late String currentImageAsset;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    flutterTts = FlutterTts();

    // Load image assets
    for (int i = 1; i <= 41; i++) {
      imageAssets.add('assets/practice/$i.png');
    }
    setState(() {
      // Change the displayed image
      currentImageAsset = getRandomImageAsset();
    });
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
    String sent_word = isTwoWordMode && words.length > 1
        ? '${words[0]} ${words[1]}'
        : firstWord;
    // final url = Uri.parse('http://192.168.0.104:5000/process_text');
    final url = Uri.parse('${Api.baseUrl}process_text/');
    try {
      final response = await http.post(url,
          // headers: {
          //   'Content-Type': 'application/json',
          // },
          body: {
            'data': sent_word,
          });
      // body: sent_word);

      if (response.statusCode == 200) {
        // print('Response: ${response.body}');
        // return response.body;

        // Decode the JSON response
        var responseData = json.decode(response.body);

        // Assuming the response contains a key 'closest_word'
        String closestWord = responseData['closest_word'];

        print('Closest Word: $closestWord');

        return closestWord;
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
                setState(() {
                  currentImageAsset = getRandomImageAsset();
                });
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
    await flutterTts.setSpeechRate(0.25);
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

  // Function to get a random image asset path
  String getRandomImageAsset() {
    final Random random = Random();
    return imageAssets[random.nextInt(imageAssets.length)];
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
              // Rive animation
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
                          maxBlastForce: 30,
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
                          child: Icon(Icons.mic),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
              if (!isTwoWordMode)
              Positioned(
                top: 75, // Adjust this value as needed
                left: 0,
                right: 145,
                child: SizedBox(
                  width: double.infinity, // Make the Stack fill available width
                  height: 200,
                  child: Stack(
                    children: [
                      // Speech bubble icon at the bottom center
                      Positioned(
                        bottom: 5,
                        left: 0,
                        right: 30,
                        child: Image.asset(
                          'assets/speech.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                      // Image asset centered above the speech bubble
                      Positioned(
                        top: 10,
                        left: 15,
                        child: Image.asset(
                          currentImageAsset,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
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
