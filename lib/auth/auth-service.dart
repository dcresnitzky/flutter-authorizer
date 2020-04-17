import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twofactorauthorizer/auth/custom-token-service.dart';

class Auth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;

  Future<FirebaseUser> login(String email, String password) async {
    try {
      AuthResult signInResult = await this
          ._firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      this.user = signInResult.user;
    } catch (exception) {
        AuthResult createResult = await this
            ._firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        this.user = createResult.user;
    }
    return this.user;
  }

  bool check() {
    return this.user != null;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    this.user = null;
  }
}
