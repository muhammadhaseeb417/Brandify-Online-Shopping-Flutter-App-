import 'package:brand_shoes/consts.dart';
import 'package:brand_shoes/controllers/product_controller.dart';
import 'package:brand_shoes/data.dart';
import 'package:brand_shoes/models/brand.dart';
import 'package:brand_shoes/models/product.dart';
import 'package:brand_shoes/pages/product_page.dart';
import 'package:brand_shoes/servics/auth_service.dart';
import 'package:brand_shoes/servics/database_services.dart';
import 'package:brand_shoes/widgets/catagory_list.dart';
import 'package:brand_shoes/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class Home extends StatefulWidget {
  final GetIt _getIt = GetIt.instance;

  Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseServices _databaseServices;
  late AuthService _authService;
  Map<dynamic, dynamic>? _currentUserData;
  bool _isLoading = true;

  final ProductController productController = Get.find();

  @override
  void initState() {
    super.initState();
    _databaseServices = widget._getIt.get<DatabaseServices>();
    _authService = widget._getIt.get<AuthService>();

    // Fetch user data asynchronously in initState
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Attempt to fetch user data from the database
      _currentUserData = await _databaseServices.getDocuemntData(
        uid: _authService.user?.uid ??
            '', // Use null-aware operator to avoid null exceptions
      );

      // Check if widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle "No such document" or any other error
      print('Error fetching user data: $e');

      // Ensure widget is mounted before updating the state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUI(context),
    );
  }

  Widget buildUI(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userProfile(context),
            topBarText(),
            searchBarCustom(context),
            categoryList(context),
            productsCard(context),
          ],
        ),
      ),
    );
  }

  Widget userProfile(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.10,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.06,
            width: MediaQuery.sizeOf(context).height * 0.06,
            child: ClipOval(
              child: Image.network(
                _currentUserData?["pfpURL"] ?? PLACEHOLDER_PFP,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topBarText() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Discover',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Get the best sneakers here',
          style: TextStyle(
            color: Colors.black38,
          ),
        )
      ],
    );
  }

  Widget searchBarCustom(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.06,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.search),
            // Expanded to prevent Row from overflowing
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Your Favourites",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryList(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.06,
      width: MediaQuery.sizeOf(context).width,
      child: Obx(() {
        String selectedCategory = productController.selectedCategory.value;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: brands.length,
          itemBuilder: (context, index) {
            Brand brand = brands[index];
            bool isSelected = brand.name == selectedCategory;

            return CategoryList(
              brand: brand,
              isSelected: isSelected,
            );
          },
        );
      }),
    );
  }

  Widget productsCard(BuildContext context) {
    return Expanded(
      child: Obx(() {
        String selectedCategory = productController.selectedCategory.value;

        // Filter products based on the selected category
        List<Product> filteredProducts;
        if (selectedCategory.isEmpty) {
          // No category selected, show all products
          filteredProducts = products;
        } else {
          // Show products that match the selected category
          filteredProducts = products
              .where((product) => product.brand == selectedCategory)
              .toList();
        }

        // Handle case when no products match the selected category
        if (filteredProducts.isEmpty) {
          return Center(
            child: Text('No products found for this category'),
          );
        }

        // Display filtered products in a grid
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.80,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            Product product = filteredProducts[index];
            return ProductCard(
              product: product,
              productId: product.id, // Assuming product has an 'id' field
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductPage(
                        product: product,
                        productId: product.id,
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
