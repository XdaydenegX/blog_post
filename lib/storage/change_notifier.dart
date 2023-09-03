import 'package:flutter/material.dart';
import 'local_save_token.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    notifyListeners();
  }

  Future getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<void> saveUsername(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    notifyListeners();
  }

  Future getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<void> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('accessToken');
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    _token = token;
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    notifyListeners();
  }

}

class SaveNotify extends ChangeNotifier {
  // bool newPostNotify = false;
  // bool likeNotify = false;
  // bool commentsNotify = false;
  //
  // SaveNotify(this.newPostNotify, this.likeNotify, this.commentsNotify);
  
  Future<void> saveNotify(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSwitched', value);
    notifyListeners();
  }
}