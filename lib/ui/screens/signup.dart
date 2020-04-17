import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twofactorauthorizer/auth/auth-service.dart';
import 'package:twofactorauthorizer/models/auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:developer' as developer;

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  Auth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(80.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.display4,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Email can\'t be empty' : null,
                  onSaved: (value) => this._email = value.trim(),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) => this._password = value.trim(),
                ),
                SizedBox(
                  height: 24,
                ),
                RaisedButton(
                  color: Colors.yellow,
                  child: Text('ENTER'),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) return;
                    _formKey.currentState.save();
                    await _onLoading(context, () async {
//                      await .auth.login(_email, _password);
                    });
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                SizedBox(width: 24),
              ],
            ),
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

  Future<void> _onLoading(BuildContext context, AsyncCallback callback) async {
    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    try {
      await callback();
    } catch (exception) {
      await progressDialog.hide();
      developer.log(exception.toString());
      showError(context, exception.toString());
    }
    await progressDialog.hide();
  }
}
