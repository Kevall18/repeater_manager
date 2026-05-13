import 'package:flutter/material.dart';

import '../../../commons/widgets/app_dropdown.dart';
import '../../../commons/widgets/app_date_picker_field.dart';
import '../models/receipt.dart';
import '../repository/receipt_repository.dart';
import 'receipt_print_screen.dart';

class DayStatementScreen extends StatefulWidget {
  const DayStatementScreen({super.key, required this.userId});

  final String userId;

  @override
  State<DayStatementScreen> createState() => _DayStatementScreenState();
}

class _DayStatementScreenState extends State<DayStatementScreen> {
  final _repo = ReceiptRepository();
  DateTime _day = DateTime.now();
  String? _department;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day Statement')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppDatePickerField(
                    value: _day,
                    labelText: 'Date',
                    onChanged: (d) =>
                        setState(() => _day = d ?? DateTime.now()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppDropdown<String>(
                    items: const ['', 'B.A.', 'B.Com.'],
                    value: _department ?? '',
                    labelText: 'Department',
                    onChanged: (v) =>
                        setState(() => _department = v == '' ? null : v),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Receipt>>(
                stream: _repo.watchDay(
                    userId: widget.userId, day: _day, department: _department),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Unable to load day statement.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final list = snapshot.data ?? <Receipt>[];
                  if (list.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No receipts found for this date and filter.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

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
                              subtitle: Text(
                                  '${r.department} • Sem ${r.sem} • ${MaterialLocalizations.of(context).formatShortDate(r.date)}'),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('₹ ${r.fee}'),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    constraints: const BoxConstraints(
                                      minWidth: 28,
                                      minHeight: 28,
                                    ),
                                    iconSize: 18,
                                    tooltip: 'Print receipt',
                                    icon: const Icon(Icons.print),
                                    onPressed: () async {
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) => ReceiptPrintScreen(
                                          receipt: r,
                                        ),
                                      ));
                                    },
                                  ),
                                ],
                              ),
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
                            Text('Total receipts: ${list.length}'),
                            Text('Sum: ₹ $total'),
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
