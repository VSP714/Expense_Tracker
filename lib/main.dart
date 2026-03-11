import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'screens/expense_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpensesProvider()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 115, 0, 255)),
          useMaterial3: true,
        ),
        home: const ExpensesScreen(),
      ),
    );
  }
}