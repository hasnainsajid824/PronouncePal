import 'dart:convert';
import 'package:final_year_prpject/Model/profile_model.dart';
import 'package:final_year_prpject/Pages/Home_Screen.dart';
import 'package:final_year_prpject/Pages/ResetPasswordPage.dart';
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
        Navigator.of(context, rootNavigator: true).pop();
        _showMessage(context, 'Sign Up was Unsuccessful !', isSuccess: false);
      }
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveToken(Map<String, dynamic> tokenData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = tokenData['access'];
    await prefs.setString('access_token', accessToken);
    String refreshToken = tokenData['refresh'];
    await prefs.setString('refresh_token', refreshToken);
  }

  signIn(String email, password, BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      var response = await http.post(Uri.parse('${Api.baseUrl}login/'), body: {
        "email": email,
        "password": password,
      });
      print('signin status code ${response.statusCode}');
      print('signin response body ${response.body}');
      var parsedJson = json.decode(response.body);

      if (response.statusCode == 200) {
        int userId = parsedJson['user_id'];
        prefs.setInt('user_id', userId);
        saveToken(parsedJson['token']);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
        _showMessage(context, 'Login Successful !', isSuccess: true);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        _showMessage(context, 'Email or Password is not Valid',
            isSuccess: false);
      }
    } catch (e) {
    } finally {
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
        String profileName = parsedJson['profile_name'];
        prefs.setString('profile_name', profileName);
        print("profile name: $profileName");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
        _showMessage(context, 'Profile was Create Successfully !',
            isSuccess: true);
      } else {
        var parsedJson = json.decode(response.body);
        String message = parsedJson['detail'];
        Navigator.of(context, rootNavigator: true).pop();
        if (message != '') {
          _showMessage(context, message, isSuccess: false);
        } else {
          _showMessage(context, 'Profile Creation Failed !', isSuccess: false);
        }
      }
    } catch (e) {
      print('Error creating profile: $e');
    } finally {
      notifyListeners();
    }
  }

  editProfile(int profileId, String name, String age, String password,
      BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      final response = await http.put(
        Uri.parse('${Api.baseUrl}profile/edit/$profileId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'profile_name': name,
          'age': age,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
        _showMessage(context, 'Profile updated successfully!', isSuccess: true);
      } else {
        Navigator.of(context, rootNavigator: true).pop();

        _showMessage(context, 'Failed to update Profile!', isSuccess: false);
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();

      _showMessage(context, 'An error occured!', isSuccess: false);
    }
  }

  Future<int?> getProfileId(String profileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) {
      print('User ID is null');
      return null;
    }

    print(
        'Requesting profile ID for user ID: $userId, profile name: $profileName');

    var encodedProfileName = Uri.encodeComponent(profileName);
    var response = await http.get(
      Uri.parse('${Api.baseUrl}profile_id/$userId/$encodedProfileName/'),
      headers: {
        'Authorization': 'Bearer ${prefs.getString('access_token')}',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      return parsedJson['profile_id'];
    } else {
      return null;
    }
  }

  deleteProfile(BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? profileName = prefs.getString('profile_name');
      if (profileName == null) {
        Navigator.of(context, rootNavigator: true).pop();
        _showMessage(context, 'Profile not found!', isSuccess: false);
        return;
      }

      int? profileId = await getProfileId(profileName);
      if (profileId == null) {
        Navigator.of(context, rootNavigator: true).pop();
        _showMessage(context, 'Profile ID not found!', isSuccess: false);
        return;
      }

      String? accessToken = prefs.getString('access_token');
      var response = await http.delete(
        Uri.parse('${Api.baseUrl}delete_profile/$profileId/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      print('Delete profile status code ${response.statusCode}');
      print('Delete profile response ${response.body}');
      if (response.statusCode == 204) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (route) => false,
        );
        _showMessage(context, 'Profile deleted successfully!', isSuccess: true);
      } else {
        _showMessage(context, 'Failed to delete profile!', isSuccess: false);
      }
    } catch (error, st) {
      print('Error deleting profile: $error $st');
    } finally {
      notifyListeners();
    }
  }

  getUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      if (userId == null) return;
      var response = await http.get(
        Uri.parse('${Api.baseUrl}list_profiles/$userId/'),
      );
      print('status code ${response.statusCode}');
      print('response getUserProfile ${response.body}');
      var parsedJson = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = parsedJson as List;
        _profilesList = data.map((e) => UserProfileModel.fromJson(e)).toList();
      }
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
      await prefs.remove('access_token');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
        (route) => false,
      );
      _showMessage(context, 'User Logged Out !', isSuccess: true);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  loginProfile(String password, BuildContext context) async {
    try {
      loading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? profileName = prefs.getString('profile_name');
      int? profileId = prefs.getInt('profile_id');
      var response = await http.post(
        Uri.parse('${Api.baseUrl}login/profile'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "password": password,
          "profile_name": profileName,
          "profile_id": profileId.toString(),
        }),
      );
      print('signin status code ${response.statusCode}');
      print('loginprofile response  ${response.body}');
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);

        Navigator.of(context, rootNavigator: true).pop();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CharacterAnimation()),
          (Route<dynamic> route) => route.settings.name == Home.routeName,
        );
        _showMessage(context, 'Success!', isSuccess: true);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        _showMessage(context, 'Wrong Password !', isSuccess: false);
      }
    } catch (e) {
      print('Error creating profile: $e');
    } finally {
      notifyListeners();
    }
  }

  getProfileProgress(int profileId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? token = prefs.getString('token');
    // final profileId = prefs.getInt("profile_id");
    final response = await http.get(
      Uri.parse('${Api.baseUrl}profile-progress/$profileId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // return json.decode(response.body);
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load progress');
    }
  }

  checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    return accessToken == null;
  }

  // Function to send OTP for password reset
  sendResetPasswordOTP(String email, BuildContext context) async {
    final url = Uri.parse('${Api.baseUrl}send-reset-otp/');
    try {
      final response = await http.post(
        url,
        body: json.encode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // OTP sent successfully
        print('OTP sent to email');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ResetPasswordPage()),
            (route) => false);
        _showMessage(context, 'OTP sent to email', isSuccess: true);
      } else {
        // Handle error
        print('Failed to send OTP');
        _showMessage(context, 'Failed to send OTP', isSuccess: false);
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  // Function to reset password
  resetPassword(String otp, String newPassword, String confirmPassword,
      BuildContext context) async {
    final url = Uri.parse('${Api.baseUrl}reset-password/');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'otp': otp,
          'new_password': newPassword,
          'confirm_password': confirmPassword
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Password reset successfully
        _showMessage(context, 'Password reset successfully', isSuccess: true);
        print('Password reset successfully');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false);
      } else {
        // Handle error
        print('Failed to reset password');
        _showMessage(context, 'Failed to reset password', isSuccess: false);
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  List<UserProfileModel> get profilesList => _profilesList;
}
