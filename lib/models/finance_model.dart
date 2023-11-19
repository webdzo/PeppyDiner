class FinanceModel {
  FinanceModel({
    required this.income,
    required this.expense,
  });
  late final List<Income> income;
  late final List<Expense> expense;

  FinanceModel.fromJson(Map<String, dynamic> json) {
    income = List.from(json['income']).map((e) => Income.fromJson(e)).toList();
    expense =
        List.from(json['expense']).map((e) => Expense.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['income'] = income.map((e) => e.toJson()).toList();
    data['expense'] = expense.map((e) => e.toJson()).toList();
    return data;
  }
}

class Income {
  Income({
    required this.id,
    required this.identifier,
    required this.category,
    required this.categoryId,
    required this.price,
    required this.comments,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String identifier;
  late final String category;
  late final int categoryId;
  late final String price;
  late final String comments;
  late final String type;
  late final String createdAt;
  late final String updatedAt;

  Income.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    category = json['category'];
    categoryId = json['category_id'];
    price = json['price'];
    comments = json['comments'] ?? "";
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['identifier'] = identifier;
    data['category'] = category;
    data['category_id'] = categoryId;
    data['price'] = price;
    data['comments'] = comments;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Expense {
  Expense({
    required this.id,
    required this.identifier,
    required this.category,
    required this.categoryId,
    required this.price,
    required this.comments,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String identifier;
  late final String category;
  late final int categoryId;
  late final String price;
  late final String comments;
  late final String type;
  late final String createdAt;
  late final String updatedAt;

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'] ?? "";
    category = json['category'];
    categoryId = json['category_id'];
    price = json['price'];
    comments = json['comments'] ?? "";
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['identifier'] = identifier;
    data['category'] = category;
    data['category_id'] = categoryId;
    data['price'] = price;
    data['comments'] = comments;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
