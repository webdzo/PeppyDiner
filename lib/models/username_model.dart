class UsernameModel {
  UsernameModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
  });
  late final int id;
  late final String firstname;
  late final String lastname;
  late final String username;

  UsernameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'] ?? "";
    lastname = json['lastname'] ?? "";
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['firstname'] = firstname;
    datas['lastname'] = lastname;
    datas['username'] = username;
    return datas;
  }
}
