import 'package:flutter/material.dart';
import '../models/invoice.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  InvoiceDetailScreen({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Name: ${invoice.clientName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Text(
              'Items:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10),
            ...invoice.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${item.description} - Quantity: ${item.quantity}, Price: ${item.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              'Tax Rate: ${invoice.taxRate.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Text(
              'Total: ${invoice.calculateTotal().toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

