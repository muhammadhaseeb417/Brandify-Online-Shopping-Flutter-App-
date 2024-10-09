import 'package:brand_shoes/pages/cart_page.dart';
import 'package:brand_shoes/pages/favorite_page.dart';
import 'package:brand_shoes/pages/home.dart';
import 'package:brand_shoes/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          backgroundColor: Colors.white,
          elevation: 80,
          height: MediaQuery.sizeOf(context).height * 0.08,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (value) =>
              controller.selectedIndex.value = value,
          // indicatorColor: Theme.of(context).colorScheme.primary,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag),
              label: "Cart",
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: "Favorite",
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  Rx<int> selectedIndex = 0.obs;

  final screens = [
    Home(),
    CartPage(),
    FavoritePage(),
    ProfilePage(),
  ];

  void resetToHome() {
    selectedIndex.value = 0;
  }
}
