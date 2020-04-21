import 'package:flutter/material.dart';
import 'package:authorizor/ui/forms/create-account.dart';
import 'package:authorizor/ui/forms/login.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _signUpForm;

  @override
  void initState() {
    _signUpForm = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(children: <Widget>[
        _signUpForm
            ? CreateAccountForm(toggleSignUpForm: toggleSignUpForm)
            : LoginForm(toggleSignUpForm: toggleSignUpForm)
      ]),
    );
  }

  Widget showSignUpButton() {
    return new FlatButton(
      child: new Text('Create an account',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: () {},
    );
  }

  void toggleSignUpForm() {
    setState(() {
      _signUpForm = !_signUpForm;
    });
  }
}
