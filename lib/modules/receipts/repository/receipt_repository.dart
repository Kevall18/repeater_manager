import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/base_firestore_repository.dart';
import '../models/receipt.dart';

class ReceiptRepository extends BaseFirestoreRepository<Receipt> {
  ReceiptRepository() : super('receipts');

  @override
  Receipt fromMap(Map<String, dynamic> json, String id) {
    return Receipt.fromMap(json, id);
  }

  @override
  Map<String, dynamic> toMap(Receipt value) => value.toMap();

  // Generate receipt number per year+department using a counter document
  Future<int> _nextReceiptNo(
      {required String year, required String department}) async {
    final counterId = '${year}_$department';
    final counterRef = FirebaseFirestore.instance
        .collection('receipt_counters')
        .doc(counterId);

    return FirebaseFirestore.instance.runTransaction<int>((tx) async {
      final snapshot = await tx.get(counterRef);
      int current = 0;
      if (snapshot.exists && snapshot.data() != null) {
        current = (snapshot.data()!['lastReceiptNo'] as int?) ?? 0;
      }
      final next = current + 1;
      tx.set(counterRef, {'lastReceiptNo': next}, SetOptions(merge: true));
      return next;
    });
  }

  // Create and auto-assign receiptNo
  Future<String> createWithReceiptNo(Receipt receipt) async {
    final next = await _nextReceiptNo(
        year: receipt.year, department: receipt.department);
    final map = receipt.copyWith(receiptNo: next).toMap();
    final doc = await collection.add(map);
    return doc.id;
  }

  Future<List<Receipt>> fetchByFilters({
    required String userId,
    String? year,
    String? department,
    int? sem,
  }) async {
    return fetchAll(queryBuilder: (q) {
      Query<Map<String, dynamic>> ret = q.where('createdBy', isEqualTo: userId);
      if (year != null && year.isNotEmpty)
        ret = ret.where('year', isEqualTo: year);
      if (department != null && department.isNotEmpty)
        ret = ret.where('department', isEqualTo: department);
      if (sem != null) ret = ret.where('sem', isEqualTo: sem);
      ret = ret.orderBy('date', descending: true);
      return ret;
    });
  }

  Stream<List<Receipt>> watchByFilters({
    required String userId,
    String? year,
    String? department,
    int? sem,
  }) {
    return watchAll(queryBuilder: (q) {
      Query<Map<String, dynamic>> ret = q.where('createdBy', isEqualTo: userId);
      if (year != null && year.isNotEmpty)
        ret = ret.where('year', isEqualTo: year);
      if (department != null && department.isNotEmpty)
        ret = ret.where('department', isEqualTo: department);
      if (sem != null) ret = ret.where('sem', isEqualTo: sem);
      ret = ret.orderBy('date', descending: true);
      return ret;
    });
  }

  Future<List<Receipt>> fetchDay({
    required String userId,
    required DateTime day,
    String? department,
  }) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return fetchAll(queryBuilder: (q) {
      Query<Map<String, dynamic>> ret = q
          .where('createdBy', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end));
      if (department != null && department.isNotEmpty)
        ret = ret.where('department', isEqualTo: department);
      ret = ret.orderBy('date', descending: false);
      return ret;
    });
  }

  Stream<List<Receipt>> watchDay({
    required String userId,
    required DateTime day,
    String? department,
  }) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return watchAll(queryBuilder: (q) {
      Query<Map<String, dynamic>> ret = q
          .where('createdBy', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end));
      if (department != null && department.isNotEmpty)
        ret = ret.where('department', isEqualTo: department);
      ret = ret.orderBy('date', descending: false);
      return ret;
    });
  }

  Future<void> saveReceipt(String id, Receipt receipt) async {
    await save(id, receipt);
  }

  Future<void> deleteReceipt(String id) async {
    await remove(id);
  }
}
