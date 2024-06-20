import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/invoice_provider.dart';

class InvoiceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<InvoiceProvider>(context).invoices;

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/create'),
          ),
        ],
      ),
      body: invoices.isEmpty
          ? Center(child: Text('No invoices found.'))
          : ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return ListTile(
                  title: Text(invoice.clientName),
                  subtitle: Text(invoice.invoiceDate.toIso8601String()),
                  trailing: Text('\$${invoice.total.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: index,
                    );
                  },
                );
              },
            ),
    );
  }
}
