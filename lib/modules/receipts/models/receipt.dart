import 'package:cloud_firestore/cloud_firestore.dart';

class Receipt {
  Receipt({
    required this.id,
    required this.studentName,
    required this.department,
    required this.sem,
    required this.date,
    required this.fee,
    required this.year,
    required this.receiptNo,
    required this.createdBy,
  });

  final String id;
  final String studentName;
  final String department; // "B.A." or "B.Com."
  final int sem; // 1..6
  final DateTime date;
  final int fee;
  final String year; // e.g. "2026-27"
  final int receiptNo; // per year+department counter
  final String createdBy; // uid of user who created

  factory Receipt.fromMap(Map<String, dynamic> map, String id) {
    final dateVal = map['date'];
    return Receipt(
      id: id,
      studentName: (map['studentName'] as String?) ?? '',
      department: (map['department'] as String?) ?? '',
      sem: (map['sem'] as int?) ?? 1,
      date: dateVal is Timestamp
          ? dateVal.toDate()
          : DateTime.parse(dateVal as String),
      fee: (map['fee'] as int?) ?? 0,
      year: (map['year'] as String?) ?? '',
      receiptNo: (map['receiptNo'] as int?) ?? 0,
      createdBy: (map['createdBy'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentName': studentName.trim(),
      'department': department,
      'sem': sem,
      'date': Timestamp.fromDate(date),
      'fee': fee,
      'year': year,
      'receiptNo': receiptNo,
      'createdBy': createdBy,
    };
  }

  Receipt copyWith({
    String? studentName,
    String? department,
    int? sem,
    DateTime? date,
    int? fee,
    String? year,
    int? receiptNo,
    String? createdBy,
  }) {
    return Receipt(
      id: id,
      studentName: studentName ?? this.studentName,
      department: department ?? this.department,
      sem: sem ?? this.sem,
      date: date ?? this.date,
      fee: fee ?? this.fee,
      year: year ?? this.year,
      receiptNo: receiptNo ?? this.receiptNo,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
