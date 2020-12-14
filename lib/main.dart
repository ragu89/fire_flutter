import 'package:fire_flutter/widgets/error.dart';
import 'package:fire_flutter/widgets/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fireBaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fireBaseInitialization,
      builder: (context, snapshot) {
        Widget widget = _createLoginScreen(snapshot);
        print("widget is : $widget");

        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
              appBar: AppBar(title: Text("Fire Flutter")), body: widget),
        );
      },
    );
  }

  Widget _createLoginScreen(AsyncSnapshot snapshot) {
    Widget widget = Loading();

    if (snapshot.hasError) {
      widget = Error(
          "Firebase initilization error",
          snapshot.error != null
              ? snapshot.error.toString()
              : "Error when trying to initilialize Firebase");
    } else if (snapshot.connectionState == ConnectionState.done) {
      widget = LoginScreen();
    }
    return widget;
  }
}
