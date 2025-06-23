class Deal {
  final String title;
  final String store;
  final String image;
  final double distance;
  final int discountPercent;
  final int discountedPrice;
  final int originalPrice;

  Deal({
    required this.title,
    required this.store,
    required this.image,
    required this.distance,
    required this.discountPercent,
    required this.discountedPrice,
    required this.originalPrice,
  });
}

class Category {
  final String name;
  final String emoji;

  Category({required this.name, required this.emoji});
}

class Seller {
  final String name;
  final String image;
  final double rating;

  Seller({required this.name, required this.image, required this.rating});
}
