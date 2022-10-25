import 'package:flutter/material.dart';
import 'package:storeproject/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:storeproject/providers/cart_provider.dart';
import 'package:storeproject/providers/product_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false);
  }
}
