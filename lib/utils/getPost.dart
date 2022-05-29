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
    return _db.collection('user').doc('post').get().then((snapshot) {
      List<Post> diaries = [];
      for (Map<String, dynamic> snap in snapshot.data()?['diaries']) {
        print("POST 추가됨");
        diaries.add(Post.fromMap(snap));
      }

      return diaries;
    });
  }

  Future<bool> add(Post post) {
    return _instance.get().then((value) {
      if (value.where((element) => element.id == post.id).isNotEmpty) {
        return false;
      }
      value.add(post);
      _db.collection('user').doc("post").set({
        'diaries': value.map((e) => e.toMap()).toList(),
      });
      return true;
    });
  }

  Future<void> remove(Post post) {
    return _instance.get().then((value) {
      value.removeWhere((p) => post.id == p.id);
      _db.collection('user').doc("post").set({
        'diaries': value.map((e) => e.toMap()).toList(),
      });
    });
  }
}
