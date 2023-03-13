class SearchModel {
  SearchModel({
    String? title,
  }) {
    _title = title;
  }

  SearchModel.fromJson(dynamic json) {
    _title = json['title'];
  }

  String? _title;

  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    return map;
  }
}
