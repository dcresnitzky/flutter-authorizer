import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Messaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
      },
      onResume:  (Map<String, dynamic> message) async {
        print(message);
      },
      onLaunch:  (Map<String, dynamic> message) async {
      print(message);
    },
//      onBackgroundMessage: _onBackgroundMessage,
    );
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) {
    print(message);

    return Future<bool>(() {
      return true;
    });
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) {
    print(message);

    return Future<bool>(() {
      return true;
    });
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message) {
    print(message);

    return Future<bool>(() {
      return true;
    });
  }

  _onBackgroundMessage(Map<String, dynamic> message) {
    print(message);

    return Future<bool>(() {
      return true;
    });
  }
}
