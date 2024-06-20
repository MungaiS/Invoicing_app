import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class CreateInvoiceScreen extends StatefulWidget {
  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _taxRateController = TextEditingController();

  final List<InvoiceItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invoice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
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
              SizedBox(height: 20),
              Text('Invoice Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
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
              ElevatedButton(
                onPressed: () {
                  if (_itemDescriptionController.text.isNotEmpty &&
                      _itemQuantityController.text.isNotEmpty &&
                      _itemPriceController.text.isNotEmpty) {
                    setState(() {
                      _items.add(InvoiceItem(
                        description: _itemDescriptionController.text,
                        quantity: int.parse(_itemQuantityController.text),
                        price: double.parse(_itemPriceController.text),
                      ));
                    });
                    _itemDescriptionController.clear();
                    _itemQuantityController.clear();
                    _itemPriceController.clear();
                  }
                },
                child: Text('Add Item'),
              ),
              SizedBox(height: 20),
              Text('Tax Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                controller: _taxRateController,
                decoration: InputDecoration(labelText: 'Tax Rate (%)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newInvoice = Invoice(
                      clientName: _clientNameController.text,
                      invoiceDate: DateTime.now(),
                      items: _items,
                      taxRate: double.parse(_taxRateController.text),
                    );
                    Provider.of<InvoiceProvider>(context, listen: false)
                        .addInvoice(newInvoice);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
