import 'dart:convert';

import 'package:final_year_prpject/Model/profile_model.dart';
import 'package:final_year_prpject/Pages/Home_Screen.dart';
import 'package:final_year_prpject/rive_animations/character_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/signin_screen.dart';
import '../Services/api.dart';
import '../Theme/palette.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;

  List<UserProfileModel> _profilesList = [];

  loading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
                child: CircularProgressIndicator(
              color: Palette.baseElementLight,
            )));
  }

  void _showMessage(BuildContext context, String message,
      {bool isSuccess = true}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  signup(
      String firstName, lastName, email, password, BuildContext context) async {
    try {
      loading(context);
      var response =
          await http.post(Uri.parse('${Api.baseUrl}register/'), body: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
      });
      // Navigator.of(Values.navigatorKey.currentContext!).pop();
      print('signup status code ${response.statusCode}');
      print('signup response body ${response.body}');
      var parsedJson = json.decode(response.body);

      if (response.statusCode == 201) {
        saveToken(parsedJson['token']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false);
        _showMessage(context, 'Sign Up was Successful !', isSuccess: true);
      } else {
        _showMessage(context, 'Sign Up was Unsuccessful !', isSuccess: false);
      }
    } catch (e) {
    } finally {
      // Hide loading indicator when operation completes
      // Navigator.of(context, rootNavigator: true).pop();
      notifyListeners();
    }
  }

  Future<void> saveToken(Map<String, dynamic> tokenData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = tokenData['access'];

    await prefs.setString('access_token', accessToken);
    // You can also save the 'refresh' token if needed
    String refreshToken = tokenData['refresh'];
    await prefs.setString('refresh_token', refreshToken);
  }

  signIn(String email, password, BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? accessToken = prefs.getString('access_token');
      var response =
          await http.post(Uri.parse('${Api.baseUrl}login/'), headers: {
        // 'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      }, body: {
        "email": email,
        "password": password,
      });

      print('signin status code ${response.statusCode}');
      print('signin response body ${response.body}');
      var parsedJson = json.decode(response.body);

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
        _showMessage(context, 'Login Successful !', isSuccess: true);
      } else {
        _showMessage(context, 'Login Failed !', isSuccess: false);
      }
    } catch (e) {
    } finally {
      // Hide loading indicator when operation completes
      // Navigator.of(context, rootNavigator: true).pop();
      notifyListeners();
    }
  }

  createProfile(String name, age, password, BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      var response = await http.post(
        Uri.parse('${Api.baseUrl}create_profiles/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "profile_name": name,
          "age": age,
          "password": password,
        }),
      );
      print("token :$accessToken");
      print('Request Headers: ${response.request!.headers}');
      print('signin status code ${response.statusCode}');
      print('profile response  ${response.body}');
      if (response.statusCode == 201) {
        var parsedJson = json.decode(response.body);
        int userId = parsedJson['user'];
        prefs.setInt('user_id', userId);
        print("id  $userId");
        String profileName = parsedJson['profile_name']; // Extract profile name
        prefs.setString('profile_name', profileName); // Save profile name
        print("profile name: $profileName");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
        _showMessage(context, 'Profile was Create Successfully !',
            isSuccess: true);
      } else {
        _showMessage(context, 'Profile Creation Failed !', isSuccess: false);
      }
    } catch (e) {
      print('Error creating profile: $e');
    } finally {
      // Hide loading indicator when operation completes
      notifyListeners();
    }
  }

  getUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        // Handle the case where the user ID is not available
        return;
      }
      var response = await http.get(
        Uri.parse('${Api.baseUrl}list_profiles/$userId/'),
      );
      print('status code ${response.statusCode}');
      print('response getUserProfile ${response.body}');
      var parsedJson = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = parsedJson as List;
        _profilesList = data.map((e) => UserProfileModel.fromJson(e)).toList();
      } else {}
    } catch (error, st) {
      print('catch error in authprovider getUserProfile $error $st');
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token'); // Remove the access token

      // Navigate to the sign-in screen. You can replace SignInScreen with the actual screen/widget for signing in.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
        (route) => false,
      );
      _showMessage(context, 'User Logged Out !', isSuccess: true);
    } catch (e) {
      // Handle any errors if necessary
    } finally {
      notifyListeners();
    }
  }

  loginProfile(String password, BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? profileName = prefs.getString('profile_name');
      var response = await http.post(
        Uri.parse('${Api.baseUrl}login/profile'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "password": password,
          "profile_name": profileName,
        }),
      );
      print('signin status code ${response.statusCode}');
      print('loginprofile response  ${response.body}');
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CharacterAnimation()),
            (route) => false);
        _showMessage(context, 'Success!', isSuccess: true);
      } else {
        _showMessage(context, 'Wrong Password !', isSuccess: false);
      }
    } catch (e) {
      print('Error creating profile: $e');
    } finally {
      notifyListeners();
    }
  }

  checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      return true;
    } else {
      return false;
    }
  }

  List<UserProfileModel> get profilesList => _profilesList;
}
