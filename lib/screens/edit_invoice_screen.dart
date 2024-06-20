import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class EditInvoiceScreen extends StatefulWidget {
  final int invoiceIndex;

  EditInvoiceScreen({required this.invoiceIndex, required Invoice invoice});

  @override
  _EditInvoiceScreenState createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late Invoice invoice;

  final _clientNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _taxRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    invoice = Provider.of<InvoiceProvider>(context, listen: false).invoices[widget.invoiceIndex];

    _clientNameController.text = invoice.clientName;
    _taxRateController.text = invoice.taxRate.toString();
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _itemDescriptionController.dispose();
    _itemQuantityController.dispose();
    _itemPriceController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  void _saveInvoice() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        invoice.clientName = _clientNameController.text;
        invoice.taxRate = double.parse(_taxRateController.text);

        // Assuming you want to add the item being edited here
        if (_itemDescriptionController.text.isNotEmpty &&
            _itemQuantityController.text.isNotEmpty &&
            _itemPriceController.text.isNotEmpty) {
          invoice.items.add(
            InvoiceItem(
              description: _itemDescriptionController.text,
              quantity: int.parse(_itemQuantityController.text),
              price: double.parse(_itemPriceController.text),
            ),
          );
        }
      });

      Provider.of<InvoiceProvider>(context, listen: false).updateInvoice(widget.invoiceIndex, invoice);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Invoice', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInvoice,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
