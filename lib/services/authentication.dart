import 'dart:io';
import 'dart:async';
import 'package:authorizor/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authorizor/repositories/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class AuthenticationService {
  String errorMessage;
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamController<FirebaseUser> _streamController;
  User currentUser;

  AuthenticationService() {
    _streamController = new StreamController();

    _firebaseAuth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
        _userRepository.get(firebaseUser.uid).then((User user) async {
          //todo: move to fcm function
          if(Platform.isIOS) {
            await _firebaseMessaging.requestNotificationPermissions(
              const IosNotificationSettings(
                  sound: true, badge: true, alert: true, provisional: false),
            );
          }
          String fcmToken = await _firebaseMessaging.getToken();

          if (user == null) {
            await _userRepository.create(firebaseUser.uid, fcmToken);
          } else if (user != null && user.fcmToken != fcmToken) {
            await _userRepository.update(firebaseUser.uid, fcmToken);
          }
          currentUser = user;
          _streamController.add(firebaseUser);
        }).catchError((error) {
          print(error);
        });
      } else {
        currentUser = null;
        _streamController.add(null);
      }
    }, onError: (error) {
      print(error);
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      switch (error.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Anonymous accounts are not enabled";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Your password is too weak";
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email is invalid";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Email is already in use on different account";
          break;
        case "ERROR_INVALID_CREDENTIAL":
          errorMessage = "Your email is invalid";
          break;

        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Stream<FirebaseUser> get onAuthStateChanged => _streamController.stream;
}
