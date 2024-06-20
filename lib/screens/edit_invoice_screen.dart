import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class EditInvoiceScreen extends StatefulWidget {
  final int invoiceIndex;

  EditInvoiceScreen({required this.invoiceIndex});

  @override
  _EditInvoiceScreenState createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late Invoice invoice;

  @override
  void initState() {
    super.initState();
    invoice = Provider.of<InvoiceProvider>(context, listen: false).invoices[widget.invoiceIndex];
  }

  @override
  Widget build(BuildContext context) {
    final _clientNameController = TextEditingController(text: invoice.clientName);
    final _itemDescriptionController = TextEditingController();
    final _itemQuantityController = TextEditingController();
    final _itemPriceController = TextEditingController();
    final _taxRateController = TextEditingController(text: invoice.taxRate.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(labelText: 'Client Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the client name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemDescriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
              ),
              TextFormField(
                controller: _itemQuantityController,
                decoration: InputDecoration(labelText: 'Item Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _itemPriceController,
                decoration: InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _taxRateController,
                decoration: InputDecoration(labelText: 'Tax Rate (%)'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedInvoice = Invoice(
                      clientName: _clientNameController.text,
                      invoiceDate: invoice.invoiceDate,
                      items: invoice.items, // You can add logic to update items
                      taxRate: double.parse(_taxRateController.text),
                    );
                    Provider.of<InvoiceProvider>(context, listen: false).updateInvoice(updatedInvoice);
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
