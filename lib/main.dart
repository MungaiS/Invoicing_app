import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/invoice.dart';
import 'screens/home_screen.dart';
import 'screens/create_invoice_screen.dart';
import 'screens/invoice_list_screen.dart';
import 'screens/invoice_detail_screen.dart';
import 'screens/edit_invoice_screen.dart';
import 'providers/invoice_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(InvoiceItemAdapter());
  await Hive.openBox<Invoice>('invoices');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceProvider(),
      child: MaterialApp(
        title: 'Invoice App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/invoices': (context) => InvoiceListScreen(),
          '/create': (context) => CreateInvoiceScreen(),
          '/detail': (context) {
            final invoiceIndex = ModalRoute.of(context)!.settings.arguments as int;
            final invoice = Provider.of<InvoiceProvider>(context, listen: false).invoices[invoiceIndex];
            return InvoiceDetailScreen(invoice: invoice);
          },
          '/edit': (context) {
            final invoiceIndex = ModalRoute.of(context)!.settings.arguments as int?;
            if (invoiceIndex == null) {
              throw ArgumentError('Invoice index must not be null.');
            }
            final invoice = Provider.of<InvoiceProvider>(context, listen: false).invoices[invoiceIndex];
            return EditInvoiceScreen(invoice: invoice, invoiceIndex: invoiceIndex,);
          },
        },
      ),
    );
  }
}


