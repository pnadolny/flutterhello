import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transplace',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
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


/// Multi-line text field widget with a submit button
class LogonWidget extends StatefulWidget {
  LogonWidget({Key key}) : super(key: key);

  @override
  createState() => _LogonWidgetState();
}

class _LogonWidgetState
    extends State<LogonWidget> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      //color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
            decoration: InputDecoration(
              hintText: 'Password',
            ),
            onChanged: (str) => print('Multi-line text change: $str'),
            onSubmitted: (str) =>
                print('This will not get called when return is pressed'),
          ),
          SizedBox(height: 10.0),
          FlatButton(
            onPressed: () => _showInSnackBar(
              context,
              '${_userNameController.text}' + '${_passwordController.text}' ,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

/// Displays text in a snackbar
_showInSnackBar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

class LogonPage extends StatefulWidget {
  LogonPage({Key key}) : super(key: key);

  @override
  _LogonPageState createState() => _LogonPageState();
}

class _LogonPageState extends State<LogonPage> {

  var _username;
  var _password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),

        floatingActionButton: FlatButton(
          onPressed: _signin,
          child: Text('Sign In'),
        ));
  }

  void _signin() {
    setState(() {});
  }
}

