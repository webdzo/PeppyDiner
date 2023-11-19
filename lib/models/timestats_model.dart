class TimestatsModel {
  TimestatsModel({
    required this.count,
    required this.day,
    required this.total,
  });
  late final int count;
  late final String day;
  late final String total;

  TimestatsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    day = json['day'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['count'] = count;
    datas['day'] = day;
    datas['total'] = total;
    return datas;
  }
}
