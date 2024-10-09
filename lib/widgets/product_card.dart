import 'package:brand_shoes/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productId; // Unique identifier for each product
  final Function onTap;
  final ProductController productController =
      Get.find(); // Use the existing instance of the controller

  ProductCard({
    super.key,
    required this.product,
    required this.productId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: NetworkImage(product.image),
            fit: BoxFit.contain,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$${product.price.toString()}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() => GestureDetector(
                      onTap: () {
                        if (productController.favoriteProducts
                            .contains(product)) {
                          productController.removeFromFavorites(productId);
                        } else {
                          productController.addToFavorites(productId);
                        }
                      },
                      child: Icon(
                        productController.favoriteProducts.contains(product)
                            ? Icons.favorite // Filled icon if favorite
                            : Icons
                                .favorite_border_outlined, // Outline icon if not
                        size: 30,
                      ),
                    )),
              ],
            ),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.07,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flexible widget to ensure the text wraps
                  Flexible(
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .black, // Optional, to contrast the black background
                      ),
                      maxLines: 2, // Allows up to 2 lines before truncating
                      overflow: TextOverflow
                          .ellipsis, // If it exceeds 2 lines, it shows '...'
                    ),
                  ),
                  Obx(() => GestureDetector(
                        onTap: () {
                          if (productController.cartProducts
                              .contains(product)) {
                            productController.removeFromCart(productId);
                          } else {
                            productController.addToCart(productId);
                          }
                        },
                        child: Icon(
                          productController.cartProducts.contains(product)
                              ? Icons.shopping_bag // Filled icon if in cart
                              : Icons
                                  .shopping_bag_outlined, // Outline icon if not
                          size: 30,
                          color: Colors.black, // Optional, to match the theme
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
