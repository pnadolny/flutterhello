import 'dart:convert';

import 'package:flutter/material.dart';

class AccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                        return GestureDetector(onTap: ()=>
                          print('Hello' + accounts[index]['id'])
                        ,child: Card(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  // Read the name field value and set it in the Text widget
                                  accounts[index]['name'],
                                  // set some style to text
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.lightBlueAccent),
                                ),
                                // added padding
                                padding: const EdgeInsets.all(15.0),
                              )
                            ],
                          ),
                        )
                        );
                      },
                      itemCount: accounts == null ? 0 : accounts.length,
                    );
                  }),
            ),
          ),
        ));
  }
}