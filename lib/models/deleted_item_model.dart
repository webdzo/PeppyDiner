class DeleteditemModel {
  DeleteditemModel({
    required this.itemName,
    required this.reason,
  });
  late final String itemName;
  late final String reason;

  DeleteditemModel.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['item_name'] = itemName;
    datas['reason'] = reason;
    return datas;
  }
}
