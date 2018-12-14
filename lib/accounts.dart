import 'dart:convert';

import 'package:flutter/material.dart';
import 'models.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'styles.dart';

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
            ),
            body: SafeArea(
              child: Container(
                child: new FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString('data_repo/accounts.json'),
                    builder: (context, snapshot) {
                      // Decode the JSON
                      var accounts = json.decode(snapshot.data.toString());

                      //User.of(context).name;
                      /*
                            ScopedModelDescendant<User>(
                              builder: (context, child, model) {
                                return Text(model.name);
                              },
                            ),
                            */

                      return new RefreshIndicator(
                          onRefresh: () {
                            return Future.delayed(new Duration(seconds: 1));
                          },
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return new ListTile(
                                  leading: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(0xff336dcc),
                                      borderRadius: BorderRadius.circular(25.0),
                                      border: Styles.leadingBorder,
                                    ),
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: Center(
                                        child: Text('Ab',
                                            style: Styles.leadingText),
                                      ),
                                    ),
                                  ),
                                  title: Text(accounts[index]['name']),
                                  subtitle: Text(accounts[index]['id']),
                                  onTap: () async {
                                    final fakeUrl = "http://www.flutter.io";
                                    if (await canLaunch(fakeUrl)) {
                                      launch(fakeUrl);
                                    }
                                  });
                            },
                            itemCount: accounts == null ? 0 : accounts.length,
                          ));
                    }),
              ),
            )));
  }
}
