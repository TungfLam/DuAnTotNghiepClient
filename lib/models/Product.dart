class Product {
  final String name;
  final String price;
  final String imageUrl;
  bool isFavorite;

  Product({required this.name, required this.price, required this.imageUrl, this.isFavorite = false});
}