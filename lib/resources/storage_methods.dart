import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hippocampus/utils/constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'firebase_methods.dart';
import 'package:path_provider/path_provider.dart';

class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<String> uploadProfileImage(
      String url, File imageFile, String username) async {
    String photoId = username;
    File? image = await compressImage(photoId, imageFile);
    String downloadUrl = '';

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'profile_(.*).jpg');
      photoId = exp.firstMatch(url)![1]!;
    }
    UploadTask uploadTask = storageRef
        .child('images/users/$username/profile_$photoId.jpg')
        .putFile(image!);
    await uploadTask.then((res) async {
      downloadUrl = await res.ref.getDownloadURL();
    });

    return downloadUrl;
  }

  Future<String> uploadImageToStorage(File image, String username) async {
    try {
      String url = '';
      UploadTask uploadTask = storageRef
          .child(
              'images/notes/$username/hippocampus_note_${DateTime.now().microsecondsSinceEpoch}.jpg')
          .putFile(image);
      await uploadTask.then((res) async {
        url = await res.ref.getDownloadURL();
      });
      return url;
    } catch (e) {
      return '';
    }
  }

  Future<File?> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File? compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }
}
