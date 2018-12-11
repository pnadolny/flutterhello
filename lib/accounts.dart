import 'package:flutter/material.dart';
import 'dart:convert';

class AccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Accounts"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_comment),
              tooltip: 'Air it',
              //       onPressed: _airDress,
            ),
            IconButton(
              icon: Icon(Icons.playlist_add),
              tooltip: 'Restitch it',
              //          onPressed: _restitchDress,
            ),
            IconButton(
              icon: Icon(Icons.playlist_add_check),
              tooltip: 'Repair it',
              //        onPressed: _repairDress,
            ),
          ],
        ),
        body: Container(
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
        ));
  }
}