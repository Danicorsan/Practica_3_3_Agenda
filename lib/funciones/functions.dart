// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:practica32cordan/data/datos_agenta.dart';
import 'package:practica32cordan/home_pages/contact_form_page.dart';
import 'package:practica32cordan/models/agendaData.class.dart';
import 'package:practica32cordan/models/contactData.class.dart';
import 'package:provider/provider.dart';

Future<void> onCreateContact(BuildContext context) async {
  Contactdata contact = Contactdata(
    id: 0,
    name: '',
    surname: '',
    phone: '',
    email: '',
    birthdate: null,
    modification: null,
    creation: DateTime.now(),
    isFavorite: false,
    labels: [],
  );

  bool? result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ContactFormPage(contact: contact),
    ),
  );

  if (result == true) {
    contact.creation = DateTime.now();
    contact.id = agenda.contacts.length;

    Provider.of<AgendaData>(context, listen: false).notifyListeners();
  }
}

Future<void> onEditContact(BuildContext context, Contactdata contact) async {
  Contactdata contactCopy = contact.copyWith();

  bool? result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ContactFormPage(contact: contactCopy),
    ),
  );

  if (result == true) {
    contact.copyValuesFrom(contactCopy);

    contact.modification = DateTime.now();
    Provider.of<AgendaData>(context, listen: false).updateContact(contact);
  }
}
