// import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String id;
  final String name;
  final DateTime date;
  final String fileName;

  Diary(
      {required this.id,
      required this.name,
      required this.date,
      required this.fileName});
}
