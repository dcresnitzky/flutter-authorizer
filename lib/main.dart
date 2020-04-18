import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twofactorauthorizer/services/authentication.dart';
import 'package:twofactorauthorizer/ui/screens/landing-page.dart';
import 'package:twofactorauthorizer/ui/theme.dart';

void main() => runApp(AuthorizerApp());

class AuthorizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthenticationService>(
      create: (_) => new AuthenticationService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '2Factor Authorizer',
        theme: appTheme,
        home: LandingPage(),
      ),
    );
  }
}