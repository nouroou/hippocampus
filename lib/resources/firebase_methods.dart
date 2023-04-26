import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:hippocampus/models/user.dart';
import 'package:hippocampus/utils/constants.dart';

class FirebaseMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User user;

  Future addPhoneDataToDb(auth.User currentUser, String username) async {
    user = User(
      id: currentUser.uid,
      email: '',
      name: currentUser.displayName!,
      profileUrl: currentUser.photoURL!,
      username: username,
      phone: currentUser.phoneNumber!,
      createdAt: Timestamp.now(),
    );
    firestore.collection("users").doc(currentUser.uid).set(user.toData(user));
  }

  Future addDataToDb(auth.User currentUser, String username) async {
    try {
      user = User(
        id: currentUser.uid,
        email: currentUser.email!,
        name: currentUser.displayName!,
        profileUrl: currentUser.photoURL!,
        username: username,
        phone: '',
        createdAt: Timestamp.now(),
      );
      await firestore
          .collection("users")
          .doc(currentUser.uid)
          .set(user.toData(user));
      return user;
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  Future addEmailDataToDb(User currentUser, String username) async {
    try {
      user = User(
          id: currentUser.id,
          email: currentUser.email,
          name: '',
          profileUrl: '',
          username: username,
          phone: '',
          createdAt: Timestamp.now());
      await firestore.collection("users").doc(user.id).set(user.toData(user));
    } catch (e) {
      return e;
    }
  }

  Future pinChat(String currentUserId, String userId) async {
    return await chatsRef
        .doc(currentUserId)
        .collection('userChats')
        .doc(userId)
        .update({
      'pinned': true,
    });
  }

  Future unpinChat(String currentUserId, String userId) async {
    return await chatsRef
        .doc(currentUserId)
        .collection('userChats')
        .doc(userId)
        .update({
      'pinned': false,
    });
  }

  Future lockChat(String currentUserId, String userId) async {
    return await chatsRef
        .doc(currentUserId)
        .collection('userChats')
        .doc(userId)
        .update({
      'locked': true,
    });
  }

  Future unlockChat(String currentUserId, String userId) async {
    return await chatsRef
        .doc(currentUserId)
        .collection('userChats')
        .doc(userId)
        .update({
      'locked': false,
    });
  }

  Future archiveChat(String currentUserId, String userId) async {
    return await chatsRef
        .doc(currentUserId)
        .collection('userChats')
        .doc(userId)
        .update({
      'archived': true,
    });
  }

  Future unarchiveChat(String currentUserId, String userId) async {
    return await chatsRef
        .doc(currentUserId)
        .collection('userChats')
        .doc(userId)
        .update({
      'archived': false,
    });
  }

  Future<void> updateUser(User user) async {
    usersRef.doc(user.id).update({
      'name': user.name,
      'username': user.username,
      'profileUrl': user.profileUrl,
    });
  }

  Future<void> updateEmail(User user) async {
    usersRef.doc(user.id).update({
      'email': user.email,
    });
  }

  Future<void> updatePhone(User user) async {
    usersRef.doc(user.id).update({
      'phone': user.phone,
    });
  }

  Future<QuerySnapshot> searchUser(String username) {
    Future<QuerySnapshot> users =
        usersRef.where('username', isGreaterThanOrEqualTo: username).get();
    return users;
  }
}
