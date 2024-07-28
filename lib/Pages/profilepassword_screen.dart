import 'package:final_year_prpject/Pages/WordsGridModal.dart';
import 'package:final_year_prpject/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Theme/palette.dart';
import 'edit_profile.dart';

class ProfilePassword extends StatefulWidget {
  const ProfilePassword({Key? key}) : super(key: key);

  @override
  State<ProfilePassword> createState() => _ProfilePasswordState();
}

class _ProfilePasswordState extends State<ProfilePassword> {
  TextEditingController passwordController = TextEditingController();
  double _opacity = 0.0;
  double _translationY = 50.0;
  double _progress = 0.0;
  int _correctlyPronouncedWords = 0;
  int total_words = 0;
  var profileName = "";
  var profileId;
  var password;
  var age;
  List<String> words_to_focus = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _translationY = 0.0;
      });
    });
    _fetchProfileProgress();
  }

  Future<void> _fetchProfileProgress() async {
    final authProvider = context.read<AuthProvider>();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      profileId = prefs.getInt("profile_id");
      profileName = prefs.getString("profile_name")!;
      if (profileId != null) {
        var progressData = await authProvider.getProfileProgress(profileId);
        setState(() {
          age = progressData['age'];
          password = progressData['password'];
          _progress = progressData['progress'].toDouble() / 100;
          _correctlyPronouncedWords =
              progressData['correctly_pronounced_words'];
          total_words = progressData['total_words_attempted'];

          words_to_focus = List<String>.from(progressData['words_to_focus']);
          print(words_to_focus);
        });
      }
    } catch (error) {
      print('Error fetching progress: $error');
    }
  }

  void _showWordsGridModal() {
    showDialog(
      context: context,
      builder: (context) => WordsGridModal(words: words_to_focus),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg kaaliye app.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SizedBox(
              height: 844.h,
              width: 390.w,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 120.h,
                      width: 390.w,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.baseElementDark,
                            Palette.baseElementLight,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Welcome $profileName !',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 1750),
                      opacity: _opacity,
                      child: Transform.translate(
                        offset: Offset(0, _translationY),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20.h), // Adjust top padding if needed
                          child: Column(
                            children: [
                              LinearPercentIndicator(
                                width: 200,
                                animation: true,
                                animationDuration: 1000,
                                lineHeight: 40.0,
                                trailing: Text(
                                  "$total_words\nTotal Attempts",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                percent: _progress,
                                center: Text(
                                  '$_correctlyPronouncedWords correct attempts',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                linearStrokeCap: LinearStrokeCap.butt,
                                linearGradient: const LinearGradient(
                                  colors: [
                                    Palette.baseElementLight,
                                    Palette.baseElementDark,
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              CircularPercentIndicator(
                                radius: 120.0,
                                lineWidth: 13.0,
                                animation: true,
                                animationDuration: 1000,
                                percent: _progress,
                                center: Text(
                                  "${(_progress * 100).toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 38.0,
                                  ),
                                ),
                                footer: const Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          8.0), // Space between indicator and text
                                  child: Text(
                                    "Overall Accuracy",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: const LinearGradient(
                                  colors: [
                                    Palette.baseElementDark,
                                    Palette.baseElementLight,
                                    Palette.baseElementDark,
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  height: 20), // Adjust spacing if needed
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter password';
                                  }
                                  if (value.length < 4) {
                                    return 'Password should be 4 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AuthProvider>().loginProfile(
                                      passwordController.text, context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Palette.baseElementDark,
                                        Palette.baseElementLight,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: 347.88.w,
                                    height: 54.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 18.sp, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ElevatedButton(
                                onPressed: _showWordsGridModal,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Palette.baseElementLight,
                                        Palette.baseElementDark,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: 347.88.w,
                                    height: 54.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Words To Focus',
                                      style: TextStyle(
                                          fontSize: 18.sp, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                            profileId: profileId,
                                            currentName: profileName,
                                            currentAge: age,
                                            currentPassword: password,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Edit Profile'),
                                  ),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<AuthProvider>()
                                          .deleteProfile(context);
                                    },
                                    child: const Text('Delete Profile'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
