
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';


class AuthenticationResponse {
  final String username;
  AuthenticationResponse({this.username});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      username: json['username']
    );
  }
}

class Account {
  final int id;
  final String name;
  Account({this.id, this.name});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        id: json['id'],
        name: json['name']
    );
  }
}

class User extends Model {

  String _name = 'Paul';

  String get name => _name;

  void changeName(String name) {
    this._name = name;
    notifyListeners();
  }
  static User of(BuildContext context) =>
      ScopedModel.of<User>(context);

}

enum Season {
  winter,
  spring,
  summer,
  autumn,
}
