import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import 'Home_Screen.dart';
import 'signin_screen.dart';
import '../Services/api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _translationY = 50.0;
  TextEditingController _baseUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Adding delay to start the animation after the widget is built
    check();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _translationY = 0.0;
      });
    });
  }

  check() async {
    var response =
        await Provider.of<AuthProvider>(context, listen: false).checkLoggedIn();
    print('response $response');

    if (response == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg kaaliye app.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedOpacity(
                  duration: Duration(milliseconds: 1500),
                  opacity: _opacity,
                  child: Image.asset(
                    "assets/images/kbooklogo1.png",
                    height: 270.h,
                    width: 300.w,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Transform.translate(
                  offset: Offset(0, _translationY),
                  child: Container(
                    height: 400.h,
                    width: 390.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          "Speech Therapy Re-imagined!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "An AI-Powered tool to improve Speech",
                          style: TextStyle(
                            color: Color(0xffAEAEAE),
                            fontSize: 15.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    )),
                                transition: Transition.zoom);
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
                                colors: [Color(0xffF7614B), Color(0xffF79448)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 347.88.w,
                              height: 54.h,
                              alignment: Alignment.center,
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 10),
                        // TextFormField(
                        //   controller: _baseUrlController,
                        //   decoration: InputDecoration(
                        //     labelText: 'API Base URL',
                        //     hintText: 'Enter API Base URL',
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                        // SizedBox(height: 20),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     final newBaseUrl = _baseUrlController.text;
                        //     // Validate newBaseUrl and update Api.baseUrl if necessary
                        //     Api.baseUrl = newBaseUrl;
                        //     // Now you can navigate to next screen or perform any action
                        //   },
                        //   child: Text('Update API Base URL'),
                        // ),
                      ],
                    ),
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
