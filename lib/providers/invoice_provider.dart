import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/invoice.dart';

class InvoiceProvider with ChangeNotifier {
  List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  InvoiceProvider() {
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final box = await Hive.openBox<Invoice>('invoices');
    _invoices = box.values.toList();
    notifyListeners();
  }

  Future<void> addInvoice(Invoice invoice) async {
    final box = await Hive.openBox<Invoice>('invoices');
    await box.add(invoice);
    _invoices = box.values.toList();
    notifyListeners();
  }

  Future<void> updateInvoice(int index, Invoice updatedInvoice) async {
    final box = await Hive.openBox<Invoice>('invoices');
    await box.putAt(index, updatedInvoice);
    _invoices = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteInvoice(int index) async {
    final box = await Hive.openBox<Invoice>('invoices');
    await box.deleteAt(index);
    _invoices = box.values.toList();
    notifyListeners();
  }
}
