import 'package:flutter/material.dart';
import 'package:test_2/Services/database.dart';
import 'package:test_2/main.dart';
import 'dart:async';
import 'dart:core';

//import 'package:sqflite/sqlite_api.dart';
import 'package:test_2/shared/Note.dart';

//void main() {
//  runApp(NewNote());
//}

class NewNote extends StatefulWidget {
  Note note;
  NewNote(this.note);
  @override
  _NewNoteState createState() => _NewNoteState(note);
}

class _NewNoteState extends State<NewNote> {
  Note note;
  _NewNoteState(this.note);
  var _title_controller = TextEditingController();
  var _content_controller = TextEditingController();
  String title;
  String content;
  int id, date_created, date_updated;

  @override
  void initState() {
    title = note.title;
    content = note.content;
    id = note.id;
    date_created = note.date_created;
    date_updated = note.date_updated;
    _title_controller.text = title;
    _content_controller.text = content;
    if (id == 0) {
      updateNote(note, true);
    } else {
      updateNote(note, false);
    }
  }

  void updateNote(Note note, bool isNew) async {
    int currenttime = DateTime.now().millisecondsSinceEpoch;
    if (isNew) {
      note.id = currenttime;
      note.date_created = currenttime;
      note.date_updated = currenttime;
      note.title = '';
      note.content = '';
      await insertNote(note, true);
    } else {
      note.date_updated = currenttime;
      await insertNote(note, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                if (id != 0) {
                  await deleteNote(note);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
            )
          ],
          title: Text('Edit Note'),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  maxLines: 1,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(hintText: 'Title'),
                  focusNode: FocusNode(),
                  controller: _title_controller,
                  style: TextStyle(),
                  onChanged: (val) {
                    note.title = val;
                    updateNote(note, false);
                  },
                ),
                TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: 'Note here',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none),
                  cursorColor: Colors.black,
                  focusNode: FocusNode(),
                  controller: _content_controller,
                  style: TextStyle(),
                  onChanged: (val) {
                    note.content = val;
                    updateNote(note, false);
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            updateNote(note, false);
            Navigator.pop(context);
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
