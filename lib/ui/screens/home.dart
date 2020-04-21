import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authorizor/services/authentication.dart';
import 'package:authorizor/ui/lists/authorization.dart';
import 'package:device_info/device_info.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationService auth;

  Future<void> _signOut(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  void _scan() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    AndroidDeviceInfo info = await deviceInfo.androidInfo;

    String url;

    if (info.isPhysicalDevice) {
      String scanResult = await BarcodeScanner.scan();

      RegExp exp = new RegExp(
          r"https:\/\/young-bayou-14201\.herokuapp\.com\/client\/user");
      bool valid = exp.hasMatch(scanResult);

      if (valid) {
        url = scanResult;
      }
    } else {
      url = 'young-bayou-14201.herokuapp.com';
    }

    http.Response response = await http
        .get(Uri.https(url, '/client/user', {"uid": auth.currentUser.uid}));

    print(response.body);
  }

  Widget _logoutButton() {
    return FlatButton(
      child: Text(
        'Logout',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        _signOut(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Authorizor'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _scan();
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

class MenuItem {
  const MenuItem({this.title});

  final String title;
}

const List<MenuItem> menuItens = const <MenuItem>[
  const MenuItem(title: 'Logout'),
];