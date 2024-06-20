import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/invoice.dart';

class InvoiceProvider with ChangeNotifier {
  final Box<Invoice> _invoiceBox = Hive.box<Invoice>('invoices');

  List<Invoice> get invoices => _invoiceBox.values.toList();

  void addInvoice(Invoice invoice) {
    _invoiceBox.add(invoice);
    notifyListeners();
  }

  void updateInvoice(Invoice invoice) {
    invoice.save();
    notifyListeners();
  }
}