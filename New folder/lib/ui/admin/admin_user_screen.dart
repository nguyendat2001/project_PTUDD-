import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import './app_drawer.dart';
import 'package:provider/provider.dart';
import '../shared/app_drawer.dart';
import '../screens.dart';
import '../auth/auth_manager.dart';

class UsersScreen extends StatelessWidget {

  static const routeName = '/admin/user';
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersManager = Provider.of<AuthManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      drawer: const AdminDrawer(),
      body: FutureBuilder(
        future: usersManager.fetchUsers(false),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          return RefreshIndicator(
            onRefresh: () => usersManager.fetchUsers(true),
            child: buildUserListView(),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget buildUserListView() {
    return Consumer<AuthManager>(
      builder: (context, authManager, child) {
        final users = authManager.items;

        if (users.isEmpty) {
          return Center(child: Text('No users found.'));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: 
              IconButton(
                  onPressed: () async {      
                    String id = user.id.toString();
                    final UsersService _usersService = UsersService();
                      await _usersService.deleteUser(id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User has been deleted.')),
                      );
                  },
                  icon: Icon(Icons.delete),
                ),
            );
          },
        );
      },
    );
  }
  
}