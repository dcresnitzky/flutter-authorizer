import 'dart:convert';

import 'package:http/http.dart' as http;

class CustomTokenService {
  Future<CustomToken> login(String login, String password) async {
    Map body = {'login': login, 'password': password};

    final response = await http.get(
        'https://us-central1-two-factor-authorizer.cloudfunctions.net/loginPOST?login=admin&password=&admin',
        headers: {"Content-Type": "application/json"});

    switch (response.statusCode) {
      case 200:
        return CustomToken.fromJson(json.decode(response.body));
      case 401:
        throw Exception('Invalid Credentials');
      case 403:
        throw Exception('Unauthorized Device');
    }
    throw Exception('Failed to load backend');
  }
}

class CustomToken {
  final String uid, email, token;

  CustomToken({this.uid, this.email, this.token});

  factory CustomToken.fromJson(Map<String, dynamic> json) {
    return CustomToken(
        uid: json['uid'], email: json['email'], token: json['token']);
  }

  @override
  String toString() {
    return this.token;
  }
}
