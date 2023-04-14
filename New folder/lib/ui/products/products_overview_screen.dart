import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_gird.dart';
import '../shared/app_drawer.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_manager.dart';
import 'top_right_badge.dart';
import 'products_manager.dart';
import '../screens.dart';

enum FilterOptions { favorites, all}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;

  @override
  void initState(){
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await context.read<ProductsManager>().fetchProducts(false);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: true,
        leadingWidth: 40,
        title: const Text('E-commerce',style: TextStyle(color: Colors.black),),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
              valueListenable: _showOnlyFavorites,
              builder: (context, onlyFavorites, child){
                return ProductsList(onlyFavorites);
              }
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

}