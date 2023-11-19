class DiscountModel {
  DiscountModel({
    required this.id,
    required this.discountCode,
    required this.parentId,
    required this.discountValue,
    required this.discountType,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String discountCode;
  late final String parentId;
  late final int discountValue;
  late final String discountType;
  late final String createdAt;
  late final String updatedAt;

  DiscountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountCode = json['discount_code'];
    parentId = json['parent_id'] ?? "";
    discountValue = json['discount_value'];
    discountType = json['discount_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['discount_code'] = discountCode;
    datas['parent_id'] = parentId;
    datas['discount_value'] = discountValue;
    datas['discount_type'] = discountType;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    return datas;
  }
}
