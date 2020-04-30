import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference authorizationCollection =
    Firestore.instance.collection('authorization');

class AuthorizationRepository {
  Stream<QuerySnapshot> list(uid, {int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = authorizationCollection
        .document(uid)
        .collection('pending')
        .orderBy('createdAt', descending: true)
        .snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Future<dynamic> delete(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(authorizationCollection.document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');

      return false;
    });
  }

//  Future<dynamic> updateNote(Authorization authorization) async {
//    final TransactionHandler updateTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds = await tx.get(noteCollection.document(authorization.id));
//
//      await tx.update(ds.reference, authorization.toMap());
//      return {'updated': true};
//    };
//
//    return Firestore.instance
//        .runTransaction(updateTransaction)
//        .then((result) => result['updated'])
//        .catchError((error) {
//      print('error: $error');
//      return false;
//    });
//  }

//  Future<Authorization> createAuthorization(String title, String description) async {
//    final TransactionHandler createTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds = await tx.get(noteCollection.document());
//
//      final Authorization note = new Authorization(ds.documentID, title, description);
//      final Map<String, dynamic> data = note.toMap();
//
//      await tx.set(ds.reference, data);
//
//      return data;
//    };
//
//    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
//      return Authorization.fromMap(mapData);
//    }).catchError((error) {
//      print('error: $error');
//      return null;
//    });
//  }

}
