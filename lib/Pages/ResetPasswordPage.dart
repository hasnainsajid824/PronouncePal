import 'package:final_year_prpject/Theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart'; // Update the import according to your project structure

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Reset Password'),
      //   backgroundColor: const Color(0xffF7614B),
      // ),
      body: SafeArea(
        child:SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image:DecorationImage(image: AssetImage("assets/images/bg kaaliye app.png",),fit: BoxFit.cover),
          ),
        child:
        Column(
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
                              'Reset Password',
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
                'Enter OTP and new password',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  hintText: 'OTP',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_newPasswordController.text !=
                            _confirmPasswordController.text) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match'),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        await Provider.of<AuthProvider>(context, listen: false)
                            .resetPassword(
                          _otpController.text,
                          _newPasswordController.text,
                          _confirmPasswordController.text,
                          context
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Palette.baseElementDark,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Palette.baseElementDark,
                                Palette.baseElementLight,],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 54.h,
                          alignment: Alignment.center,
                          child: Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white, fontSize: 15.58.sp),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
      ),
    ),
      ),
      )
      );
  }
}
