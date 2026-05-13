import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/receipt.dart';

class ReceiptPrintScreen extends StatelessWidget {
  const ReceiptPrintScreen({super.key, required this.receipt});

  final Receipt receipt;

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final document = pw.Document();

    document.addPage(
      pw.Page(
        pageFormat: format.copyWith(
          marginBottom: 18,
          marginLeft: 18,
          marginRight: 18,
          marginTop: 18,
        ),
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1.2),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  'MUNICIPAL COLLEGE UPLETA',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Repeater Exam Fee Receipt',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 14),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      _pdfRow('Receipt No.', 'R#${receipt.receiptNo}'),
                      _pdfRow('Student Name', receipt.studentName),
                      _pdfRow('Department', receipt.department),
                      _pdfRow('Semester', receipt.sem.toString()),
                      _pdfRow('Academic Year', receipt.year),
                      _pdfRow('Date', _formatDate(receipt.date)),
                      _pdfRow('Fee Amount', 'Rs. ${receipt.fee}'),
                      _pdfRow('Created By', receipt.createdBy),
                    ],
                  ),
                ),
                pw.SizedBox(height: 14),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Authorized Signature'),
                    pw.Text('Student Copy'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return document.save();
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 110,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(':  $value'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Print Receipt')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'MUNICIPAL COLLEGE UPLETA',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Repeater Exam Fee Receipt',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _detailRow('Receipt No.', 'R#${receipt.receiptNo}'),
                        _detailRow('Student Name', receipt.studentName),
                        _detailRow('Department', receipt.department),
                        _detailRow('Semester', receipt.sem.toString()),
                        _detailRow('Academic Year', receipt.year),
                        _detailRow(
                          'Date',
                          MaterialLocalizations.of(context)
                              .formatShortDate(receipt.date),
                        ),
                        _detailRow('Fee Amount', 'Rs. ${receipt.fee}'),
                        _detailRow('Created By', receipt.createdBy),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Authorized Signature'),
                      Text('Student Copy'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: _generatePdf,
              );
            },
            icon: const Icon(Icons.print),
            label: const Text('Print Receipt'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(':  $value')),
        ],
      ),
    );
  }
}
