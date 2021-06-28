import 'dart:convert';
import '../models/htpp_expection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token = "";
  String _userId = "";
  DateTime _expirayDate = DateTime.now();

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
      notifyListeners();
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
}
