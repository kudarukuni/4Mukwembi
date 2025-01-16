import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oms/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Future<http.Response> login({user, context}) async {
  print(user);
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/api/login'),
    body: user,
  );

  return response;
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;
  late String ecnumber;
  late String username;
  TextEditingController ecnumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: TextField(
                controller: ecnumberController,
                decoration: InputDecoration(
                  labelText: "Enter your Ecnumber",
                  icon: Icon(Icons.person),
                ),
                autofocus: false,
                onChanged: (text) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(Icons.lock),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RoundedLoadingButton(
                    elevation: 5,
                    onPressed: () {
                      _isLoading = true;

                      Map<dynamic, dynamic> user = {
                        'ecnumber': ecnumberController.text,
                        'password': passwordController.text,
                      };

                      login(user: user).then((value) async {
                        if (value.statusCode == 200) {
                          var responseData = json.decode(value.body);
                          var token = responseData['token'];
                          var ecnum = responseData['user']['ecnumber'];
                          var username = responseData['user']['name'];

                          SharedPreferences localStorage =
                              await SharedPreferences.getInstance();
                          localStorage.setString('token', token);
                          localStorage.setString('ecnumber', ecnum);
                          localStorage.setString('username', username);

                          _btnController.success();
                          Timer(Duration(seconds: 3), () {
                            _btnController.reset();
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                key: UniqueKey(),
                                ecnumber: ecnum,
                                username: username,
                              ),
                            ),
                          );
                        } else {
                          _btnController.error();
                        }
                      }).catchError((err) {
                        print(err);
                      });
                    },
                    child: Text('Login'),
                    color: Theme.of(context).primaryColor,
                    controller: _btnController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
