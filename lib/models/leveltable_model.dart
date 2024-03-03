class LeveltableModel {
  LeveltableModel({
    required this.message,
    required this.bookedTables,
  });
  late final String message;
  late final List<BookedTables> bookedTables;

  LeveltableModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    bookedTables = List.from(json['booked_tables'])
        .map((e) => BookedTables.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['message'] = message;
    datas['booked_tables'] = bookedTables.map((e) => e.toJson()).toList();
    return datas;
  }
}

class BookedTables {
  BookedTables({
    required this.id,
    required this.name,
    required this.category,
    required this.floor,
    required this.occupancy,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });
  late final int id;
  late final String name;
  late final int category;
  late final String floor;
  late final String occupancy;
  late final bool isAvailable;
  late final String createdAt;
  late final String updatedAt;
  late final String status;

  BookedTables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    floor = json['floor'];
    occupancy = json['occupancy'];
    isAvailable = json['isAvailable'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['category'] = category;
    datas['floor'] = floor;
    datas['occupancy'] = occupancy;
    datas['isAvailable'] = isAvailable;
    datas['created_at'] = createdAt;
    datas['status'] = status;
    return datas;
  }
}
