import 'package:authorizor/repositories/authorization.dart';
import 'package:authorizor/services/authorization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authorizor/services/authentication.dart';
import 'package:authorizor/ui/screens/landing-page.dart';
import 'package:authorizor/ui/theme.dart';

void main() => runApp(AuthorizorApp());

class AuthorizorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Authorizor',
        theme: appTheme,
        home: LandingPageScreen(),
      ),
      providers: [
        Provider<AuthenticationService>(create: (_) => AuthenticationService()),
        Provider<AuthorizationService>(
            create: (_) => AuthorizationService(AuthorizationRepository())),
      ],
    );
  }
}
