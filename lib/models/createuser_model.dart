class CreateuserReq {
  CreateuserReq({
     this.name,
     this.useremail,
     this.password,
     this.type,
  });
   String? name;
   String? useremail;
   String? password;
   int? type;
  
  CreateuserReq.fromJson(Map<String, dynamic> json){
    name = json['name'];
    useremail = json['useremail'];
    password = json['password'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['name'] = name;
    datas['useremail'] = useremail;
    datas['password'] = password;
    datas['type'] = type;
    return datas;
  }
}