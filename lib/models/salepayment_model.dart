class SalepaymentModel {
  SalepaymentModel({
    required this.paymentMode,
    required this.totalAmount,
  });
  late final String paymentMode;
  late final String totalAmount;
  
  SalepaymentModel.fromJson(Map<String, dynamic> json){
    paymentMode = json['payment_mode'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['payment_mode'] = paymentMode;
    datas['total_amount'] = totalAmount;
    return datas;
  }
}