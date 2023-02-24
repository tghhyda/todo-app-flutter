import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../model/ToDo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/todo_item.dart';

class InCompletePage extends StatefulWidget {
  @override
  State<InCompletePage> createState() => _InCompletePageState();
}

class _InCompletePageState extends State<InCompletePage> {
  final CollectionReference _todos = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos');

  String keywordSearch = "";

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        title: Text('InComplete'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                    child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 20),
                      child: Text(
                        "All ToDos InComplete",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      ),
                    ),
                    buildStreamBuilder()
                  ],
                )),
              ],
            ),
          ),
        ],
      ));

  void _runFilter(String keyword) {
    setState(() {
      keywordSearch = keyword;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    return StreamBuilder(
        stream: _todos.where('isDone', isEqualTo: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot docSnap = snapshot.data!.docs[index];
                  if (keywordSearch.isEmpty) {
                    final ToDo temp = new ToDo(
                        id: docSnap['id'],
                        todoText: docSnap['todoText'],
                        isDone: docSnap['isDone']);
                    return ToDoItem(
                        toDo: temp,
                        onDeleteItem: null,
                        onToDoChange: _handleToDoChange);
                  }
                  if (docSnap['todoText']
                      .toString()
                      .toLowerCase()
                      .startsWith(keywordSearch.toLowerCase())) {
                    final ToDo temp = new ToDo(
                        id: docSnap['id'],
                        todoText: docSnap['todoText'],
                        isDone: docSnap['isDone']);
                    return ToDoItem(
                        toDo: temp,
                        onDeleteItem: null,
                        onToDoChange: _handleToDoChange);
                  }
                  return Container();
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void _handleToDoChange(ToDo toDo) {
    final docTodo = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(toDo.id);
    docTodo.update({'isDone': !toDo.isDone});
  }
}
