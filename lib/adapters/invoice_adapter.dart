import 'package:hive/hive.dart';
import '../models/invoice.dart';

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 0;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      clientName: fields[0] as String,
      invoiceDate: fields[1] as DateTime,
      items: (fields[2] as List).cast<InvoiceItem>(),
      taxRate: fields[3] as double, clientEmail: '', clientAddress: '',
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.clientName)
      ..writeByte(1)
      ..write(obj.invoiceDate)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.taxRate);
  }
}

class InvoiceItemAdapter extends TypeAdapter<InvoiceItem> {
  @override
  final int typeId = 1;

  @override
  InvoiceItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceItem(
      description: fields[0] as String,
      quantity: fields[1] as int,
      price: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.price);
  }
}
