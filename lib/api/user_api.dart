import 'dart:convert';

import 'package:http/http.dart' as http;

class UserApi {
  static Future<List<User>> getUsers(String query) async {
    // final url = Uri.parse('http://192.168.5.60:9000/users');
    final url = Uri.parse('https://construck-backend.herokuapp.com/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);

      return users.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future login(String password, String email) async {
    // final url = Uri.parse('http://192.168.5.60:9000/users');
    final url =
        Uri.parse('https://construck-backend.herokuapp.com/users/login');
    final response =
        await http.post(url, body: {"password": password, "email": email});

    if (response.statusCode == 200) {
      final obj = json.decode(response.body);

      return {"allowed": true, "user": obj['user']};
    } else {
      return {"allowed": false};
    }
  }
}

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String userType;

  const User({
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.email,
    required this.phone,
    required this.userType,
  });

  static User fromJson(Map<String, dynamic> json) => User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      userId: json['_id'],
      phone: json['phone'],
      userType: json['userType'],
      email: json['email']);
}
