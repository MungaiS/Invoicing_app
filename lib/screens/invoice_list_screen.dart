import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/invoice_provider.dart';
import '../models/invoice.dart';

class InvoiceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, invoiceProvider, child) {
          final invoices = invoiceProvider.invoices;
          if (invoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 80,
                    color: Colors.blue.shade900,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No current invoices',
                    style: TextStyle(fontSize: 18, color: Colors.blue.shade900),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(invoice.clientName),
                  subtitle: Text(invoice.invoiceDate.toString()),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: index);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      invoiceProvider.deleteInvoice(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

