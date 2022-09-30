import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:uuid/uuid.dart';

class FireStoreMethods {
  FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> uploadStory({
    required List imageList,
    required String userid,
    required String name,
  }) async {
    String uuid = const Uuid().v1().toString();
    List<String> storyUrl = [];
    File file;

    if (imageList.isNotEmpty) {
      for (int i = 0; i < imageList.length; i++) {
        Reference ref =
            storage.ref().child('Story/' + uuid + '-' + i.toString() + '.jpg');
        file = File(imageList[i].path);
        await ref.putFile(file);
        storyUrl.add(await ref.getDownloadURL());
      }

      await _firestore.collection('story').doc(uuid).set({
        'storyUrl': storyUrl,
        'storyId': uuid,
        'storyBy': name,
        'userid': userid,
        'storyTime': DateTime.now(),
      });

      await _firestore
          .collection("users")
          .doc(userid)
          .collection("story")
          .doc(uuid)
          .set({
        'storyUrl': storyUrl,
        'storyId': uuid,
        'storyTime': DateTime.now(),
      });
    }
  }

  Future<void> deleteStory({
    required String storyid,
  }) async {
    await _firestore.collection("story").doc(storyid).delete();
  }

  Future<void> deleteStoryfromUser({
    required String storyid,
    required String userid,
  }) async {
    await _firestore.collection("story").doc(storyid).delete();
    await _firestore
        .collection("users")
        .doc(userid)
        .collection("story")
        .doc(storyid)
        .delete();
  }
}
