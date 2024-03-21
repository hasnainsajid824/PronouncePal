import 'package:final_year_prpject/rive_animations/state_machine_muscot.dart';
import 'package:flutter/material.dart';

class CharacterAnimation extends StatelessWidget {
  const CharacterAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PronouncePal',
          style: TextStyle(
            color: Colors.white, // Change text color here
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffF79448),
        leading: BackButton(color: Colors.white),
      ),
      body: Container(
        child: Center(
          child: StateMachineMuscot(),
        ),
      ),
    );
  }
}
