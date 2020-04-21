import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authorizor/models/user.dart';

final CollectionReference userCollection =
    Firestore.instance.collection('user');

class UserRepository {
  Future<User> get(String uid) async {
    DocumentReference reference = userCollection.document(uid);
    DocumentSnapshot snapshot = await reference.get();

    return snapshot.data == null ? null : User.fromMap(snapshot.data);
  }

  Future<User> create(String uid, [String fcmToken = '']) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(userCollection.document(uid));

      final User user = new User(uid, fcmToken);
      final Map<String, dynamic> data = user.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return User.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future<User> update(String uid, [String fcmToken = '']) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(userCollection.document(uid));

      final User user = new User(uid, fcmToken);
      final Map<String, dynamic> data = user.toMap();

      await tx.update(ds.reference, data);

      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
}
