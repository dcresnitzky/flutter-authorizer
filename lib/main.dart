import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twofactorauthorizer/models/auth.dart';
import 'package:twofactorauthorizer/ui/screens/home.dart';
import 'package:twofactorauthorizer/ui/screens/login.dart';
import 'package:twofactorauthorizer/ui/screens/signup.dart';
import 'package:twofactorauthorizer/ui/theme.dart';

void main() => runApp(
      new AuthorizerApp(),
    );

class AuthorizerApp extends StatefulWidget {

  @override
  AuthorizeState createState() {
    return AuthorizeState();
  }
}

class AuthorizeState extends State<AuthorizerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: '2Factor Authorizer',
      routes: {
        '/': (context) => LoginScreen(),
        '/': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
