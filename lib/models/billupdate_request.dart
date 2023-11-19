class BillupdateRequest {
  BillupdateRequest({
    required this.data,
  });
  late final BillData data;

  BillupdateRequest.fromJson(Map<String, dynamic> json) {
    data = BillData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['data'] = data.toJson();
    return datas;
  }
}

class BillData {
  BillData({
    this.taxGst,
    this.serviceCharge,
    this.flatDiscount,
    this.paymentMode,
  });
  String? taxGst;
  int? serviceCharge;
  String? flatDiscount;
  String? paymentMode;

  BillData.fromJson(Map<String, dynamic> json) {
    taxGst = json['tax_gst'];
    serviceCharge = json['service_charge'];
    flatDiscount = json['flat_discount'];
    paymentMode = json['payment_mode'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['tax_gst'] = taxGst;
    datas['service_charge'] = serviceCharge;
    datas['flat_discount'] = flatDiscount;
    datas['payment_mode'] = paymentMode;
    return datas;
  }
}
