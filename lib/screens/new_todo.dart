import 'package:flutter/material.dart';
import 'package:test_2/shared/todo.dart';

class NewToDo extends StatefulWidget {
  List<Todo> todos;

  NewToDo(this.todos);
  @override
  _NewToDoState createState() => _NewToDoState(todos);
}

class _NewToDoState extends State<NewToDo> {
  List<Todo> todos;

  _NewToDoState(this.todos);

  TextEditingController _titlecontroller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          maxLines: 1,
          controller: _titlecontroller,
        ),
      ],
    );
  }
}
