enum FoodCategory { burgers, salads, sides, desserts, drinks }

FoodCategory stringToFoodCategory(String category) {
  switch (category.trim().toLowerCase()) {
    case 'burgers':
    case 'burger':
    case 'main':
    case 'main_course':
    case 'maincourse':
      return FoodCategory.burgers;
    case 'salads':
    case 'salad':
      return FoodCategory.salads;
    case 'sides':
    case 'side':
    case 'snack':
      return FoodCategory.sides;
    case 'desserts':
    case 'dessert':
    case 'sweet':
      return FoodCategory.desserts;
    case 'drinks':
    case 'drink':
    case 'beverage':
      return FoodCategory.drinks;
    default:
      return FoodCategory.burgers;
  }
}

double _parsePrice(dynamic rawPrice) {
  if (rawPrice is num) {
    return rawPrice.toDouble();
  }
  if (rawPrice is String) {
    return double.tryParse(rawPrice) ?? 0.0;
  }
  return 0.0;
}

class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
  });

  factory Food.fromMap(Map<String, dynamic> data) {
    return Food(
      name: (data['name'] ?? data['title'] ?? 'Sản phẩm').toString(),
      description: (data['description'] ?? '').toString(),
      imagePath: (data['imagePath'] ?? data['image'] ?? data['thumbnail'] ?? '')
          .toString(),
      price: _parsePrice(data['price']),
      category:
          stringToFoodCategory((data['category'] ?? 'burgers').toString()),
    );
  }
}
