import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/invoice.dart';

class PDFService {
  static Future<pw.Document> generateInvoicePDF(Invoice invoice) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
              pw.Text('Client: ${invoice.clientName}'),
              pw.Text('Date: ${invoice.invoiceDate.toLocal()}'.split(' ')[0]),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Description', 'Quantity', 'Price'],
                  ...invoice.items.map((item) => [item.description, item.quantity.toString(), item.price.toString()]),
                ],
                cellPadding: const pw.EdgeInsets.all(5),
                cellAlignment: pw.Alignment.centerLeft,
              ),
              pw.SizedBox(height: 20),
              pw.Text('Tax Rate: ${invoice.taxRate}%'),
              pw.Text('Total: \$${invoice.calculateTotal().toStringAsFixed(2)}'),
            ],
          );
        },
      ),
    );
    return pdf;
  }
}


