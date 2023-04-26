import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hippocampus/email_register.dart';
import 'package:hippocampus/login.dart';
import 'package:hippocampus/providers/user_provider.dart';
import 'package:hippocampus/register.dart';
import 'package:hippocampus/theme/app_theme.dart';
import 'package:hippocampus/theme/theme_service.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'models/user_data.dart';

void main() {
  AppTheme appTheme = ThemeService();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserData()),
    ChangeNotifierProvider(create: (context) => appTheme),
    ChangeNotifierProvider(create: (context) => UserProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  static Container onlineCircle = Container(
    height: 10,
    width: 10,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.greenAccent,
    ),
  );

  Widget _getScreenId() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Home();
        } else {
          return Register();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return Consumer<AppTheme>(
              builder:
                  (BuildContext context, AppTheme appTheme, Widget? widget) =>
                      MaterialApp(
                        initialRoute: '/',
                        routes: {
                          '/register': (context) => Register(),
                          '/home': (context) => Home(),
                          '/email': (context) => EmailSignUp(
                                desktopLayout: false,
                              ),
                          '/login': (context) => Login(
                                desktopLayout: false,
                              )
                        },
                        debugShowCheckedModeBanner: false,
                        theme: appTheme.getLightTheme(),
                        darkTheme: appTheme.getDarkTheme(),
                        home: _getScreenId(),
                      ));
        });
  }
}
