import 'package:flutter/material.dart';

import '../../../commons/widgets/app_dropdown.dart';
import '../../../commons/widgets/app_text_field.dart';
import '../models/receipt.dart';
import '../repository/receipt_repository.dart';
import 'receipt_form_screen.dart';
import 'receipt_print_screen.dart';

class DepartmentStatementScreen extends StatefulWidget {
  const DepartmentStatementScreen({super.key, required this.userId});

  final String userId;

  @override
  State<DepartmentStatementScreen> createState() =>
      _DepartmentStatementScreenState();
}

class _DepartmentStatementScreenState extends State<DepartmentStatementScreen> {
  final _repo = ReceiptRepository();
  final _searchCtrl = TextEditingController();
  String? _department;
  int? _sem;
  String? _year = ReceiptFormScreen.generateYearOptions().first;

  Future<List<Receipt>> _load() => _repo.fetchByFilters(
      userId: widget.userId, 
      year: _year, 
      department: _department, 
      sem: _sem);

  List<Receipt> _filterByName(List<Receipt> list, String query) {
    if (query.trim().isEmpty) return list;
    final lowerQuery = query.toLowerCase().trim();
    return list
        .where((r) =>
            r.studentName.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Department Statement')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            AppTextField(
              controller: _searchCtrl,
              labelText: 'Search by student name',
              prefixIcon: const Icon(Icons.search),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppDropdown<String>(
                    items: const ['', 'B.A.', 'B.Com.'],
                    value: _department ?? '',
                    labelText: 'Department',
                    onChanged: (v) =>
                        setState(() => _department = (v == '') ? null : v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppDropdown<int>(
                    items: const [0, 1, 2, 3, 4, 5, 6],
                    value: _sem ?? 0,
                    labelText: 'Semester',
                    onChanged: (v) =>
                        setState(() => _sem = (v == 0) ? null : v),
                    itemLabelBuilder: (i) => i == 0 ? 'Any' : i.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppDropdown<String>(
                    items: ReceiptFormScreen.generateYearOptions(),
                    value: _year,
                    labelText: 'Year',
                    onChanged: (v) => setState(() => _year = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Receipt>>(
                future: _load(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  final allList = snapshot.data ?? <Receipt>[];
                  final list = _filterByName(allList, _searchCtrl.text);
                  var total = 0;
                  for (final r in list) total += r.fee;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final r = list[index];
                            return ListTile(
                              title: Text(r.studentName),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Rs. ${r.fee}'),
                                ],
                              ),
                              onTap: () async {
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (_) => ReceiptFormScreen(
                                      userId: widget.userId, initialReceipt: r),
                                ));
                                setState(() {});
                              },
                              onLongPress: () async {
                                final action =
                                    await showModalBottomSheet<String>(
                                  context: context,
                                  builder: (_) => SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit),
                                          title: const Text('Edit'),
                                          onTap: () =>
                                              Navigator.pop(context, 'edit'),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.print),
                                          title: const Text('Print'),
                                          onTap: () =>
                                              Navigator.pop(context, 'print'),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text('Delete'),
                                          onTap: () =>
                                              Navigator.pop(context, 'delete'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                if (action == 'edit') {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (_) => ReceiptFormScreen(
                                        userId: widget.userId,
                                        initialReceipt: r),
                                  ));
                                  setState(() {});
                                } else if (action == 'print') {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (_) => ReceiptPrintScreen(
                                      receipt: r,
                                    ),
                                  ));
                                } else if (action == 'delete') {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete receipt?'),
                                      content: const Text(
                                          'This will remove the receipt permanently.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Delete')),
                                      ],
                                    ),
                                  );
                                  if (ok == true) {
                                    await _repo.deleteReceipt(r.id);
                                    setState(() {});
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Repeaters: ${list.length}'),
                            Text('Sum: Rs. $total'),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
