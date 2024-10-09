import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_page.dart';
import '../controllers/product_controller.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  final ProductController productController =
      Get.put(ProductController()); // Initialize controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Favorites"),
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        // Using the favoriteProducts list from the controller
        var favoriteProducts = productController.favoriteProducts;

        return favoriteProducts.isEmpty
            ? Center(child: Text('No favorite products'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  Product product = favoriteProducts[index];

                  return ProductCard(
                    product: product,
                    productId: index, // Pass the index
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductPage(
                              product: product,
                              productId: index,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
      }),
    );
  }
}
