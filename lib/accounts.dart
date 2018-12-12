import 'dart:convert';

import 'package:flutter/material.dart';
import 'models.dart';
import 'styles.dart';
import 'package:scoped_model/scoped_model.dart';

class AccountWidget extends StatelessWidget {
  final User user;

  AccountWidget({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<User>(
        model: user,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Accounts"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  //       onPressed: _airDress,
                )
              ],
            ),
            body: SafeArea(
              child: Container(
                child: Card(
                  child: new FutureBuilder(
                      future: DefaultAssetBundle.of(context)
                          .loadString('data_repo/accounts.json'),
                      builder: (context, snapshot) {
                        // Decode the JSON
                        var accounts = json.decode(snapshot.data.toString());

                        return new ListView.builder(
                          // Build the ListView
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () =>
                                    print('Hello' + accounts[index]['id']),
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      ScopedModelDescendant<User>(
                                        builder: (context, child, model) {
                                          return Text(model.name);
                                        },
                                      ),
                                      Container(
                                        child: Text(
                                            // Read the name field value and set it in the Text widget
                                            accounts[index]['name'],
                                            // set some style to text
                                            style: Styles.baseTextStyle),
                                        // added padding
                                        padding: const EdgeInsets.all(15.0),
                                      )
                                    ],
                                  ),
                                ));
                          },
                          itemCount: accounts == null ? 0 : accounts.length,
                        );
                      }),
                ),
              ),
            )));
  }
}
