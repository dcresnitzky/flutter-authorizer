import 'package:authorizor/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:authorizor/repositories/authorization.dart';

class AuthorizationList extends ListView {
  @override
  Widget build(BuildContext context) {
    final _authorizationRepository =
        Provider.of<AuthorizationRepository>(context);
    final _authenticationService = Provider.of<AuthenticationService>(context);

    return StreamBuilder<QuerySnapshot>(
      stream:
          _authorizationRepository.list(_authenticationService.currentUser.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return _showSlidable(context, snapshot.data.documents[index]);
              },
            );
        }
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    // Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _showSlidable(BuildContext context, DocumentSnapshot document) {
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(document['title']),
          subtitle: Text(document['description']),
        ),
      ),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 0.0,
          SlideActionType.secondary: 1.0
        },
        onWillDismiss: (actionType) async {
          return actionType == SlideActionType.primary
              ? await _authorize(context)
              : false;
        },
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Authorize',
          color: Colors.green,
          icon: Icons.check_circle_outline,
          onTap: () => _showSnackBar(context, 'Authorize'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            if (_delete(context))
              _showSnackBar(context, 'Delete');
            else
              _showSnackBar(context, 'BAD Delete');
          },
        ),
      ],
    );
  }

  bool _delete(BuildContext context) {
    return false;
  }

  _authorize(BuildContext context) {
    return false;
  }
}
