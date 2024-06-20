import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final int invoiceIndex;

  InvoiceDetailScreen({required this.invoiceIndex});

  @override
  Widget build(BuildContext context) {
    final invoice = Provider.of<InvoiceProvider>(context).invoices[invoiceIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit',
                arguments: invoiceIndex,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final pdf = pw.Document();
              pdf.addPage(
                pw.Page(
                  build: (pw.Context context) {
                    return pw.Padding(
                      padding: pw.EdgeInsets.all(16),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Invoice Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 20),
                          pw.Text('Client: ${invoice.clientName}', style: pw.TextStyle(fontSize: 18)),
                          pw.Text('Date: ${invoice.invoiceDate.toIso8601String()}', style: pw.TextStyle(fontSize: 18)),
                          pw.SizedBox(height: 20),
                          pw.Text('Items:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                          pw.Table.fromTextArray(
                            context: context,
                            data: <List<String>>[
                              <String>['Description', 'Quantity', 'Price'],
                              ...invoice.items.map((item) => [item.description, item.quantity.toString(), '\$${item.price}']),
                            ],
                          ),
                          pw.SizedBox(height: 20),
                          pw.Text('Tax Rate: ${invoice.taxRate}%', style: pw.TextStyle(fontSize: 18)),
                          pw.Text('Total: \$${invoice.total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              );
              await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${invoice.clientName}', style: TextStyle(fontSize: 18)),
            Text('Date: ${invoice.invoiceDate.toIso8601String()}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Items:', style: TextStyle(fontSize: 18)),
            ...invoice.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${item.description} - ${item.quantity} x \$${item.price}',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Text('Tax Rate: ${invoice.taxRate}%', style: TextStyle(fontSize: 18)),
            Text('Total: \$${invoice.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
