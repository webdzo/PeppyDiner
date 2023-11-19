class ServicechargeModel {
  ServicechargeModel({
    required this.id,
    required this.percentage,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int percentage;
  late final String createdAt;
  late final String updatedAt;

  ServicechargeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    percentage = json['percentage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['percentage'] = percentage;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    return datas;
  }
}
