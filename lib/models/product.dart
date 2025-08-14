class Product {
  final int id;
  final String name;
  final String? image;
  final String price;
  final String? sku;

  Product({required this.id, required this.name, this.image, required this.price, this.sku});

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['id'],
      name: j['name'] ?? '',
      image: (j['images'] is List && j['images'].isNotEmpty) ? j['images'][0]['src'] : null,
      price: j['price']?.toString() ?? '0',
      sku: j['sku'],
    );
  }
}
