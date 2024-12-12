// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:practica32cordan/pages/contacts_page.dart';
import 'package:practica32cordan/models/enums/state_enum.dart';
import 'package:provider/provider.dart';
import 'package:practica32cordan/models/agendaData.class.dart';

class BootPage extends StatefulWidget {
  const BootPage({super.key});

  @override
  _BootPageState createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  @override
  void initState() {
    super.initState();
    _loadAgendaData();
  }

  // Método para cargar los datos de la agenda
  Future<void> _loadAgendaData() async {
    await Future.delayed(Duration(seconds: 1));
    final agendaData = Provider.of<AgendaData>(context, listen: false);

    // Cargar los datos de la agenda
    await agendaData.load();

    // Una vez que los datos se hayan cargado, navegar a la página de contactos
    if (agendaData.status == StateEnum.ready ||
        agendaData.status == StateEnum.initial) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactsPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
