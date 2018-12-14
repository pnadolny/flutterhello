import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      _passwordController.text = prefs.getString('password');
    });
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("username", _userNameController.text);
      prefs.setString("password", _passwordController.text);
    });
  }

  final _formKey = GlobalKey<FormState>();

  // Initially password is obscure
  bool _obscureText = true;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                obscureText: _obscureText,
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
                        getUser(_userNameController.text,
                                _passwordController.text)
                            .then((data) {
                          _saveCredentials();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AccountWidget(user: User())),
                          );
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

  Future<AuthenticationResponse> getUser(
      String username, String password) async {
    print(username);
    print(password);

    final response =
        await http.get('https://jsonplaceholder.typicode.com/users/1');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return AuthenticationResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load user');
    }
  }
}
