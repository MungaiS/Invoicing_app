import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';
import '../services/pdf_service.dart';
import 'dart:io';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  InvoiceDetailScreen({required this.invoice});

  Future<void> _exportToPDF(BuildContext context) async {
    try {
      final pdf = await PDFService.generateInvoicePDF(invoice);
      final bytes = await pdf.save();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/invoice.pdf');
      await file.writeAsBytes(bytes);

      OpenFile.open(file.path);
    } catch (e) {
      _showErrorDialog(context, 'Error exporting PDF: $e');
    }
  }

  Future<void> _sharePDF(BuildContext context) async {
    try {
      final pdf = await PDFService.generateInvoicePDF(invoice);
      final bytes = await pdf.save();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/invoice.pdf');
      await file.writeAsBytes(bytes);

      Share.shareFiles([file.path], text: 'Check out this invoice!');
    } catch (e) {
      _showErrorDialog(context, 'Error sharing PDF: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportToPDF(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePDF(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit',
                arguments: Provider.of<InvoiceProvider>(context, listen: false).invoices.indexOf(invoice),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${invoice.clientName}', style: const TextStyle(fontSize: 20)),
            Text('Address: ${invoice.clientAddress}', style: const TextStyle(fontSize: 20)),
            Text('Email: ${invoice.clientEmail}', style: const TextStyle(fontSize: 20)),
            Text('Date: ${invoice.invoiceDate.toLocal()}'.split(' ')[0], style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Items:', style: TextStyle(fontSize: 20)),
            DataTable(
              columns: const [
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Price')),
              ],
              rows: invoice.items
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text(item.description)),
                        DataCell(Text(item.quantity.toString())),
                        DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('Tax Rate: ${invoice.taxRate}%', style: const TextStyle(fontSize: 20)),
            Text('Total: \$${invoice.calculateTotal().toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}


