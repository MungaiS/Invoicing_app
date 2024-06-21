import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class EditInvoiceScreen extends StatefulWidget {
  final Invoice invoice;
  final int invoiceIndex;

  const EditInvoiceScreen({required this.invoice, required this.invoiceIndex});

  @override
  _EditInvoiceScreenState createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientNameController;
  late TextEditingController _clientAddressController;
  late TextEditingController _clientEmailController;
  late TextEditingController _itemDescriptionController;
  late TextEditingController _itemQuantityController;
  late TextEditingController _itemPriceController;
  late TextEditingController _taxRateController;

  late List<InvoiceItem> _items;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController(text: widget.invoice.clientName);
    _clientAddressController = TextEditingController(text: widget.invoice.clientAddress);
    _clientEmailController = TextEditingController(text: widget.invoice.clientEmail);
    _itemDescriptionController = TextEditingController();
    _itemQuantityController = TextEditingController();
    _itemPriceController = TextEditingController();
    _taxRateController = TextEditingController(text: widget.invoice.taxRate.toString());

    _items = List.from(widget.invoice.items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Invoice'),
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
              TextFormField(
                controller: _itemQuantityController,
                decoration: const InputDecoration(labelText: 'Item Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _itemPriceController,
                decoration: const InputDecoration(labelText: 'Item Price'),
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
                child: const Text('Add Item'),
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
                    final updatedInvoice = Invoice(
                      clientName: _clientNameController.text,
                      clientAddress: _clientAddressController.text,
                      clientEmail: _clientEmailController.text,
                      invoiceDate: widget.invoice.invoiceDate,
                      items: _items,
                      taxRate: double.parse(_taxRateController.text),
                    );
                    Provider.of<InvoiceProvider>(context, listen: false)
                        .updateInvoice(widget.invoiceIndex, updatedInvoice);
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
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _items
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(
                          cells: [
                            DataCell(Text(entry.value.description)),
                            DataCell(Text(entry.value.quantity.toString())),
                            DataCell(Text('\$${entry.value.price.toStringAsFixed(2)}')),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _items.removeAt(entry.key);
                                  });
                                },
                              ),
                            ),
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
