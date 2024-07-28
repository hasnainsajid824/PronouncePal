import 'package:final_year_prpject/Pages/create_profile.dart';
import 'package:final_year_prpject/Pages/profilepassword_screen.dart';
import 'package:final_year_prpject/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../Theme/palette.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String routeName = '/home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _listVisible = false;
    List<String> imageAssets = [];
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getUserProfile();
    // Adding delay to simulate loading animation
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _listVisible = true;
      });
    });
    for (int i = 1; i <= 30; i++) {
      imageAssets.add('assets/practice/$i.png');
    }
  }
  String getRandomImageAsset() {
    final Random random = Random();
    String img = imageAssets[random.nextInt(imageAssets.length)];
    if (img == 'assets/practice/32.png')
    {
      img = imageAssets[random.nextInt(imageAssets.length)];
    }
    return img;
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Set background color to transparent
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg kaaliye app.png', // Replace with your image path
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
                      duration: const Duration(milliseconds: 100),
                      opacity: _listVisible ? 1.0 : 0.0,
                      child: Container(
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
                            'Home',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          SizedBox(height:70.h),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 1000),
                            opacity: _listVisible ? 1.0 : 0.0,
                            child: Consumer<AuthProvider>(
                              builder: (context, profileList, child) {
                                return GridView.count(
                                  primary: false,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(20),
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 30,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                    profileList.profilesList.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final selectedProfileName = profileList.profilesList[index].profileName;
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString('profile_name', selectedProfileName);
                                          final profileId = await Provider.of<AuthProvider>(context, listen: false).getProfileId(selectedProfileName);
                                          prefs.setInt('profile_id', profileId!);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfilePassword(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Image.asset(
                                                  getRandomImageAsset(),
                                                  width: 100, 
                                                  height: 100,
                                                ),
                                              ),
                                              Text(profileList
                                                  .profilesList[index]
                                                  .profileName),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 1400),
                            opacity: _listVisible ? 1.0 : 0.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateProfile(),
                                  ),
                                );
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
                                    'Create Profile',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 1750),
                            opacity: _listVisible ? 1.0 : 0.0,
                            child: TextButton(
                              onPressed: () {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .logout(context);
                              },
                              child: const Text('logout'),
                            ),
                          )
                        ],
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
