import 'package:flutter/material.dart';
import 'planet_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Planeta',
      theme: ThemeData(
        primarySwatch: const Color.fromARGB(255, 233, 9, 195),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: const Color.fromARGB(255, 233, 9, 195)).copyWith(secondary: Colors.purple),
      ),
      home: PlanetList(),
    );
  }
}

