import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_page.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final ProductController productController =
      Get.put(ProductController()); // Initialize controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        // Using the cartProducts list from the controller
        var cartProducts = productController.cartProducts;

        return cartProducts.isEmpty
            ? Center(child: Text('No products in your cart'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                ),
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  Product product = cartProducts[index];

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
