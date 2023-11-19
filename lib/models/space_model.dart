class SpaceModel {
  SpaceModel({
    required this.id,
    required this.name,
    required this.identifier,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final int identifier;
  late final String createdAt;
  late final String updatedAt;
  
  SpaceModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    identifier = json['identifier'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['identifier'] = identifier;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}