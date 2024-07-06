class Favouritesmodel {
  int? id;
  int userId;
  int productId;
  String title;
  int price;
  String description;
  List<String> images;

  Favouritesmodel({
    this.id,
    required this.userId,
    required this.productId,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'title': title,
      'price': price,
      'description': description,
      'images': images,
    };
  }
}
