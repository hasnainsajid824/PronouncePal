import 'package:final_year_prpject/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Scaffold(
      body: SafeArea(child:
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image:DecorationImage(image: AssetImage("assets/images/bg kaaliye app.png",),fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                        height: 120.h,
                        width: 390.w,
                        decoration: BoxDecoration(
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
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                child: Column(
                  children: [
                    SizedBox(height:10.h),

                    Padding(
                      padding:  EdgeInsets.only(left: 20.w,right: 20.w,top: 20.h),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Name';
                                }
                                return null;
                              },

                            ),

                            SizedBox(height: 10.h),
                            TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Age',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Age';
                                }
                                return null;
                              },

                            ),
                            SizedBox(height: 10.h),
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


                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h,),
                    ElevatedButton(
                      onPressed: ()  {

                        Provider.of<AuthProvider>(context,listen: false).createProfile(nameController.text, ageController.text, passwordController.text, context);
                        // Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => CharacterAnimation()));
                          
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
                            'Create',
                            style:
                            TextStyle(fontSize: 15.58.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h,),




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
