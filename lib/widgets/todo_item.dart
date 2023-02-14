import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/colors.dart';

import '../model/ToDo.dart';

class ToDoItem extends StatelessWidget {
  const ToDoItem(
      {super.key,
      required this.toDo,
      required this.onDeleteItem,
      required this.onToDoChange});
  final ToDo toDo;
  final onToDoChange;
  final onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChange(toDo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          toDo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          toDo.todoText!,
          style: TextStyle(
              fontSize: 16,
              color: tdBlack,
              decoration: toDo.isDone ? TextDecoration.lineThrough : null),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: tdRed, borderRadius: BorderRadius.circular(5)),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(toDo.id);
            },
          ),
        ),
      ),
    );
  }
}
