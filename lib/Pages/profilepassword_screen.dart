import 'package:final_year_prpject/Pages/create_profile.dart';
import 'package:final_year_prpject/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Theme/palette.dart';

class ProfilePassword extends StatefulWidget {
  const ProfilePassword({Key? key}) : super(key: key);

  @override
  State<ProfilePassword> createState() => _ProfilePasswordState();
}

class _ProfilePasswordState extends State<ProfilePassword> {
  TextEditingController passwordController = TextEditingController();

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
                  child:  Center(child: Text('Login to your profile',style: TextStyle(fontSize: 18.sp,color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
                SizedBox(height: 30,),


                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
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
                        return 'enter password';
                      }
                      if (value.length < 8) {
                        return 'password should be 8 digits';
                      }
                      return null;
                    },

                  ),
                ),
                SizedBox(height: 30,),

                ElevatedButton(
                  onPressed: () {
                 Provider.of<AuthProvider>(context,listen: false).loginProfile(passwordController.text, context);
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
                        'Login',
                        style:
                        TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
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
