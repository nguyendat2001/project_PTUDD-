import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../models/auth_token.dart';
import '../../services/auth_service.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../ui/products/products_overview_screen.dart';


class AuthManager with ChangeNotifier {
  Future<void> signUp(String email, String password) async {
  final response = await http.post(
    Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDgjgYFNhHdqSWIVunqLd4gPw_F8KVyTcs'),
    body: jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );
  if (response.statusCode == 200) {
    // Người dùng mới đã được tạo thành công.
    final responseData = jsonDecode(response.body);
    final String token = responseData['idToken'];
    final String userId = responseData['localId'];
    print('Sign up success');
  }
}

Future<void> signUp2(String name, String email, String password, String role) async {
  final response = await http.post(
    Uri.parse('https://myshop-77a16-default-rtdb.firebaseio.com/users.json'),
    body: json.encode({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'returnSecureToken': true,
    }),
  );
  if (response.statusCode == 200) {
    // Người dùng mới đã được tạo thành công.
    final responseData = jsonDecode(response.body);
    final String token = responseData['idToken'];
    final String userId = responseData['localId'];
    print('Sign up success');
    
  }
}

  Future<bool> check_admin(String email, String role) async {
    final response = await http.get(
    Uri.parse('https://myshop-77a16-default-rtdb.firebaseio.com/users.json'),
  );
    if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    bool isUserExists = false;
    // Kiểm tra thông tin đăng nhập của người dùng với dữ liệu đã có trên database
    responseData.forEach((key, value) {
      if (value['email'] == email && value['role'] == 'admin') {
        isUserExists = true;
      }
    });
    if (isUserExists) {
      print('Đăng nhập thành công với userId');
      return true;
      // Chuyển hướng đến trang chủ
    } else {
      print('Email hoặc mật khẩu không đúng');
      return false;
    }
  } else {
    throw Exception('Lỗi xảy ra khi đăng nhập');
  }
  }

  AuthToken? _authToken;
  Timer? _authTimer;

  final AuthService _authService = AuthService();

  bool get isAuth {
    return authToken != null && authToken!.isValid;
  }

    bool get isAdmin {
    return authToken != null && authToken!.isValid && authToken!.userId == 'I2zGibvvAyUkPXegsJ6TJoXfwSI2';
  }

  AuthToken? get authToken {
    return _authToken;
  }

  void _setAuthToken(AuthToken token) {
    _authToken = token;
    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    _setAuthToken(await _authService.signup(email, password));
  }



  Future<void> login(String email, String password) async {
    _setAuthToken(await _authService.login(email, password));
  }

  Future<bool> tryAutoLogin() async {
    final savedToken = await _authService.loadSavedAuthToken();
    if (savedToken == null) {
      return false;
    }

    _setAuthToken(savedToken);
    return true;
  }

  Future<void> logout() async {
    _authToken = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    _authService.clearSavedAuthToken();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry =
        _authToken!.expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
