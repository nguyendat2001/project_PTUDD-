import 'package:flutter/material.dart';
import './app_drawer.dart';
import '../shared/app_drawer.dart';
import '../screens.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin';
  // const AdminScreen ({super.key});

  final List<MenuOption> options = [
    MenuOption(
      title: 'Users',
      imageurl: 'https://images.pexels.com/photos/3823488/pexels-photo-3823488.jpeg?auto=compress&cs=tinysrgb&w=600',
      routeName: '/admin/user',
    ),
    MenuOption(
      title: 'Products',
      imageurl: 'https://images.pexels.com/photos/573315/pexels-photo-573315.jpeg?auto=compress&cs=tinysrgb&w=600',
      routeName: '/user-products',
    ),
    MenuOption(
      title: 'Orders',
      imageurl: 'https://images.pexels.com/photos/6169186/pexels-photo-6169186.jpeg?auto=compress&cs=tinysrgb&w=600',
      routeName: '/orders_admin',
    ),
  ];



  @override
  Widget build(BuildContext context) {
    print('manager admin');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Manager'),
      ),
      drawer: const AdminDrawer(),
      body: GridView.count(
        padding: EdgeInsets.all(10),
        crossAxisCount: 2,
        children: options.map((option) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(option.routeName);
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(option.imageurl), 
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8),
                  Text(
                    option.title,
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 40, 
                    ),
                  ),
                ],
              ),
            ),
            ),
          );
        }).toList(),
      ),

    );
    
  }
}

class MenuOption {
  final String title;
  final String routeName;
  final String imageurl;

  MenuOption({
    required this.title,
    required this.routeName,
    required this.imageurl,
  });
}