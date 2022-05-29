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
    print(value.map((d) => d.toMap().toString()));
    print(diary.toMap().toString());
    value.add(diary);
    List<Map<String, dynamic>> map_diaries = [];

    value.forEach((Diary diary) {
      map_diaries.add(diary.toMap());
    });
    print(map_diaries.toString());
    FirebaseFirestore.instance.collection('user').doc(userId).set({
      'diaries': map_diaries,
    });
  });
}

Future<void> removeDiary(String userId, Diary diary) {
  return getDiary(userId).then((value) {
    value.remove(diary);
    List<Map<String, dynamic>> map_diaries = [];
    value.map((diary) => map_diaries.add(diary.toMap()));
    FirebaseFirestore.instance.collection('user').doc(userId).set({
      'diaries': map_diaries,
    });
  });
}
