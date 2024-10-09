import 'package:brand_shoes/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../models/user_profile.dart'; // Import the UserProfile class

class ProductController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var favoriteProducts = <Product>[].obs; // List for favorite products
  var cartProducts = <Product>[].obs; // List for cart products
  var selectedCategory = ''.obs;

  // Get user's Firestore document reference
  DocumentReference get userDoc =>
      firestore.collection('users').doc(auth.currentUser?.uid);

  // Fetch favorite and cart products on initialization
  @override
  void onInit() {
    super.onInit();
    _loadFavoritesAndCart();
  }

  // Load favorites and cart products from Firestore
  Future<void> _loadFavoritesAndCart() async {
    if (auth.currentUser != null) {
      DocumentSnapshot userData = await userDoc.get();

      // Clear previous data
      favoriteProducts.clear();
      cartProducts.clear();

      if (userData.exists) {
        // Convert Firestore data to UserProfile model
        UserProfile userProfile =
            UserProfile.fromJson(userData.data() as Map<String, dynamic>);

        // Load favorites and cart products from userProfile
        List<Product> loadedFavorites = [];
        List<Product> loadedCart = [];

        for (int id in userProfile.favorites ?? []) {
          Product? product = _findProductById(id);
          if (product != null) {
            loadedFavorites.add(product);
          }
        }

        for (int id in userProfile.cart ?? []) {
          Product? product = _findProductById(id);
          if (product != null) {
            loadedCart.add(product);
          }
        }

        favoriteProducts.value = loadedFavorites;
        cartProducts.value = loadedCart;
      }
    }
  }

  // Helper method to find the product by its id
  Product? _findProductById(int productId) {
    try {
      return products.firstWhere(
        (product) => product.id == productId,
        orElse: () => throw Exception('Product with id $productId not found'),
      );
    } catch (e) {
      print('Error finding product with id $productId: $e');
      return null;
    }
  }

  // Add a product to favorites
  // Add a product to favorites
  Future<void> addToFavorites(int productId) async {
    Product? product = _findProductById(productId);
    if (product != null && !favoriteProducts.contains(product)) {
      favoriteProducts.add(product);

      await userDoc.update({
        'favorites': FieldValue.arrayUnion([productId])
      });
    } else if (product == null) {
      print('Product with id $productId not found.');
    }
  }

// Remove a product from favorites
  Future<void> removeFromFavorites(int productId) async {
    Product? product = _findProductById(productId);
    if (product != null && favoriteProducts.contains(product)) {
      favoriteProducts.remove(product);

      await userDoc.update({
        'favorites': FieldValue.arrayRemove([productId])
      });
    } else if (product == null) {
      print('Product with id $productId not found.');
    }
  }

// Add a product to cart
  Future<void> addToCart(int productId) async {
    Product? product = _findProductById(productId);
    if (product != null && !cartProducts.contains(product)) {
      cartProducts.add(product);

      await userDoc.update({
        'cart': FieldValue.arrayUnion([productId])
      });
    } else if (product == null) {
      print('Product with id $productId not found.');
    }
  }

// Remove a product from cart
  Future<void> removeFromCart(int productId) async {
    Product? product = _findProductById(productId);
    if (product != null && cartProducts.contains(product)) {
      cartProducts.remove(product);

      await userDoc.update({
        'cart': FieldValue.arrayRemove([productId])
      });
    } else if (product == null) {
      print('Product with id $productId not found.');
    }
  }
}
