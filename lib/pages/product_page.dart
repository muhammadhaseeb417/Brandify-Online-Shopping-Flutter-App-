import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../widgets/size_box.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  final int productId;
  List<int> sizeList = [8, 9, 10, 12, 14];
  final ProductController productController = Get.find(); // Find the controller

  ProductPage({
    super.key,
    required this.product,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            if (productController.favoriteProducts.contains(product)) {
              productController
                  .removeFromFavorites(productId); // Remove from favorites
            } else {
              productController.addToFavorites(productId); // Add to favorites
            }
          },
          icon: Obx(() => Icon(
                productController.favoriteProducts.contains(product)
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                size: 30,
              )),
        ),
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        _productImage(context),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.03,
        ),
        _productDescription(context),
      ],
    );
  }

  Widget _productImage(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.45,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: NetworkImage(product.image),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _productDescription(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topProductDescription(context),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            Text(product.description),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.04,
            ),
            Text(
              "Select a Size",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _selectASizeWidget(context),
            _addToCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _topProductDescription(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "\$${product.price.toString()}",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        Text(
          "⭐${product.rating.toString()}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _selectASizeWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.057,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sizeList.length,
        itemBuilder: (context, index) {
          int size = sizeList[index];
          return CustomSizeBox(
            sizeList: size,
            isSelected: index == 2, // Highlight the third size by default
          );
        },
      ),
    );
  }

  Widget _addToCartButton(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        height: MediaQuery.sizeOf(context).height * 0.054,
        margin: EdgeInsets.symmetric(vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            if (productController.cartProducts.contains(product)) {
              productController.removeFromCart(productId); // Remove from cart
            } else {
              productController.addToCart(productId); // Add to cart
            }
          },
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  productController.cartProducts.contains(product)
                      ? "Remove from Cart"
                      : 'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
