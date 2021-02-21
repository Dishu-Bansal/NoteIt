import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:test_2/screens/new_note.dart';
import 'package:test_2/shared/Note.dart';
import 'Note.dart';

class NoteTile extends StatelessWidget {
  Note note;

  NoteTile(this.note);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue[200],
      elevation: 15,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Text(
              note.content,
              maxLines: 4,
              style: TextStyle(
                fontSize: 17.0,
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
