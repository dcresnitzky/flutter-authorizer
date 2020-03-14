import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twofactorauthorizer/auth/token.dart';
import 'dart:developer' as developer;

class Auth {
  final CustomTokenService _tokenService = CustomTokenService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _user;

  Future<User> login(String login, String password) async {
    CustomToken token = await this._tokenService.login(login, password);
    FirebaseUser firebaseUser = await _signInFirebase(token.toString());
    firebaseUser.updateEmail(login);
    this._user = User(token.uid, token.email, firebaseUser);
    return this._user;
  }

  bool check() {
    return this._user != null;
  }

  User get user => _user;

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    this._user = null;
  }

  Future<FirebaseUser> _signInFirebase(String token) async {
    AuthResult authResult =
        await this._firebaseAuth.signInWithCustomToken(token: token);
    return authResult.user;
  }
}

class User {
  final String uid, email;
  final FirebaseUser firebaseUser;

  User(this.uid, this.email, this.firebaseUser);
}
