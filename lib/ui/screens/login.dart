import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twofactorauthorizer/models/auth.dart';
import 'package:twofactorauthorizer/ui/widget/progress.dart';
import 'dart:developer' as developer;

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context);

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.display4,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 24,
              ),
              RaisedButton(
                color: Colors.yellow,
                child: Text('ENTER'),
                onPressed: () {
//                  authModel.toggleLoading();
                  _onLoading(context, () {
                    authModel.auth
                        .login('dcresnitzky@gmail.com', 'daniel')
                        .then((user) {
                      Navigator.pushNamed(context, '/home');
                    }).catchError((exception) {
                      showError(context, exception.toString());
                    });
                  });
//                  authModel.toggleLoading();
                },
              ),
              Consumer<AuthModel>(
                  builder: (context, authModel, child) =>
                      showCircularProgress(authModel.isLoading)),
              SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }

  showError(BuildContext context, error) {
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }

  Future<void> _onLoading(BuildContext context, VoidCallback callback) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      try {
        callback();
      } catch (uiError) {
        developer.log(uiError);
      }
      Navigator.pop(context); //pop dialog
    });
  }
}
