import 'package:flutter/foundation.dart';
class User {
  final String ?id;
  final String name;
  final String email;
  final String role;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
  }){
    return User(
      id: id ?? this.id, 
      name: name ?? this.name, 
      email: email ?? this.email, 
      role: role ?? this.role, 
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'email': email,
      'role': role,
    };
  }

  static User fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'], 
      name: json['name'], 
      email: json['email'], 
      role: json['role'], 
    );
  }
}