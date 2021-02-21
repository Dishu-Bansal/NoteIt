import 'package:flutter/material.dart';
import 'package:test_2/shared/todo.dart';

class todoTile extends StatefulWidget {
  Todo task;

  todoTile(this.task);
  @override
  _todoTileState createState() => _todoTileState(task);
}

class _todoTileState extends State<todoTile> {
  Todo task;
  _todoTileState(this.task);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (val) {
              if (val) {
                task.done = 'yes';
              } else {
                task.done = 'no';
              }
            },
          )
        ],
      ),
    );
  }
}
