class ItemstatsModel {
  ItemstatsModel({
    required this.items,
    required this.categories,
  });
  late final List<Items> items;
  late final List<Categories> categories;

  ItemstatsModel.fromJson(Map<String, dynamic> json) {
    items = List.from(json['items']).map((e) => Items.fromJson(e)).toList();
    categories = List.from(json['categories'])
        .map((e) => Categories.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['items'] = items.map((e) => e.toJson()).toList();
    datas['categories'] = categories.map((e) => e.toJson()).toList();
    return datas;
  }
}

class Items {
  Items({
    required this.name,
    required this.count,
  });
  late final String name;
  late final int count;

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['name'] = name;
    datas['count'] = count;
    return datas;
  }
}

class Categories {
  Categories({
    required this.count,
    required this.name,
  });
  late final int count;
  late final String name;

  Categories.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['count'] = count;
    datas['name'] = name;
    return datas;
  }
}
