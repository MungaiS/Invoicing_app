import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/invoice_provider.dart';
import '../models/invoice.dart';

class InvoiceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, invoiceProvider, child) {
          final invoices = invoiceProvider.invoices;
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return ListTile(
                title: Text(invoice.clientName),
                subtitle: Text(invoice.invoiceDate.toString()),
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: index);
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    invoiceProvider.deleteInvoice(index);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
