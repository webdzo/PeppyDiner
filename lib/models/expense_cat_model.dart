class ExpenseCatModel {
  ExpenseCatModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.organizationId,
  });
  late final int id;
  late final String name;
  late final String type;
  late final String createdAt;
  late final String updatedAt;
  late final int organizationId;

  ExpenseCatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    organizationId = json['organizationId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['organizationId'] = organizationId;
    return data;
  }
}
