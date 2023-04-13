import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../products/user_products_screen.dart';

class AdminDrawer extends StatelessWidget{
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            elevation: 0,
            backgroundColor: Color(0xFFFFFFFF),
            automaticallyImplyLeading: false,
            leadingWidth: 40,
            leading: TextButton(
              onPressed: () {
                Navigator.of(context)
              ..pop()
              ..pushReplacementNamed('/admin');
              },
              child: Icon(Icons.home,
                                color: Colors.green
                              ),
            ),

            title: const Text("Hello Admin!",style: TextStyle(color: Colors.black),),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: (){
              Navigator.of(context)
              ..pop()
              ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop,
            color: Colors.green),
            title: const Text('User'),
            onTap: (){
              // Navigator.of(context).pushReplacementNamed('/admin/user');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit,
            color: Colors.green),
            title: const Text('Manage Products'),
            onTap: (){
              Navigator.of(context)
              .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment,
            color: Colors.green),
            title: const Text('Orders'),
            onTap: (){
              Navigator.of(context)
              .pushReplacementNamed('product/order');
            },
          ),
          
        ],
      ),
    );
  }
}