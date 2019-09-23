import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:meetup/src/models/forms.dart';
import 'package:meetup/src/models/user.dart';
import 'package:meetup/src/utils/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  final String url = Platform.isIOS
      ? 'http://localhost:3001/api/v1'
      : 'http://10.0.2.2:3001/api/v1';
  String _token;
  User _authUser;
  static final AuthApiService _singleton = AuthApiService._internal();
  factory AuthApiService() {
    return _singleton;
  }
  AuthApiService._internal();
  set authUser(Map<dynamic, dynamic> value) {
    _authUser = User.fromJSON(value);
  }

  get authUser => _authUser;
  Future<String> get token async {
    if (_token.isNotEmpty) {
      return _token;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }
  }

  Future<bool> _saveToken(String token) async {
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      _token = token;
      return true;
    }
    return false;
  }

  Future<bool> isAuthenticated() async {
    final token = await this.token;
    if (token.isNotEmpty) {
      final decodedToken = decode(token);
      var isValidToken = false;
      if (decodedToken['exp'] * 1000 > DateTime.now().millisecond) {
        isValidToken = true;
        authUser = decodedToken;
      } else {
        isValidToken = false;
      }
      authUser = decodedToken;
      return isValidToken;
    }
    return false;
  }

  Future<Map<dynamic, dynamic>> login(LoginFormData loginData) async {
    final body = json.encode(loginData.toJson());

    final response = await http.post('$url/users/login',
        headers: {"Content-Type": "application/json"}, body: body);
    final parsedData = Map.from(json.decode(response.body));
    if (response.statusCode == 200) {
      await _saveToken(parsedData['token']);
      authUser = parsedData;
      return parsedData;
    } else {
      return Future.error(parsedData);
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove('token');
      _token = '';
      _authUser = null;
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> register(RegisterFormData registerData) async {
    final body = json.encode(registerData.toJSON());

    final response = await http.post('$url/users/register',
        headers: {"Content-Type": "application/json"}, body: body);
    final parsedData = Map.from(json.decode(response.body));
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error(parsedData);
    }
  }
}
