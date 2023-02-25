import 'package:flutter/material.dart';

class DrawItem{
  final String title;
  final IconData icon;

  DrawItem({required this.title, required this.icon});

  static List<DrawItem> listDrawItem(){
    return [
      DrawItem(title: 'Completed', icon: Icons.check),
      DrawItem(title: 'Incomplete', icon: Icons.clear)
    ];
  }
}