class LoginResponse {
  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.accessToken,
  });
  late final int id;
  late final String username;
  late final String email;
  late final String roles;
  late final String accessToken;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    roles = json['roles'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['roles'] = roles;
    data['accessToken'] = accessToken;
    return data;
  }
}
