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
  final _clientAddressController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _taxRateController = TextEditingController();

  final List<InvoiceItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Client Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the client name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _clientAddressController,
                decoration: const InputDecoration(labelText: 'Client Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the client address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _clientEmailController,
                decoration: const InputDecoration(labelText: 'Client Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the client email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Invoice Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _itemDescriptionController,
                decoration: const InputDecoration(labelText: 'Item Description'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _itemQuantityController,
                      decoration: const InputDecoration(labelText: 'Item Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _itemPriceController,
                      decoration: const InputDecoration(labelText: 'Item Price'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
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
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Tax Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _taxRateController,
                decoration: const InputDecoration(labelText: 'Tax Rate (%)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newInvoice = Invoice(
                      clientName: _clientNameController.text,
                      clientAddress: _clientAddressController.text,
                      clientEmail: _clientEmailController.text,
                      invoiceDate: DateTime.now(),
                      items: _items,
                      taxRate: double.parse(_taxRateController.text),
                    );
                    Provider.of<InvoiceProvider>(context, listen: false)
                        .addInvoice(newInvoice);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Invoice'),
              ),
              const SizedBox(height: 20),
              if (_items.isNotEmpty)
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                  ],
                  rows: _items
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
            ],
          ),
        ),
      ),
    );
  }
}
