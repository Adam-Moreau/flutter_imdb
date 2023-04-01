class MoviesModel {
  MoviesModel({
    String? id,
    String? title,
    int? year,
    int? imageHeight,
    String? imageId,
    String? imageUrl,
    int? imageWidth,
    int? runningTimeInMinutes,
    String? titleType,
  }) {
    _id = id;
    _title = title;
    _year = year;
    _imageHeight = imageHeight;
    _imageId = imageId;
    _imageUrl = imageUrl;
    _imageWidth = imageWidth;
    _runningTimeInMinutes = runningTimeInMinutes ;
    _titleType = titleType ;
  }

  MoviesModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _year = json['year'];
    if (json['image'] != null) {
      _imageHeight = json['image']['height'];
      _imageId = json['image']['id'];
      _imageUrl = json['image']['url'];
      _imageWidth = json['image']['width'];
    }
    _runningTimeInMinutes = json['runningTimeInMinutes'];
    _titleType = json['titleType'] ;
  }

  String? _id;
  String? _title;
  int? _year;
  int? _imageHeight;
  String? _imageId;
  String? _imageUrl;
  int? _imageWidth;
  int? _runningTimeInMinutes;
  String? _titleType ;


  String? get id => _id;
  String? get title => _title;
  int? get year => _year;
  int? get imageHeight => _imageHeight;
  String? get imageId => _imageId;
  String? get imageUrl => _imageUrl;
  int? get imageWidth => _imageWidth;
  int? get runningTimeInMinutes => _runningTimeInMinutes;
  String? get titleType => _titleType ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['year'] = _year;
    if (_imageHeight != null && _imageId != null && _imageUrl != null && _imageWidth != null) {
      map['image'] = {
        'height': _imageHeight,
        'id': _imageId,
        'url': _imageUrl,
        'width': _imageWidth,
      };
    }
    map['runningTimeInMinutes'] = _runningTimeInMinutes ;
    map['titleType'] = _titleType;
    return map;
  }
}
