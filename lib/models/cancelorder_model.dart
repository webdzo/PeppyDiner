class CancelOrderModel {
  CancelOrderModel({
    required this.orderNo,
    required this.firstname,
    required this.createdAt,
  });
  late final String orderNo;
  late final String firstname;
  late final String createdAt;

  CancelOrderModel.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    firstname = json['firstname'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['order_no'] = orderNo;
    datas['firstname'] = firstname;
    datas['created_at'] = createdAt;
    return datas;
  }
}
