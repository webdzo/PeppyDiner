class AvailableTablesModel {
  AvailableTablesModel({
    required this.tablesList,
    required this.reservations,
    required this.taxGst,
  });
  late final List<TablesList> tablesList;
  late final List<dynamic> reservations;
  late final TaxGst taxGst;
  
  AvailableTablesModel.fromJson(Map<String, dynamic> json){
    tablesList = List.from(json['tablesList']).map((e)=>TablesList.fromJson(e)).toList();
    reservations = List.castFrom<dynamic, dynamic>(json['reservations']);
    taxGst = TaxGst.fromJson(json['tax_gst']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['tablesList'] = tablesList.map((e)=>e.toJson()).toList();
    datas['reservations'] = reservations;
    datas['tax_gst'] = taxGst.toJson();
    return datas;
  }
}

class TablesList {
  TablesList({
    required this.id,
    required this.name,
    required this.category,
    required this.floor,
    required this.occupancy,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final int category;
  late final String floor;
  late final String occupancy;
  late final bool isAvailable;
  late final String createdAt;
  late final String updatedAt;
  
  TablesList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    category = json['category'];
    floor = json['floor'];
    occupancy = json['occupancy'];
    isAvailable = json['isAvailable'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    datas['updated_at'] = updatedAt;
    return datas;
  }
}

class TaxGst {
  TaxGst({
    required this.id,
    required this.tax,
    required this.gst,
    required this.gstin,
    required this.option,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String tax;
  late final String gst;
  late final String gstin;
  late final int option;
  late final String createdAt;
  late final String updatedAt;
  
  TaxGst.fromJson(Map<String, dynamic> json){
    id = json['id'];
    tax = json['tax'];
    gst = json['gst'];
    gstin = json['gstin'];
    option = json['option'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['tax'] = tax;
    datas['gst'] = gst;
    datas['gstin'] = gstin;
    datas['option'] = option;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    return datas;
  }
}

/* import 'package:intl/intl.dart';

class AvailableRoomsModel {
  AvailableRoomsModel({
    required this.availableRoomsWithDates,
    required this.extraBedCost,
    required this.taxGst,
  });
  late final List<RoomsModel> availableRoomsWithDates;
  late final String extraBedCost;
  late final TaxGst taxGst;

  AvailableRoomsModel.fromJson(Map<String, dynamic> json) {
    print(json);
    availableRoomsWithDates = List.from(json['available_rooms_with_dates'])
        .map((e) => RoomsModel.fromJson(e))
        .toList();
    extraBedCost = json['extra_bed_cost'];
    taxGst = TaxGst.fromJson(json['tax_gst']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['available_rooms_with_dates'] =
        availableRoomsWithDates.map((e) => e.toJson()).toList();
    data['extra_bed_cost'] = extraBedCost;
    data['tax_gst'] = taxGst.toJson();
    return data;
  }
}

class RoomsModel {
  RoomsModel({
    this.id,
    this.name,
    this.category,
    this.floor,
    this.extraBeds,
    this.price,
    this.occupancy,
    this.disabled,
    this.createdAt,
    this.updatedAt,
    this.availableDate,
    this.modifiedPrice,
    this.extraRoomsBooked,
    this.bookedDate,
  });
  int? id;
  String? name;
  int? category;
  int? floor;
  int? extraBeds;
  String? price;
  Occupancy? occupancy;
  bool? disabled;
  String? createdAt;
  String? updatedAt;
  String? availableDate;
  String? modifiedPrice;
  int? extraRoomsBooked;
  String? bookedDate;

  RoomsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    floor = json['floor'];
    extraBeds = 0;
    price = json['price'];
    occupancy = Occupancy.fromJson(json['occupancy']);
    disabled = json['disabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    availableDate = json['available_date'] ?? "";
    modifiedPrice = json['modified_price'];
    extraRoomsBooked = json['extra_rooms_booked'];
    bookedDate = (json['booked_date']?.toString().contains("T") ?? false)
        ? DateFormat("yyyy-MM-dd").format(DateTime.parse(json['booked_date']))
        : json['booked_date'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['floor'] = floor;
    data['extra_beds'] = extraBeds;
    data['price'] = price;
    data['occupancy'] = occupancy?.toJson();
    data['disabled'] = disabled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['available_date'] = availableDate;
    data['modified_price'] = modifiedPrice;
    data['extra_rooms_booked'] = extraRoomsBooked;
    data['booked_date'] = bookedDate;

    return data;
  }
}

class Occupancy {
  Occupancy({
    this.kids,
    this.adults,
  });
  int? kids;
  int? adults;

  Occupancy.fromJson(Map<String, dynamic> json) {
    kids = json['kids'];
    adults = json['adults'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['kids'] = kids;
    data['adults'] = adults;
    return data;
  }
}

class TaxGst {
  TaxGst({
    required this.id,
    required this.tax,
    required this.gst,
    required this.gstin,
    required this.option,
    required this.createdAt,
    required this.updatedAt,
    required this.organizationId,
  });
  late final int id;
  late final String tax;
  late final String gst;
  late final String gstin;
  late final int option;
  late final String createdAt;
  late final String updatedAt;
  late final int organizationId;

  TaxGst.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tax = json['tax'];
    gst = json['gst'];
    gstin = json['gstin'];
    option = json['option'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    organizationId = json['organizationId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['tax'] = tax;
    data['gst'] = gst;
    data['gstin'] = gstin;
    data['option'] = option;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['organizationId'] = organizationId;
    return data;
  }
}
 */