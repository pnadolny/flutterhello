
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


enum Season {
  winter,
  spring,
  summer,
  autumn,
}
