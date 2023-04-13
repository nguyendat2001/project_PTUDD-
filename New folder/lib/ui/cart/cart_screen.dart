import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';
import '../orders/orders_manager.dart';
import '../screens.dart';

// class CartScreen extends StatefulWidget {
//   static const routeName = '/cart';
//   const CartScreen({super.key});
//   @override
//   State<CartScreen> createState() => _CartScreen();
// }

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});
  // late Future<void> _fetchCarts;

  Future<void> _refreshProducts(BuildContext context) async {
    // await context.read<ProductsManager>().fetchProducts(true);
    await context.read<CartManager>().fetchCarts(true);
  }

  @override
  Widget build(BuildContext context){
    final cartManager = CartManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done) {
              return buildCartDetails(cartManager, context);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
            if( context.read<CartManager>().itemCount > 0 ){
              context.read<OrdersManager>().addOrder(
                context.read<CartManager>().products,
                context.read<CartManager>().totalAmount,
              );
              print(context.read<CartManager>().itemCount);
              context.read<CartManager>().clear();
            }
        }, 
            
        label: const Text('Order'),
        icon: const Icon(Icons.add_card_rounded),
        backgroundColor: Colors.pink,
      ),
      bottomNavigationBar: const BottomNavBar(),
    );

  }

  Widget buildCartDetails(CartManager cartManager, BuildContext context){
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
      return Column(
                  children: <Widget>[
                    buildCartSummary(context),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                          itemCount: context.read<CartManager>().itemCount,
                          itemBuilder: (context, index) {
                            return CartItemCard(
                              productId: context.read<CartManager>().productEntries[index].productId,
                              cardItem: context.read<CartManager>().productEntries[index],
                            );
                          }
                        
                      ),
                    ),
                  ],
                );
            },
      
        );
  }


  Widget buildCartSummary( BuildContext context){
    return Card(
          margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${context.read<CartManager>().totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                      ),
                    ),
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ),
          );
      }
}