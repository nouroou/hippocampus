import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String username;
  String email;
  String profileUrl;
  String phone;
  Timestamp? createdAt;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.profileUrl,
    required this.phone,
    required this.createdAt,
  });

  Map toMap(User user) {
    var data = Map<dynamic, dynamic>();
    data['uid'] = user.id;
    data['username'] = user.username;
    data['name'] = user.name;
    data['email'] = user.email;
    data['profileUrl'] = user.profileUrl;
    data['phone'] = user.phone;
    data['createdAt'] = user.createdAt;

    return data;
  }

  User.fromMap(Map<String, dynamic> mapData)
      : id = mapData['uid'],
        username = mapData['username'],
        name = mapData['name'] ?? '',
        email = mapData['email'] ?? '',
        profileUrl = mapData['profileUrl'] ?? '',
        phone = mapData['phone'] ?? '',
        createdAt = mapData['createdAt'];
  Map<String, dynamic> toData(User user) {
    return {
      'uid': user.id,
      'username': user.username,
      'name': user.name,
      'email': user.email,
      'profileUrl': user.profileUrl,
      'phone': user.phone,
      'createdAt': user.createdAt,
    };
  }

  factory User.fromData(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      username: doc['username'],
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      profileUrl: doc['profileUrl'] ?? '',
      phone: doc['phone'] ?? '',
      createdAt: doc['createdAt'],
    );
  }
}
