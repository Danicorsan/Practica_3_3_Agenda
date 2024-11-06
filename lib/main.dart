import 'package:flutter/material.dart';
import 'package:practica32cordan/home_pages/contacts_page.dart';
import 'package:provider/provider.dart';
import 'data/datos_agenta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
         
        return ChangeNotifierProvider.value(
          value: agenda,
          builder: (context,_) {
            return const MaterialApp(
              title: "Agenda",
              home: ContactsPage(),
            );
          }
        );
      }
    );
  }
}
