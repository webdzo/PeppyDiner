class BycatModel {
  BycatModel({
    required this.diningType,
    required this.ordersCount,
  });
  late final String diningType;
  late final int ordersCount;

  BycatModel.fromJson(Map<String, dynamic> json) {
    diningType = json['dining_type'];
    ordersCount = json['orders_count'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['dining_type'] = diningType;
    datas['orders_count'] = ordersCount;
    return datas;
  }
}
