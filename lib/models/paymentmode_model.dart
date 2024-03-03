class PaymentmodeModel {
  PaymentmodeModel({
    required this.id,
    required this.paymentName,
    required this.parentId,
    required this.paymentType,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String paymentName;
  late final String parentId;
  late final String paymentType;
  late final bool paymentStatus;
  late final String createdAt;
  late final String updatedAt;

  PaymentmodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentName = json['payment_name'];
    parentId = "";
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['payment_name'] = paymentName;
    datas['parent_id'] = parentId;
    datas['payment_type'] = paymentType;
    datas['payment_status'] = paymentStatus;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    return datas;
  }
}
