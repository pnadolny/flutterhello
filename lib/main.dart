import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'models.dart';
import 'package:http/http.dart' as http;

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: const Text('Sign In'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LogonWidget(),
            ),
          ],
        ),
      ),
    );
  }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                  'https://flutter.io/images/flutter-mark-square-100.png'),
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
                obscureText: _obscureText,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 10.0),
              FlatButton(
                  onPressed: _toggle,
                  child: new Text(
                      _obscureText ? "Show Password" : "Hide Password")),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('Signing in..')));
                    getUser(_userNameController.text, _passwordController.text)
                        .then((data) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondScreen()),
                      );
                    });
                  }
                },
                child: const Text('Sign In'),
              )
            ],
          ),
        ));
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
