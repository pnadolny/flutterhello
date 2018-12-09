
class AuthenticationResponse {
  final String username;

  AuthenticationResponse({this.username});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      username: json['username']
    );
  }
}
