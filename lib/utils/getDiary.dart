import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newbie_project/models/diary.dart';

// CRUD
Future<List<Diary>> getDiary(String userId) {
  return Firebase.initializeApp().then((_) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('diaries')
        .get()
        .then((snapshot) {
      List<Diary> diaries = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> snap in snapshot.docs) {
        diaries.add(Diary.fromSnapshot(snap));
      }

      return diaries;
    });
  });
}

Future<void> addDiary(String userId, Diary diary) {
  return getDiary(userId).then((value) {
    value.add(diary);
    FirebaseFirestore.instance.doc(userId).set({
      'diaries': value,
    });
  });
}

Future<void> removeDiary(String userId, Diary diary) {
  return getDiary(userId).then((value) {
    value.remove(diary);
    FirebaseFirestore.instance.doc(userId).set({
      'diaries': value,
    });
  });
}
