class HandleProducts{
  static List<dynamic> orderByPrice(List<dynamic> products){
    products.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
    return products;
  }

  static List<dynamic> orderByRating(List<dynamic> products){
    products.sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
    return products;
  }
}