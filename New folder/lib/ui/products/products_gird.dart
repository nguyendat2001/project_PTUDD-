import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import 'product_gird_tile.dart';
import 'product_list_tile.dart';
import 'products_manager.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductsManager();
    final products = context.select<ProductsManager, List<Product>>(
      (productsManager) => showFavorites
        ? productsManager.favoriteItems
        : productsManager.items);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Row(
                children: [
                  Container(
                    height: 45.0,
                    width: 300.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      border: Border.all(color:  Color(0xFF2FA849)),
                      boxShadow: [
                        BoxShadow(
                          color:  Color(0xFF2FA849).withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 45,
                          width: 250,
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                            ),
                          ),
                        ),
                        Icon(Icons.widgets,
                          color: Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 45.0,
                    width: 45.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color:  Color(0xFF2FA849),
                      boxShadow: [
                        BoxShadow(
                          color:  Color(0xFF2FA849).withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(Icons.widgets,
                          color: Colors.green),
                  ),
                ],
              ),
            ),

          Column(
            children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => ProductListTile(products[i]),
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 2,
                  //   childAspectRatio: 3 / 2,
                  //   crossAxisSpacing: 10,
                  //   mainAxisSpacing: 10,
                  // ),
              ),
            ],
          ),
          
        ],
      ),
    );



  }
}

class ProductsList extends StatelessWidget {
  final bool showFavorites;

  const ProductsList(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductsManager();
    final products = context.select<ProductsManager, List<Product>>(
      (productsManager) => showFavorites
        ? productsManager.favoriteItems
        : productsManager.items);
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      
    );
  }
}