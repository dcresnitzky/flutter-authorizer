import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twofactorauthorizer/services/authentication.dart';

class HomeScreen extends StatelessWidget {

  Future<void> _signOut(context) async {
    try {
      final auth  = Provider.of<AuthenticationService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () { _signOut(context); },
          ),
        ],
      ),
    );
  }
}
