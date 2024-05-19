class Product{
  final dynamic _id;//
  final dynamic _title;//
  final dynamic _description;//
  final dynamic _price;//
  final dynamic _discountPercentage;//
  final dynamic _rating;//
  final dynamic _stock;//
  final dynamic _brand;//
  final dynamic _category;//
  final dynamic _thumbnail;//
  final List<dynamic>? _images;//

  Product(dynamic id, dynamic title, dynamic description, dynamic price, dynamic discountPercentage, dynamic rating, dynamic stock, dynamic brand, dynamic category, dynamic thumbnail, List<dynamic> images)
      : _id = id,
        _title = title,
        _description = description,
        _price = price,
        _discountPercentage = discountPercentage,
        _rating = rating,
        _stock = stock,
        _brand = brand,
        _category = category,
        _thumbnail = thumbnail,
        _images = images;

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  int? get price => _price;
  dynamic get discountPercentage => _discountPercentage;
  dynamic get rating => _rating;
  int? get stock => _stock;
  String? get brand => _brand;
  String? get category => _category;
  String? get thumbnail => _thumbnail;
  List<dynamic>? get images => _images;
}