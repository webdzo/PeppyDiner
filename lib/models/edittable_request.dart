class EdittableRequest {
  EdittableRequest({
    this.name,
    this.category,
    this.floor,
    this.occupancy,
  });
  String? name;
  int? category;
  String? floor;
  String? occupancy;

  EdittableRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    floor = json['floor'];
    occupancy = json['occupancy'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['name'] = name;
    datas['category'] = category;
    datas['floor'] = floor;
    datas['occupancy'] = occupancy;
    return datas;
  }
}
