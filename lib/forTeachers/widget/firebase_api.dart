import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try{
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } catch (e) {
      return null;
    }

  }
}

class FirebaseImage {
  static UploadTask? uploadFile(String destination, File image) {
    try{
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(image);
    } catch (e) {
      return null;
    }

  }
}