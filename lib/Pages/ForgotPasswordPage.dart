import 'package:final_year_prpject/Theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart'; 


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body:
      SafeArea(child:
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image:DecorationImage(image: AssetImage("assets/images/bg kaaliye app.png",),fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SafeArea(
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
                              'Create a Profile',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
              ),
                      SizedBox(
                                height: 250.h,
                                child: Image.asset(
                                  'assets/images/kbooklogo1.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
       Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email to reset your password',
              style: TextStyle(fontSize: 18.sp,
              fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.h),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<AuthProvider>(context, listen: false)
                          .sendResetPasswordOTP(_emailController.text, context);
                      setState(() {
                        _isLoading = false;
                      });
                      
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xffF7614B),
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
                        width: double.infinity,
                        height: 54.h,
                        alignment: Alignment.center,
                        child: Text(
                          'Send OTP',
                          style: TextStyle(color: Colors.white, fontSize: 15.58.sp),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
            ]
          ),
        ),
      ),
      ),
    );
  }
}
