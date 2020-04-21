import 'package:authorizor/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      // ignore: missing_return
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService =
        Provider.of<AuthenticationService>(context);

    return StreamBuilder<FirebaseUser>(
      stream: authenticationService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
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
