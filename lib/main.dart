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
    return Container(
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
          TextField(
            controller: _userNameController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Username',
            ),
            onChanged: (str) => print('Multi-line text change: $str'),
            onSubmitted: (str) =>
                print('This will not get called when return is pressed'),
          ),
          TextField(
            controller: _passwordController,
            maxLines: 1,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
            onChanged: (str) => print('Multi-line text change: $str'),
            onSubmitted: (str) =>
                print('This will not get called when return is pressed'),
          ),
          SizedBox(height: 10.0),
          FlatButton(
              onPressed: _toggle,
              child:
                  new Text(_obscureText ? "Show Password" : "Hide Password")),
          RaisedButton(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogonProgress(username:_userNameController.text, password:_passwordController.text)),
              );
            },
            child: const Text('Sign In'),
          )
        ],
      ),
    );
  }
}

class LogonProgress extends StatefulWidget {

  final String username;
  final String password;

  LogonProgress({Key key, this.username, this.password}) : super(key: key);

  @override
  LogonProgressState createState() => new LogonProgressState();

}

class LogonProgressState extends State<LogonProgress> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logging in..."),
      ),
      body: Center(
          child: FutureBuilder<AuthenticationResponse>(
              future: getUser(widget.username, widget.password),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Welcome ' + snapshot.data.username);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return CircularProgressIndicator();
              })),
    );
  }
}


/// Displays text in a snackbar
_showInSnackBar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
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
