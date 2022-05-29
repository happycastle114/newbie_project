import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// SPARCS_AP 사용시 업로드 안됨
Future<String> UploadFile(File file) async {
  final firebaseStorage = FirebaseStorage.instance
      .ref()
      .child('post')
      .child('${DateTime.now().millisecondsSinceEpoch}.m4a');

  final uploadTask = firebaseStorage.putFile(file);

  await uploadTask.whenComplete(() => print("Upload Successful"));

  final downloadUrl = await firebaseStorage.getDownloadURL();

  print(downloadUrl);

  return downloadUrl;
}
