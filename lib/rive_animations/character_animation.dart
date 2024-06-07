import 'package:flutter/material.dart';
import 'package:final_year_prpject/rive_animations/state_machine_muscot.dart';
import 'package:final_year_prpject/Pages/Home_Screen.dart';

class CharacterAnimation extends StatefulWidget {
  const CharacterAnimation({Key? key}) : super(key: key);

  @override
  _CharacterAnimationState createState() => _CharacterAnimationState();
}

class _CharacterAnimationState extends State<CharacterAnimation> {
  bool isNavigationLocked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isNavigationLocked) {
          // If navigation is locked, prevent back navigation
          return false;
        } else {
          // Otherwise, allow back navigation
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PronouncePal',
            style: TextStyle(
              color: Colors.white, // Change text color here
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xffF79448),
          leading: isNavigationLocked
              ? null
              : IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()), 
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isNavigationLocked = !isNavigationLocked;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.lock,
                      color: isNavigationLocked ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: StateMachineMuscot(),
          ),
        ),
      ),
    );
  }
}
