// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:practica32cordan/home_pages/contact_form_page.dart';
import 'package:practica32cordan/models/agendaData.class.dart';
import 'package:practica32cordan/models/contactData.class.dart';
import 'package:provider/provider.dart';

class EventsHub extends ChangeNotifier {
  Future<void> onEditContact(BuildContext context, Contactdata contact,
      {bool isNew = false}) async {
    Contactdata contactCopy = contact.copyWith();

    bool? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactFormPage(contact: contactCopy),
      ),
    );

    if (result == true) {
      // Copia los valores actualizados
      contact.copyValuesFrom(contactCopy);

      contact.modification = DateTime.now();

      if (isNew) {
        Provider.of<AgendaData>(context, listen: false).addContact(contact);
      } else {
        Provider.of<AgendaData>(context, listen: false).updateContact(contact);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            isNew ? 'Contacto creado con éxito' : 'Contacto editado con éxito'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar el contacto'),
      ));
    }
  }

  void onSort(BuildContext context) {
    Provider.of<AgendaData>(context, listen: false)
        .ordenar(); // Cambia el orden de los contactos
  }

  void onCreateContact(BuildContext context) async {
    Contactdata contact = Contactdata(
      id: 0, // Sin ID único inicial
      name: '',
      surname: '',
      phone: '',
      email: '',
      birthdate: null,
      creation: DateTime.now(),
      isFavorite: false,
      labels: [],
    );

    bool? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactFormPage(contact: contact),
      ),
    );

    // Solo agrega el contacto si se confirma el formulario
    if (result == true) {
      Provider.of<AgendaData>(context, listen: false).addContact(contact);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Contacto creado con éxito'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Creación cancelada'),
      ));
    }
  }

  Future<void> onDeleteContact(
      BuildContext context, Contactdata contact) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
        title: Text(
          "Confirmar borrado",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Vas a borrar el contacto. ¿Estás seguro de que quieres borrarlo?",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancelar", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Aceptar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Provider.of<AgendaData>(context, listen: false).deleteContact(contact);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Contacto eliminado con éxito'),
      ));
    }
  }
}
