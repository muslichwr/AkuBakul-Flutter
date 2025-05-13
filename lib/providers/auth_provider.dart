import 'package:akubakul/models/user_model.dart';
import 'package:akubakul/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  AuthService authService = AuthService();
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? newUser) {
    _user = newUser;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = await authService.register(
        name: name,
        username: username,
        email: email,
        password: password,
      );

      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      UserModel user = await authService.login(
        email: email,
        password: password,
      );

      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfile({
    required int userId,
    required String name,
    required String username,
    required String email,
    String? phone,
    required String token,
  }) async {
    try {
      UserModel user = await authService.updateProfile(
        userId: userId,
        name: name,
        username: username,
        email: email,
        phone: phone,
        token: token,
      );
      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    try {
      bool result = await authService.changePassword(
        userId: userId,
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: token,
      );
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
