import 'package:brand_shoes/models/brand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class CategoryList extends StatelessWidget {
  final Brand brand;
  final bool isSelected;
  final ProductController productController = Get.find();

  CategoryList({
    super.key,
    required this.brand,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.sizeOf(context).width * 0.05;

    return GestureDetector(
      onTap: () {
        productController.selectedCategory.value = brand.name;
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02),
        decoration: BoxDecoration(
          border: isSelected ? null : Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          color: !isSelected
              ? Colors.transparent
              : Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: iconSize,
                width: iconSize,
                child: Image.network(
                  brand.iconURL,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                brand.name,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
