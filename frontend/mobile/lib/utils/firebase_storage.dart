import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageManager {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadItemImage(String itemId, File file) async {
    try {
      //TODO: test if the extension part works
      String fileExtension = file.path.split(".").last;
      Reference ref =
          storage.ref().child("images/items/$itemId.$fileExtension");
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return "";
    }
  }
}

StorageManager storageManager = StorageManager();
