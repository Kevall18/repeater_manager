import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/base_firestore_repository.dart';
import '../models/app_user.dart';

class UserRepository extends BaseFirestoreRepository<AppUser> {
  UserRepository() : super('users');

  @override
  AppUser fromMap(Map<String, dynamic> json, String id) {
    return AppUser.fromMap(json, id);
  }

  @override
  Map<String, dynamic> toMap(AppUser value) {
    return value.toMap();
  }

  Future<void> upsertUser(AppUser user) async {
    await collection.doc(user.uid).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<AppUser?> fetchUser(String uid) async {
    return fetchById(uid);
  }
}
