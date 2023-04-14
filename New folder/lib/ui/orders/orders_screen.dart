import 'package:flutter/material.dart';
import '../../models/order_item.dart';
import 'package:provider/provider.dart';
import 'orders_manager.dart';
import 'order_item_card.dart';
import '../shared/app_drawer.dart';
import '../screens.dart';

class OrdersScreen extends StatelessWidget {

  
  static const routeName = '/orders';
  const OrdersScreen({super.key});
  Future<void> _refreshOrder(BuildContext context) async {
    // await context.read<ProductsManager>().fetchProducts(true);
    await context.read<OrdersManager>().fetchOrders(true);
  }

  @override
  Widget build(BuildContext context){
    print('building orders');
    final ordersManager = OrdersManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshOrder(context),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
              return buildorderDetails(context);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
          
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget buildorderDetails( BuildContext context){
    return Consumer<OrdersManager>(
        builder: (ctx, ordersManager, child){
          final orders = ordersManager.orders;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (ctx, i) => OrderItemCard(orders[i]),
          );
        },
      );
  }
}