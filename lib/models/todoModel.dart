class Todo {
  int? id;
  String? todo;
  String? type;
  bool? complete;

  Todo({
    this.id,
    this.todo,
    this.type,
    this.complete,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        todo = json['todo'],
        type = json['type'],
        complete = json['complete'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'type': type,
      'complete': complete,
    };
  }
}
