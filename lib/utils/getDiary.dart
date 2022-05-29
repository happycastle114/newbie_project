import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newbie_project/models/diary.dart';

// CRUD
Future<List<Diary>> getDiary(String userId) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('user').get();

  if (!querySnapshot.docs.map((doc) => doc.id).toList().contains(userId)) {
    await FirebaseFirestore.instance.collection('user').doc(userId).set({});
  }

  return FirebaseFirestore.instance
      .collection('user')
      .doc(userId)
      .get()
      .then((snapshot) {
    List<Diary> diaries = [];
    for (Map<String, dynamic> diary in snapshot.data()?['diaries']) {
      print("다이어리를 하나 가져옴!");
      diaries.add(Diary.fromMap(diary));
    }

    return diaries;
  });
}

Future<void> addDiary(String userId, Diary diary) {
  return getDiary(userId).then((value) {
    value.add(diary);
    FirebaseFirestore.instance.collection('user').doc(userId).set({
      'diaries': value.map((Diary diary) => diary.toMap()).toList(),
    });
  });
}

Future<void> removeDiary(String userId, Diary diary) {
  return getDiary(userId).then((value) {
    value.remove(diary);
    FirebaseFirestore.instance.collection('user').doc(userId).set({
      'diaries': value.map((Diary diary) => diary.toMap()).toList(),
    });
  });
}
