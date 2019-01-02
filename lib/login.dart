import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'accounts.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogonWidget extends StatefulWidget {
  @override
  createState() => _LogonWidgetState();
}

class _LogonWidgetState extends State<LogonWidget> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _getSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userNameController.text = prefs.getString('username');
    });
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("username", _userNameController.text);
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _getSavedCredentials();

    return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: new Column(
            children: <Widget>[
              Text('Sign in with your organizational account'),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _userNameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid username';
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Username',
                ),
              ),
              // spacer
              SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid password';
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 10.0),

              ButtonBar(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        _userNameController.clear();
                        _passwordController.clear();
                      },
                      child: new Text('RESET')),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Signing in...')));
                        authenticate(_userNameController.text,
                                _passwordController.text)
                            .then((data) {
                          if (data.errorDescription != null &&
                              data.errorDescription.isNotEmpty) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text(data.errorDescription)));
                          } else {
                            _saveCredentials();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AccountWidget(user: User())),
                            );
                          }
                        }).catchError((e) {
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('$e')));
                        });
                      }
                    },
                    child: const Text('NEXT'),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Future<AuthenticationResponse> authenticate(
      String username, String password) async {
    print(username);
    print(password);

    String url = "https://someplace.com";

    /*
    if (username.contains(" ")) {
      List<String> env = username.split(" ");
      String testurl = url.replaceAll("uattms", env.first + 'tms');
      print(testurl);
    }
    */

    final response = await http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      print(response.body);
      // Create a client transformer
      final Xml2Json xmlToJson = Xml2Json();
      xmlToJson.parse(response.body);
      print(xmlToJson.toParker());
      return AuthenticationResponse.fromJson(json.decode(xmlToJson.toParker()));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load user');
    }
    
  }
}
