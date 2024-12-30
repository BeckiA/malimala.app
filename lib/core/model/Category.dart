class Category {
  String iconUrl;
  String name;
  bool featured;
  String categoryPath;
  Category({
    required this.name,
    required this.iconUrl,
    required this.featured,
    required this.categoryPath,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryPath: json['category_path'],
      featured: json['featured'],
      iconUrl: json['icon_url'],
      name: json['name'],
    );
  }
}
