class WCCategory {
  final int id;
  final String name;
  final String slug;
  final String? image;

  WCCategory({required this.id, required this.name, required this.slug, this.image});

  factory WCCategory.fromJson(Map<String, dynamic> j) {
    return WCCategory(
      id: j['id'],
      name: j['name'] ?? '',
      slug: j['slug'] ?? '',
      image: j['image'] != null ? j['image']['src'] : null,
    );
  }
}
