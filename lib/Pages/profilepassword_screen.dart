import 'package:final_year_prpject/Pages/create_profile.dart';
import 'package:final_year_prpject/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Theme/palette.dart';

class ProfilePassword extends StatefulWidget {
  const ProfilePassword({Key? key}) : super(key: key);

  @override
  State<ProfilePassword> createState() => _ProfilePasswordState();
}

class _ProfilePasswordState extends State<ProfilePassword> {
  TextEditingController passwordController = TextEditingController();
  double _opacity = 0.0;
  double _translationY = 50.0;

  @override
  void initState() {
    super.initState();
    // Adding delay to start the animation after the widget is built
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _translationY = 0.0;
      });
    });
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
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 1750),
                      opacity: _opacity,
                      child: Transform.translate(
                        offset: Offset(0, _translationY),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 250.h,
                                child: Image.asset(
                                  'assets/images/kbooklogo1.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 20),
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
                                  if (value.length < 8) {
                                    return 'Password should be 8 digits';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .loginProfile(
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
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffF7614B),
                                        Color(0xffF79448)
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
                                height: 30,
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .deleteProfile(context);
                                },
                                child: const Text('Delete Profile'),
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
