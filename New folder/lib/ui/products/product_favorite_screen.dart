import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_gird.dart';
import '../shared/app_drawer.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_manager.dart';
import 'top_right_badge.dart';
import 'products_manager.dart';
import '../screens.dart';

// enum FilterOptions { favorites, all}

class ProductsFavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite';
  const ProductsFavoriteScreen({super.key});

  @override
  State<ProductsFavoriteScreen> createState() => _ProductsFavoriteScreenState();
}

class _ProductsFavoriteScreenState extends State<ProductsFavoriteScreen> {
  var _showOnlyFavorites = ValueNotifier<bool>(true);
  late Future<void> _fetchProducts;

  @override
  void initState(){
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: true,
        leadingWidth: 40,
        title: const Text('Favorite',style: TextStyle(color: Colors.black),),
        // leading: TextButton(
        //   onPressed: () {},
        //   child: const Icon(Icons.dehaze_outlined,
        //     color: Colors.black),
        // ),
        // child: const actions: <Widget>[
        //     buildProductFilterMenu(),
        //     buildShoppingCartIcon(),
        //   ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
              valueListenable: _showOnlyFavorites,
              builder: (context, onlyFavorites, child){
                return ProductsGrid(onlyFavorites);
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