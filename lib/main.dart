import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twofactorauthorizer/models/auth.dart';
import 'package:twofactorauthorizer/models/catalog.dart';
import 'package:twofactorauthorizer/ui/screens/home.dart';
import 'package:twofactorauthorizer/ui/screens/login.dart';
import 'package:twofactorauthorizer/ui/theme.dart';

void main() => runApp(
      new AuthorizerApp(),
    );

class AuthorizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/lock.png'), context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        Provider(create: (context) => CatalogModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        title: '2Factor Authorizer',
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
