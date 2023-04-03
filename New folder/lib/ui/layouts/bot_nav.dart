import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../products/user_products_screen.dart';
import '../products/products_overview_screen.dart';



class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  String _direct = "/";
  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
            color: Colors.green),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded,
            color: Colors.green
            ),
            label: 'Like',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
            color: Colors.green),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets,
            color: Colors.green),
            label: 'Open Dialog',
          ),
          
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: (int index) {
          setState(
                () {
                  _selectedIndex = index;
                },
          );
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacementNamed('/');
               _selectedIndex = index;
              break;
            case 1:
              Navigator.of(context)
              .pushReplacementNamed('/favorite');
               _selectedIndex = index;
              break;
            case 2:
              Navigator.of(context)
              .pushReplacementNamed('/user-products');
               _selectedIndex = index;
              break;
            case 3:
               Navigator.of(context)
              .pushReplacementNamed('/orders');
               _selectedIndex = index;
              break;
          }
        },
    );
  }
}

