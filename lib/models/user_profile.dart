class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;
  String? gender; // Optional field
  String? phoneNumber; // Optional field
  List<int>? cart; // List of product IDs for the cart
  List<int>? favorites; // List of product IDs for favorite products

  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
    this.gender,
    this.phoneNumber,
    this.cart,
    this.favorites,
  });

  // Constructor for creating a UserProfile from a JSON object
  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    cart = List<int>.from(json['cart'] ?? []);
    favorites = List<int>.from(json['favorites'] ?? []);
  }

  // Method to convert UserProfile instance to a JSON object
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['uid'] = uid;
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['gender'] = gender;
    data['phoneNumber'] = phoneNumber;
    data['cart'] = cart ?? [];
    data['favorites'] = favorites ?? [];
    return data;
  }
}
