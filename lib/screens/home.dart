import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/colors.dart';
import 'package:todo_app_flutter/model/ToDo.dart';
import 'package:todo_app_flutter/widgets/todo_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/navigation_drawer_widget.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();
  final CollectionReference _todos =
      FirebaseFirestore.instance.collection('todos');

  String keywordSearch = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tdBGColor,
        drawer: NavigationDrawerWidget(),
        appBar: _buildAppBar(),
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
                          "All ToDos",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      buildStreamBuilder()
                    ],
                  )),
                  buildAddTextField()
                ],
              ),
            ),
          ],
        ));
  }

  Align buildAddTextField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                      hintText: "Add a new todo item",
                      border: InputBorder.none),
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  child: Text(
                    "+",
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    createToDo(todoText: _toDoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    return StreamBuilder(
        stream: _todos.snapshots(),
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
                        onDeleteItem: _deleteToDoItem,
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
                        onDeleteItem: _deleteToDoItem,
                        onToDoChange: _handleToDoChange);
                  }
                  return Container();
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future createToDo({required todoText}) async {
    final docToDo = FirebaseFirestore.instance
        .collection('todos')
        .doc(DateTime.now().microsecondsSinceEpoch.toString());

    final ToDo toDo = ToDo(id: docToDo.id, isDone: false, todoText: todoText);
    final json = toDo.toJson();
    await docToDo.set(json);

    _toDoController.clear();
  }

  void _handleToDoChange(ToDo toDo) {
    final docTodo = FirebaseFirestore.instance.collection('todos').doc(toDo.id);
    docTodo.update({'isDone': !toDo.isDone});
  }

  void _deleteToDoItem(String id) {
    final docTodo = FirebaseFirestore.instance.collection('todos').doc(id);
    docTodo.delete();
  }

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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpg'),
            ),
          )
        ],
      ),
    );
  }
}
