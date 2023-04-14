import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../services/user_service.dart';
import 'package:provider/provider.dart';
import '../../models/auth_token.dart';
import '../../services/auth_service.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../ui/products/products_overview_screen.dart';
import '../../models/user.dart';


class UserManager extends ChangeNotifier {

  AuthToken? _authToken;
  Timer? _authTimer;

  final AuthService _authService = AuthService();
  final UsersService _usersService = UsersService();

  bool get isAuth {
    return authToken != null && authToken!.isValid;
  }

  AuthToken? get authToken {
    return _authToken;
  }

    List<User> _items = [];
    
    Future<void> fetchUsers([bool filterByUser = false]) async {
    _items = await _usersService.fetchUsers(filterByUser);
    // print(_items);
    notifyListeners();
  }

    int get itemCount {
    return _items.length;
  }

  List<User> get items {
    return [..._items];
  }

  void _setAuthToken(AuthToken token) {
    _authToken = token;
    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password, String role) async {
    _setAuthToken(await _authService.signup(name, email, password, role));
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
