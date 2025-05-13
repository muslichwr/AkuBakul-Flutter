import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:akubakul/models/user_model.dart';

class AuthService {
  String baseUrl = 'http://192.168.1.15:8000/api';

  Future<UserModel> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$baseUrl/register');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });

    var response = await http.post(url, headers: headers, body: body);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];

      return user;
    } else {
      throw Exception('Gagal Register');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$baseUrl/login');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'email': email, 'password': password});

    var response = await http.post(url, headers: headers, body: body);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];

      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }

  Future<UserModel> updateProfile({
    required int userId,
    required String name,
    required String username,
    required String email,
    String? phone,
    required String token,
  }) async {
    var url = Uri.parse('$baseUrl/user/$userId');
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'phone_number': phone,
    });
    var response = await http.put(url, headers: headers, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = token;
      return user;
    } else {
      throw Exception('Gagal update profile');
    }
  }

  Future<bool> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    var url = Uri.parse('$baseUrl/user/$userId/change-password');
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({
      'old_password': oldPassword,
      'new_password': newPassword,
    });
    var response = await http.post(url, headers: headers, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
