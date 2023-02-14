class ToDo{
  String? id;
  String? todoText;
  bool isDone;

  ToDo({required this.id, this.isDone = false, this.todoText});

  Map<String, dynamic> toJson() =>{
    'id': id,
    'isDone': isDone,
    'todoText': todoText
  };

  static ToDo fromJson(Map<String, dynamic> json) =>
      ToDo(id: json['id'],
      todoText: json['todoText'],
      isDone: json['isDone']);
}