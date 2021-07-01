import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/htpp_expection.dart';

class Auth with ChangeNotifier {
  String _token = "";
  String _userId = "";
  DateTime _expirayDate = DateTime.now();

  Timer _authTimer = Timer(Duration(seconds: 0), () {});

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_token != "" &&
        _expirayDate != DateTime.now() &&
        (_expirayDate.isAfter(DateTime.now()))) {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String userEmail, String pass, String url) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "email": userEmail,
          "password": pass,
          "returnSecureToken": true,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData['error']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expirayDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expirayDate': _expirayDate,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String userEmail, String pass) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDIa9wlwiMFerAfIRX9R9Nc6UaWFLEjqK4";
    return _authenticate(userEmail, pass, url);
  }

  Future<void> login(String userEmail, String pass) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDIa9wlwiMFerAfIRX9R9Nc6UaWFLEjqK4";

    return _authenticate(userEmail, pass, url);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        prefs.getString('userData') as Map<String, dynamic>;
    final expirayDate = DateTime.parse(extractedUserData['expirayDate']);

    if (!expirayDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expirayDate = expirayDate;

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expirayDate = DateTime.now();
    if (_authTimer != Timer(Duration(seconds: 0), () {})) {
      _authTimer.cancel();
      _authTimer = Timer(Duration(seconds: 0), () {});
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');  it willl clear only the userData if there are more data stored in that
    prefs.clear(); // it will remove all the data in that
  }

  void _autoLogout() {
    if (_authTimer != Timer(Duration(seconds: 0), () {})) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expirayDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
