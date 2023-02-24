import 'package:flutter/material.dart';

class Users{
  final String email;
  final String password;

  Users({required this.email, required this.password});

  Map<String, dynamic> toJson() =>{
    'email': email,
    'password': password
  };

  static Users fromJson(Map<String, dynamic> json) =>
      Users(email: json['email'],
          password: json['password']);
}