class BywaiterModel {
  BywaiterModel({
    required this.ordersCount,
    required this.firstname,
  });
  late final int ordersCount;
  late final String firstname;

  BywaiterModel.fromJson(Map<String, dynamic> json) {
    ordersCount = json['orders_count'];
    firstname = json['firstname'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['orders_count'] = ordersCount;
    datas['firstname'] = firstname;
    return datas;
  }
}
