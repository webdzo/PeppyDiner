class BillpaymentModel {
  BillpaymentModel({
    required this.allItems,
    required this.taxGst,
    required this.serviceCharge,
    required this.flatDiscount,
    required this.paymentMode,
  });
  late final List<dynamic> allItems;
  late final int taxGst;
  late final int serviceCharge;
  late final String flatDiscount;
  late final String paymentMode;

  BillpaymentModel.fromJson(Map<String, dynamic> json) {
    allItems = List.castFrom<dynamic, dynamic>(json['all_items']);
    taxGst = json['tax_gst'];
    //TaxGst.fromJson(json['tax_gst']);
    serviceCharge = json['service_charge'];
    flatDiscount = json['flat_discount'];
    paymentMode = json["payment_mode"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['all_items'] = allItems;
    datas['tax_gst'] = taxGst;
    datas['service_charge'] = serviceCharge;
    datas['flat_discount'] = flatDiscount;
    datas['payment_mode'] = paymentMode;
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

  TaxGst.fromJson(Map<String, dynamic> json) {
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
