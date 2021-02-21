import 'package:flutter/material.dart';
import 'package:test_2/Services/database.dart';
import 'package:test_2/screens/new_todo.dart';
import 'package:test_2/shared/Note.dart';
import 'package:test_2/shared/todo.dart';
import 'package:test_2/shared/todoTile.dart';
import 'shared/note_tile.dart';
import 'screens/new_note.dart';
import 'Services/database.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> notes_list;
  List<Map<String, dynamic>> todos_list;
  List<Note> notes = new List();
  List<Todo> todos = new List();
  @override
  void initState() {
    getNotesList();
    gettodosList();
  }

  void gettodosList() {
    Future<List<Map<String, dynamic>>> t = seletAlltodos();
    t.then((result) {
      setState(() {
        todos_list = result;
        convertMapToListfortodo(todos_list);
      });
    });
  }

  void getNotesList() {
    Future<List<Map<String, dynamic>>> note = seletAllNotes();
    note.then((result) {
      setState(() {
        notes_list = result;
        convertMapToList(notes_list);
      });
    });
  }

  void convertMapToListfortodo(List<Map<String, dynamic>> list) {
    todos.clear();
    for (Map<String, dynamic> n in list) {
      Todo d = Todo(n['id'], n['done'], n['task'], n['date_updated']);
      todos.add(d);
    }
  }

  void convertMapToList(List<Map<String, dynamic>> list) {
    notes.clear();
    for (Map<String, dynamic> n in list) {
      Note no = Note(n['id'], n['title'], n['content'], n['date_created'],
          n['date_updated']);
      notes.add(no);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Padding(padding: EdgeInsets.all(10), child: Text('Notes')),
              Padding(padding: EdgeInsets.all(10), child: Text('To do'))
            ]),
            title: Center(child: Text('Notes')),
            elevation: 10,
          ),
          body: TabBarView(
            children: [
              NotesView(notes, getNotesList),
              ToDoView(todos, gettodosList)
            ],
          )),
    );
  }
}

class ToDoView extends StatefulWidget {
  List<Todo> todos;
  Function gettodoList;

  ToDoView(this.todos, this.gettodoList);
  @override
  _ToDoViewState createState() => _ToDoViewState(todos, gettodoList);
}

class _ToDoViewState extends State<ToDoView> {
  List<Todo> todos;
  Function gettodoList;

  _ToDoViewState(this.todos, this.gettodoList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: (todos == null) ? 0 : todos.length,
          itemBuilder: (context, index) {
            Todo task = todos[index];
            var controller = TextEditingController();
            controller.text = task.task;
            return Row(
              children: [
                Checkbox(
                  value: (task.done == 'yes') ? true : false,
                  onChanged: (val) {
                    if (val) {
                      task.done = 'yes';
                    } else {
                      task.done = 'no';
                    }
                    insertToDo(task, false);
                    setState(() {
                      gettodoList();
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    focusNode: FocusNode(),
                    style: TextStyle(
                        decoration: (task.done == 'yes')
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                    cursorColor: Colors.black,
                    controller: controller,
                    onChanged: (val2) {
                      task.task = val2;
                      int currenttime = DateTime.now().millisecondsSinceEpoch;
                      task.date_updated = currenttime;
                      updateToDo(task);
                    },
                    decoration: InputDecoration(hintText: 'Enter Task'),
                  ),
                )
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            int currenttime = DateTime.now().millisecondsSinceEpoch;
            Todo new_task = Todo(currenttime, 'no', "", currenttime);
            insertToDo(new_task, true);
            gettodoList();
          });
        },
      ),
    );
  }
}

class NotesView extends StatefulWidget {
  List<Note> notes;
  Function getNotesList;
  NotesView(this.notes, this.getNotesList);
  @override
  _NotesViewState createState() => _NotesViewState(notes, getNotesList);
}

class _NotesViewState extends State<NotesView> {
  List<Note> notes;
  Function getNotesList;
  _NotesViewState(this.notes, this.getNotesList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notes == null ? 0 : notes.length,
        itemBuilder: (context, index) {
          if (notes != null) {
            return GestureDetector(
                onTap: () async {
                  var result = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return NewNote(notes[index]);
                  }));
                  setState(() {
                    getNotesList();
                  });
                },
                child: NoteTile(notes[index]));
          } else {
            return null;
          }
        },
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                Note n = Note(0, '', '', 0, 0);
                return NewNote(n);
              },
            ));
          },
          focusColor: Colors.blue[500],
          child: Icon(Icons.add)),
    );
  }
}
