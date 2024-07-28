import 'package:final_year_prpject/Theme/palette.dart';
import 'package:flutter/material.dart';

class WordsGridModal extends StatelessWidget {
  final List<String> words;

  const WordsGridModal({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Words to Focus'),
      content: SingleChildScrollView(
        child: words.isEmpty
            ? const Center(
                child: Text(
                  'No words to focus on.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                itemCount: words.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: Palette.baseElementLight,
                    child: Center(
                      child: Text(
                        words[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NotoNastaliqUrdu',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
