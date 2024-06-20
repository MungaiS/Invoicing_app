import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/invoice.dart';
import 'screens/create_invoice_screen.dart';
import 'screens/invoice_list_screen.dart';
import 'screens/invoice_detail_screen.dart';
import 'screens/edit_invoice_screen.dart';
import 'providers/invoice_provider.dart';

void main() async {
  // Initialize Hive for Flutter
  await Hive.initFlutter();
  // Register the InvoiceAdapter for the Invoice model
  Hive.registerAdapter(InvoiceAdapter());
  // Open a Hive box named 'invoices' to store Invoice objects
  await Hive.openBox<Invoice>('invoices');

  // Run the app starting from the MyApp widget
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Create an instance of InvoiceProvider when the app starts
      create: (_) => InvoiceProvider(),
      child: MaterialApp(
        title: 'Invoice App',
        theme: ThemeData(
          // This is the theme of your application.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Set the initial route of the app
        initialRoute: '/',
        // Define the routes for the app
        routes: {
          '/': (context) => InvoiceListScreen(),
          '/create': (context) => CreateInvoiceScreen(),
          '/detail': (context) => InvoiceDetailScreen(invoiceIndex: ModalRoute.of(context)!.settings.arguments as int),
          '/edit': (context) => EditInvoiceScreen(invoiceIndex: ModalRoute.of(context)!.settings.arguments as int),
        },
      ),
    );
  }
}

