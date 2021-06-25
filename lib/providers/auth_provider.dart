import 'dart:convert';
import '../models/htpp_expection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late String _userId;
  late String _expirayDate;

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
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
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
