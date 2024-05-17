class Product{
  final int? _id;
  final String? _title;
  final String? _description;
  final double? _price;
  final double? _discountPercentage;
  final double? _rating;
  final int? _stock;
  final String? _brand;
  final String? _category;
  final String? _thumbnail;
  final List<String>? _images;

  Product(int? id, String? title, String? description, double? price, double? discountPercentage, double? rating, int? stock, String? brand, String? category, String? thumbnail, List<String>? images)
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

}