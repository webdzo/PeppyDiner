class UpdatemodeRequest {
  UpdatemodeRequest({
    required this.mode,
    required this.value,
  });
  late final String mode;
  late final String value;

  UpdatemodeRequest.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['mode'] = mode;
    datas['value'] = value;
    return datas;
  }
}
