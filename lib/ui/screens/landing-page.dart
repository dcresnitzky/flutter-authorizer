import 'package:authorizor/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:authorizor/ui/screens/home.dart';
import 'package:authorizor/ui/screens/login.dart';
import 'package:provider/provider.dart';

class LandingPageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPageScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        Provider.of<AuthenticationService>(context);

    return StreamBuilder<FirebaseUser>(
      stream: _authenticationService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return LoginScreen();
          }
          return HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
