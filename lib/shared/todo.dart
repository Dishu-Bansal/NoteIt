class Todo {
  String task;
  String done;
  int date_updated;
  int id;

  Todo(this.id, this.done, this.task, this.date_updated);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      'done': done,
      'task': task,
      'date_updated': date_updated,
    };

    if (forUpdate) {
      data['id'] = id;
    }

    return data;
  }
}
