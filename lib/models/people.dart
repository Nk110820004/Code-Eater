class Person {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final PromoCategories category;
  List<Addon> availableAddons;

  Person({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });
}
enum PromoCategories{
  Digital_Marketing,
  Traditional_Marketing,
  Direct_Marketing,
  Experiential_Marketing,
  B2B_Marketing,
  B2C_Marketing,
  Niche_Marketing,
}

class Addon {
  String name;
  double price;


  Addon({
    required this.name,
    required this.price,
  });
}