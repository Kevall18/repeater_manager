import 'package:flutter/material.dart';

import '../../../commons/widgets/app_date_picker_field.dart';
import '../../../commons/widgets/app_dropdown.dart';
import '../../../commons/widgets/app_text_field.dart';
import '../models/receipt.dart';
import '../repository/receipt_repository.dart';

class ReceiptFormScreen extends StatefulWidget {
  const ReceiptFormScreen({
    super.key,
    required this.userId,
    this.initialReceipt,
  });

  final String userId;
  final Receipt? initialReceipt;

  static List<String> generateYearOptions() {
    final now = DateTime.now();
    final y = now.year;
    final years = <String>[];
    for (var i = 0; i < 6; i++) {
      final start = y - 2 + i;
      years.add('$start-${(start + 1).toString().substring(2)}');
    }
    return years.reversed.toList();
  }

  @override
  State<ReceiptFormScreen> createState() => _ReceiptFormScreenState();
}

class _ReceiptFormScreenState extends State<ReceiptFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _feeCtrl = TextEditingController();
  String _department = 'B.A.';
  int _sem = 1;
  late DateTime _date;
  String _year = _defaultAcademicYear();

  final _repo = ReceiptRepository();

  bool get isEditing => widget.initialReceipt != null;

  static String _defaultAcademicYear() {
    final now = DateTime.now();
    final y = (now.month >= 6) ? now.year : now.year - 1;
    return '${y}-${(y + 1).toString().substring(2)}';
  }

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final r = widget.initialReceipt!;
      _nameCtrl.text = r.studentName;
      _feeCtrl.text = r.fee.toString();
      _department = r.department;
      _sem = r.sem;
      _date = r.date;
      _year = r.year;
    } else {
      _date = DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (isEditing) {
      final orig = widget.initialReceipt!;
      final updated = orig.copyWith(
        studentName: _nameCtrl.text.trim(),
        sem: _sem,
        date: _date,
        fee: int.tryParse(_feeCtrl.text.trim()) ?? 0,
        // keep year/department/receiptNo unchanged to preserve numbering
      );
      await _repo.saveReceipt(orig.id, updated);
    } else {
      final receipt = Receipt(
        id: '',
        studentName: _nameCtrl.text.trim(),
        department: _department,
        sem: _sem,
        date: _date,
        fee: int.tryParse(_feeCtrl.text.trim()) ?? 0,
        year: _year,
        receiptNo: 0,
        createdBy: widget.userId,
      );

      await _repo.createWithReceiptNo(receipt);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(isEditing ? 'Edit Receipt' : 'Create Receipt'),
          actions: [
            if (isEditing)
              IconButton(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete receipt?'),
                      content: const Text(
                          'This will remove the receipt permanently.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete')),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await _repo.deleteReceipt(widget.initialReceipt!.id);
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.delete_forever),
              )
          ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextField(
                controller: _nameCtrl,
                labelText: 'Student name',
                validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              AppDropdown<String>(
                items: const ['B.A.', 'B.Com.'],
                value: _department,
                labelText: 'Department',
                onChanged: (v) => setState(() => _department = v ?? 'B.A.'),
              ),
              const SizedBox(height: 8),
              AppDropdown<int>(
                items: const [1, 2, 3, 4, 5, 6],
                value: _sem,
                labelText: 'Semester',
                onChanged: (v) => setState(() => _sem = v ?? 1),
              ),
              const SizedBox(height: 8),
              AppDatePickerField(
                value: _date,
                labelText: 'Date',
                onChanged: (d) => setState(() => _date = d ?? DateTime.now()),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _feeCtrl,
                labelText: 'Fee amount',
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n < 0) return 'Enter valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<String>(
                items: ReceiptFormScreen.generateYearOptions(),
                value: _year,
                labelText: 'Academic year',
                onChanged: (v) => setState(() => _year = v ?? _year),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Update Receipt' : 'Create Receipt'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // moved to widget as static helper
}
