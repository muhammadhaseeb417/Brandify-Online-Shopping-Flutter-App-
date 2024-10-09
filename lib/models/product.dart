class Product {
  int id; // Unique product ID
  String name;
  String brand;
  num price;
  String category;
  int reviews;
  double rating;
  String description;
  String image;
  bool isFavorite;
  bool isCart;

  Product({
    required this.id, // Add the id here
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.reviews,
    required this.rating,
    required this.description,
    required this.image,
    this.isFavorite = false,
    this.isCart = false,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'], // Make sure the id comes from the JSON
      name: json['name'],
      brand: json['brand'],
      price: json['price'],
      category: json['category'],
      reviews: json['reviews'],
      rating: json['rating'],
      description: json['description'],
      image: json['image'],
    );
  }

  // Method to convert a Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include the id in the conversion to JSON
      'name': name,
      'brand': brand,
      'price': price,
      'category': category,
      'reviews': reviews,
      'rating': rating,
      'description': description,
      'image': image,
    };
  }
}
