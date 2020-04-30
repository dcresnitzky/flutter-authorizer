import 'package:authorizor/services/register.dart';
import 'package:authorizor/ui/messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authorizor/services/authentication.dart';
import 'package:authorizor/ui/lists/authorization.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with RegisterService {
  final Messaging messaging = Messaging();
  AuthenticationService auth;

  final GlobalKey key = GlobalKey();

  Future<void> _signOut(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldState state = key.currentState;

    state.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationService>(context, listen: false);

    return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text('Authorizor'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                register(auth.currentUser.uid).then((result) => _showSnackBar(
                    result ? 'Registered to TEST_CLIENT' : 'Invalid target'));
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _signOut(context);
              },
            ),
          ],
        ),
        body: Center(child: AuthorizationList()));
  }
}
