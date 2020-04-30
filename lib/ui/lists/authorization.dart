import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authorizor/models/authorization.dart';
import 'package:authorizor/services/authorization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:authorizor/services/authentication.dart';
import 'package:authorizor/ui/components/count-down-timer.dart';

// ignore: must_be_immutable
class AuthorizationList extends ListView {
  AuthenticationService _authenticationService;
  AuthorizationService _authorizationService;

  @override
  Widget build(BuildContext context) {
    _authenticationService = Provider.of<AuthenticationService>(context);
    _authorizationService = Provider.of<AuthorizationService>(context);

    return StreamBuilder<QuerySnapshot>(
      stream:
          _authorizationService.list(_authenticationService.currentUser.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return AuthorizationListItem(
                    authorization: Authorization.fromMap(
                        snapshot.data.documents[index].data),
                    onAuthorize: _authorizeItem,
                    onDelete: _deleteItem,
                    index: index);
              },
            );
        }
      },
    );
  }

  _deleteItem(BuildContext context, Authorization authorization, index) async {
    return await _authorizationService.delete(
        authorization, _authenticationService.currentUser.uid);
  }

  _authorizeItem(
      BuildContext context, Authorization authorization, index) async {
    return await _authorizationService.authorize(
        authorization, _authenticationService.currentUser.uid);
  }
}

class AuthorizationListItem extends StatelessWidget {
  AuthorizationListItem(
      {this.authorization, this.onAuthorize, this.onDelete, this.index});

  final Authorization authorization;
  final onAuthorize;
  final onDelete;
  final index;

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        color: Colors.white,
        child: ListTile(
          leading:
              CountDownTimer(authorization.createdAt, authorization.expiresAt),
          title: Text(authorization.title),
          subtitle: Text(authorization.description),
        ),
      ),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
//        dismissThresholds: <SlideActionType, double>{
//          SlideActionType.primary: 1.0,
//          SlideActionType.secondary: 1.0
//        },
        onWillDismiss: (actionType) async {
          try {
            bool dismissResult = actionType == SlideActionType.primary
                ? await onAuthorize(context, authorization, index)
                : await onDelete(context, authorization, index);
            _showSnackBar(
                context,
                dismissResult
                    ? 'Could not process'
                    : 'Authorization dismissed');
            return dismissResult;
          } catch (error) {
            print(error);
            _showSnackBar(context, error.toString());
            return false;
          }
        },
      ),
      actions: authorization.isExpired()
          ? null
          : <Widget>[
              IconSlideAction(
                caption: 'Authorize',
                color: Colors.green,
                icon: Icons.check,
              ),
            ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => onDelete(context, authorization, index),
        ),
      ],
    );
  }
}
