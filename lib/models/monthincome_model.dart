class MonthIncomeModel {
  MonthIncomeModel({
    required this.currTotal,
    required this.prevTotal,
  });
  late final String currTotal;
  late final String prevTotal;

  MonthIncomeModel.fromJson(Map<String, dynamic> json) {
    currTotal = json['curr_total'] ?? "0.0";
    prevTotal = json['prev_total'] ?? "0.0";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['curr_total'] = currTotal;
    data['prev_total'] = prevTotal;
    return data;
  }
}
