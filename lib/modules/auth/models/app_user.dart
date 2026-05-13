import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
    this.password,
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
  final String? password;
    final createdAt = map['createdAt'];
    final updatedAt = map['updatedAt'];

    return AppUser(
      uid: id,
      email: (map['email'] as String? ?? '').trim(),
      name: (map['name'] as String? ?? '').trim(),
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.parse(createdAt as String),
      updatedAt: updatedAt is Timestamp
          ? updatedAt.toDate()
          : DateTime.parse(updatedAt as String),
        password: (map['password'] as String?),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    'email': email.trim(),
    'name': name.trim(),
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    if (password != null) 'password': password,
    };
  }

  AppUser copyWith({
    String? email,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? password,
    }) {
    return AppUser(
      uid: uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      password: password ?? this.password,
    );
  }
}
