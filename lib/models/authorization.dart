class Authorization {
  String _id;
  String _title;
  String _description;
  String _callback;
  DateTime _createdAt;
  DateTime _expiresAt;

  Authorization(this._id, this._title, this._description, this._createdAt,
      this._expiresAt, this._callback);

  Authorization.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
    this._callback = obj['callback'];
    this._createdAt = obj['createdAt'];
    this._expiresAt = obj['expiresAt'];
  }

  String get id => _id;
  String get title => _title;
  String get description => _description;
  String get callback => _callback;
  DateTime get createdAt => _createdAt;
  DateTime get expiresAt => _expiresAt;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['callback'] = _callback;
    map['createdAt'] = _createdAt;
    map['expiresAt'] = _expiresAt;

    return map;
  }

  Authorization.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._callback = map['callback'];
    this._createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']);
    this._expiresAt = DateTime.fromMillisecondsSinceEpoch(map['expiresAt']);
  }

  bool isExpired() {
    return DateTime.now().isAfter(_expiresAt);
  }
}
