import 'availableTables_model.dart';

class AddReservRequest {
  AddReservRequest(
      {this.user,
      this.selectedTables,
      this.date,
      this.time,
      this.totalPayment,
      this.advancePaid,
      this.flatDiscount,
      this.commission,
      this.balanceAmount,
      this.paymentmode,
      this.cake,
      this.quantity,
      this.occasion,
      this.package,
      this.event,
      this.notes,
      this.totalHeads,
      this.agentId});
  User? user;
  List<TablesList>? selectedTables;
  String? date;
  String? time;
  int? totalPayment;
  int? advancePaid;
  int? flatDiscount;
  int? commission;
  int? balanceAmount;
  int? cake;
  String? quantity;
  int? occasion;
  int? package;
  String? event;
  String? notes;
  String? totalHeads;
  int? agentId;
  String? startDate;
  String? paymentmode;

  AddReservRequest.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    selectedTables = List.from(json['selected_tables'])
        .map((e) => TablesList.fromJson(e))
        .toList();
    date = json['date'];
    time = json['time'];
    totalPayment = json['total_payment'];
    advancePaid = json['advance_paid'];
    flatDiscount = json['flat_discount'];
    commission = json['commission'];
    balanceAmount = json['balance_amount'];
    cake = json['cake'];
    quantity = json['quantity'];
    occasion = json['occasion'];
    package = json['package'];
    event = json['event'];
    notes = json['notes'];
    totalHeads = json['total_heads'];
    agentId = json['agent_id'];
    startDate = json['start_date'];
    package = json['paymentmode'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['user'] = user?.toJson();
    datas['selected_tables'] = selectedTables?.map((e) => e.toJson()).toList();
    datas['date'] = date;
    datas['time'] = time;
    datas['total_payment'] = totalPayment;
    datas['advance_paid'] = advancePaid;
    datas['flat_discount'] = flatDiscount;
    datas['commission'] = commission;
    datas['balance_amount'] = balanceAmount;
    datas['cake'] = cake;
    datas['quantity'] = quantity;
    datas['occasion'] = occasion;
    datas['package'] = package;
    datas['event'] = event;
    datas['notes'] = notes;
    datas['total_heads'] = totalHeads;
    datas['agent_id'] = agentId;
    datas['start_date'] = startDate;

    datas['paymentmode'] = paymentmode;
    return datas;
  }
}

class User {
  User({
    this.name,
    this.email,
    this.phone,
    this.address,
  });
  String? name;
  String? email;
  String? phone;
  String? address;

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['name'] = name;
    datas['email'] = email;
    datas['phone'] = phone;
    datas['address'] = address;
    return datas;
  }
}
