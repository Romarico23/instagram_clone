import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ADDING IMAGE TO FIREBASE STORAGE
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // CREATING LOCATION TO OUR FIREBASE STORAGE

    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // PUTTING IN UIINT8LIST FORMAT -> UPLOAD TASK LIKE A FUTURE BUT NOT FUTURE
    UploadTask uploadTask =
        ref.putData(file, SettableMetadata(contentType: 'image/jpg'));

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
