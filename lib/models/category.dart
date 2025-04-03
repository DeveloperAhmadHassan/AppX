class Category {
  final String? title;
  final String? id;
  final String? thumbnailUrl;

  Category({
    this.title,
    this.id,
    this.thumbnailUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      id: json['id'].toString(),
      thumbnailUrl: json['category_tile_url'],
    );
  }
}
