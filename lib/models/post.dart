import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String writer;
  final String name;
  final DateTime date;
  final String fileName;
  final String id;

  Post(
      {required this.postId,
      required this.writer,
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
      'postId': postId,
      'writer': writer,
    };
  }

  Post.fromMap(Map<String, dynamic>? map)
      : postId = map?['postId'],
        writer = map?['writer'],
        id = map?['id'],
        name = map?['name'],
        date = DateTime.parse(map?['date']),
        fileName = map?['fileName'];

  Post.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromMap(snapshot.data());
}
