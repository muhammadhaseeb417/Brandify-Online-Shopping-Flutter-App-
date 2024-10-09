import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageServics {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageServics();

  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    try {
      Reference pfpRef = _firebaseStorage
          .ref("/users/pfp")
          .child("$uid${p.extension(file.path)}");

      UploadTask uploadTask = pfpRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
