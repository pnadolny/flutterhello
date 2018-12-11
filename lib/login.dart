import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'models.dart';
import 'package:http/http.dart' as http;
import 'accounts.dart';

class LogonWidget extends StatefulWidget {
  @override
  createState() => _LogonWidgetState();
}

class _LogonWidgetState extends State<LogonWidget> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Initially password is obscure
  bool _obscureText = true;

// Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      child: new Text('CANCEL')),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Signing in...')));
                        getUser(_userNameController.text,
                            _passwordController.text)
                            .then((data) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountWidget()),
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

  Future<AuthenticationResponse> getUser(String username, String password) async {
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
