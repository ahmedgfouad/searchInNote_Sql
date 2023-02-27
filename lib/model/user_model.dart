class NoteModel {
  int? id;
 final String title;
 final String note;

  NoteModel({
    this.id,
    required this.title,
    required this.note,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
    };
  }
}
