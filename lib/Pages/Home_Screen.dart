import 'package:final_year_prpject/Pages/create_profile.dart';
import 'package:final_year_prpject/Pages/profilepassword_screen.dart';
import 'package:final_year_prpject/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Theme/palette.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthProvider>(context,listen: false).getUserProfile();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:SizedBox(
          height: 844.h,
          width: 390.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 120.h,
                  width: 390.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Palette.baseElementDark,
                          Palette.baseElementLight,
                        ],
                      )
                  ),
                  child:  Center(child: Text('Home',style: TextStyle(fontSize: 18.sp,color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20),
                  child: Column(
                    children: [
                      Consumer<AuthProvider>(

                        builder: (context, profileList, child) {
                          return GridView.count(
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: List.generate(profileList.profilesList.length, (index) {
                              return GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePassword()));

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: SvgPicture.asset("assets/icons/profit.svg")),
                                      Text(profileList.profilesList[index].profileName),
                                      
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );

                        }
                      ),



                      ElevatedButton(
                        onPressed: () {

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProfile()));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient:
                              const LinearGradient(colors: [Color(0xffF7614B), Color(0xffF79448)]),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: 347.88.w,
                            height: 54.h,
                            alignment: Alignment.center,
                            child:  Text(
                              'Create Profile',
                              style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      TextButton(onPressed: () {
                      Provider.of<AuthProvider>(context,listen: false).logout(context);
                      }, child: Text('logout'))

                    ],
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
