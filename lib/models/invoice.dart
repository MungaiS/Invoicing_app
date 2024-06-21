import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'invoice.g.dart';

@HiveType(typeId: 0)
class Invoice extends HiveObject {
  @HiveField(0)
  String clientName;

  @HiveField(1)
  DateTime invoiceDate;

  @HiveField(2)
  String clientAddress; // New field for client address

  @HiveField(3)
  String clientEmail;

  @HiveField(4)
  List<InvoiceItem> items;

  @HiveField(5)
  double taxRate;

  Invoice({
    required this.clientName,
    required this.invoiceDate,
    required this.clientAddress,
    required this.clientEmail,
    required this.items,
    required this.taxRate,
  });

  double calculateTotal() {
    double subtotal = items.fold(0, (sum, item) => sum + item.quantity * item.price);
    double total = subtotal + (subtotal * taxRate / 100);
    return total;
  }
}

@HiveType(typeId: 1)
class InvoiceItem extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}
