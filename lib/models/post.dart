import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newbie_project/models/diary.dart';

class Post {
  final String writer;
  final String name;
  final DateTime date;
  final String fileName;
  final String id;

  Post(
      {required this.writer,
      required this.id,
      required this.name,
      required this.date,
      required this.fileName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'fileName': fileName,
      'writer': writer,
    };
  }

  Post.fromMap(Map<String, dynamic>? map)
      : writer = map?['writer'],
        id = map?['id'],
        name = map?['name'],
        date = DateTime.parse(map?['date'].toDate().toString() as String),
        fileName = map?['fileName'];

  Post.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromMap(snapshot.data());

  Post.fromDiary(String userId, Diary diary)
      : writer = userId,
        id = diary.id,
        name = diary.name,
        date = diary.date,
        fileName = diary.fileName;
}
