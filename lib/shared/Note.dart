class Note {
  int id;
  String title;
  String content;
  // ignore: non_constant_identifier_names
  int date_created;
  // ignore: non_constant_identifier_names
  int date_updated;

  Note(this.id, this.title, this.content, this.date_created, this.date_updated);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      'title': title,
      'content': content,
      'date_created': date_created,
      'date_updated': date_updated,
    };

    if (forUpdate) {
      data['id'] = id;
    }

    return data;
  }
}
