// lib/models/invoice.dart
import 'package:hive/hive.dart';

part 'invoice.g.dart';

@HiveType(typeId: 0)
class Invoice extends HiveObject {
  @HiveField(0)
  String clientName;
  @HiveField(1)
  final DateTime invoiceDate;
  @HiveField(2)
  final List<InvoiceItem> items;
  @HiveField(3)
  final double taxRate;
  @HiveField(4)
  final double total;

  Invoice({
    required this.clientName,
    required this.invoiceDate,
    required this.items,
    required this.taxRate,
  }) : total = items.fold(
          0.0, // Change the initial value to 0.0
          (previousValue, element) =>
              previousValue + (element.price * element.quantity),
        ) * (1 + taxRate / 100);
}

@HiveType(typeId: 1)
class InvoiceItem {
  @HiveField(0)
  final String description;
  @HiveField(1)
  final int quantity;
  @HiveField(2)
  final double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}

