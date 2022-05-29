import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String id;
  final String name;
  final DateTime date;
  final String fileName;

  // reference 추가해야 할 듯

  Diary(
      {required this.id,
      required this.name,
      required this.date,
      required this.fileName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'fileName': fileName,
    };
  }

  Diary.fromMap(Map<String, dynamic>? map)
      : id = map?['id'],
        name = map?['name'],
        date = DateTime.parse(map?['date']),
        fileName = map?['fileName'];

  Diary.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromMap(snapshot.data());
}
