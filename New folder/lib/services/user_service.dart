import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';

class UsersService extends FirebaseService{
  UsersService([AuthToken? authToken]) :super(authToken);

  Future<List<User>> fetchUsers([bool filterByUser = false]) async{
    final List<User> users = [];

    try{
      final filters = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"':'';
      final usersUrl = 
        Uri.parse('$databaseUrl/users.json?auth=$token&$filters');
      final response = await http.get(usersUrl);
      final usersMap = json.decode(response.body) as Map<String, dynamic>;

      if(response.statusCode != 200){
        print(usersMap['error']);
        return users;
      }
      
      usersMap.forEach((userId, user){
        users.add(
          User.fromJson({
            'id': userId,
            ...user,
          })
        );
      });
      return users;
    }catch(error){
      // print(error);
      return users;
    }
  }

    Future<void> deleteUser(String userId) async {
  try {
    final deleteUrl =
        Uri.parse('$databaseUrl/users/$userId.json?auth=$token');
    final response = await http.delete(deleteUrl);

    if (response.statusCode != 200) {
      print(json.decode(response.body)['error']);
      return;
    }

    print('User with ID $userId has been deleted.');
  } catch (error) {
    print(error);
  }
}
 
}