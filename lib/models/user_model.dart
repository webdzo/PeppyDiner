class UsersModel {
  UsersModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.password,
    required this.blocked,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.roleName,
  });
  late final int id;
  late final String firstname;
  late final String lastname;
  late final String username;
  late final String email;
  late final String password;
  late final bool blocked;
  late final bool deleted;
  late final String createdAt;
  late final String updatedAt;
  late final String roleName;

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'] ?? "";
    username = json['username'];
    email = json['email'];
    password = json['password'];
    blocked = json['blocked'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['firstname'] = firstname;
    datas['lastname'] = lastname;
    datas['username'] = username;
    datas['email'] = email;
    datas['password'] = password;
    datas['blocked'] = blocked;
    datas['deleted'] = deleted;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['role_name'] = roleName;
    return datas;
  }
}
