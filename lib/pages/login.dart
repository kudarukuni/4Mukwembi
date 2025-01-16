import 'package:flutter/material.dart';
import 'package:oms/ui/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required Key key, this.title = 'Default Title'})
      : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 20.0),
            child: Image.asset(
              'android/assets/landingImg.png',
              width: 200,
              height: 200,
            ),
          ),
          const Text("KUDA's - MOBILE",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          LoginForm(),
        ],
      ),
    ));
  }
}
