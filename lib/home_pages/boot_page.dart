// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:practica32cordan/home_pages/contacts_page.dart';
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
      // Si ocurrió un error en la carga, navegar a una pantalla de error (opcional)
      // Para ahora, simplemente navegar a ContactsPage si no hay error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
