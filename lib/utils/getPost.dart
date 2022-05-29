import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newbie_project/models/post.dart';

// 게시물 가져오기

class PostDatabase {
  PostDatabase._privateConstructor();

  static final PostDatabase _instance = PostDatabase._privateConstructor();

  factory PostDatabase() {
    return _instance;
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Post>> get() {
    return _db
        .collection('users')
        .doc('post')
        .collection('diaries')
        .get()
        .then((snapshot) {
      List<Post> diaries = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> snap in snapshot.docs) {
        diaries.add(Post.fromSnapshot(snap));
      }

      return diaries;
    });
  }

  Future<void> add(Post diary) {
    return _instance.get().then((value) {
      value.add(diary);
      _db.doc("post").set({
        'diaries': value,
      });
    });
  }

  Future<void> remove(Post diary) {
    return _instance.get().then((value) {
      value.remove(diary);
      _db.doc("post").set({
        'diaries': value,
      });
    });
  }
}
