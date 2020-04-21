class User {
  String _uid;
  String _fcmToken;

  User(this._uid, this._fcmToken);

  String get uid => _uid;
  String get fcmToken => _fcmToken;

  User.map(dynamic obj) {
    this._uid = obj['uid'];
    this._fcmToken = obj['fcmToken'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['uid'] = _uid;
    map['fcmToken'] = _fcmToken;

    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._uid = map['uid'];
    this._fcmToken = map['fcmToken'];
  }
}
