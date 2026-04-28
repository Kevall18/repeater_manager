import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseFirestoreRepository<T> {
  BaseFirestoreRepository(this.collectionPath)
      : collection = FirebaseFirestore.instance.collection(collectionPath);

  final String collectionPath;
  final CollectionReference<Map<String, dynamic>> collection;

  T fromMap(Map<String, dynamic> json, String id);

  Map<String, dynamic> toMap(T value);

  Future<List<T>> fetchAll({
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
  }) async {
    final query = queryBuilder == null ? collection : queryBuilder(collection);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  Stream<List<T>> watchAll({
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
  }) {
    final query = queryBuilder == null ? collection : queryBuilder(collection);
    return query.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList(),
        );
  }

  Future<T?> fetchById(String id) async {
    final snapshot = await collection.doc(id).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return fromMap(snapshot.data()!, snapshot.id);
  }

  Stream<T?> watchById(String id) {
    return collection.doc(id).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) {
        return null;
      }

      return fromMap(data, snapshot.id);
    });
  }

  Future<String> create(T value) async {
    final doc = await collection.add(toMap(value));
    return doc.id;
  }

  Future<void> save(
    String id,
    T value, {
    bool merge = true,
  }) async {
    await collection.doc(id).set(
          toMap(value),
          SetOptions(merge: merge),
        );
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await collection.doc(id).update(data);
  }

  Future<void> remove(String id) async {
    await collection.doc(id).delete();
  }
}
