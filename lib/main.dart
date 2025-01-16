import 'package:flutter/material.dart';
import 'package:oms/pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zims',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        //accentColor: Colors.blueAccent,
        secondaryHeaderColor: Colors.red,
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // ignore: missing_required_param
      home: LoginPage(key: UniqueKey(), title: 'My Login Page'),
    );
  }
}
