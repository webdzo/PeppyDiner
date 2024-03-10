class BillpaymentModel {
  BillpaymentModel({
    required this.subTotalAmount,
    required this.serviceCharge,
    required this.taxGst,
    required this.flatDiscount,
    required this.flatDiscountType,
    required this.totalAmount,
    required this.paymentMode,
  });
  late final int subTotalAmount;
  late final int serviceCharge;
  late final int taxGst;
  late final int flatDiscount;
  late final String flatDiscountType;
  late final int totalAmount;
  late final String paymentMode;

  BillpaymentModel.fromJson(Map<String, dynamic> json) {
    subTotalAmount = json['sub_total_amount'];
    serviceCharge = json['service_charge'] ?? 0;
    taxGst = int.tryParse(json['tax_gst'].toString())?.toInt() ?? 0;
    flatDiscount = json['flat_discount'] ?? 0;
    flatDiscountType = json['flat_discount_type'];
    totalAmount =
        double.tryParse(json['total_amount'].toString())?.toInt() ?? 0;
    paymentMode = json['payment_mode'].isNotEmpty
        ? (json['payment_mode'].first ?? "")
        : "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['sub_total_amount'] = subTotalAmount;
    datas['service_charge'] = serviceCharge;
    datas['tax_gst'] = taxGst;
    datas['flat_discount'] = flatDiscount;
    datas['flat_discount_type'] = flatDiscountType;
    datas['total_amount'] = totalAmount;
    datas['payment_mode'] = paymentMode;
    return datas;
  }
}
