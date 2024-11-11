import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:practica32cordan/models/contactData.class.dart';

class AgendaData extends ChangeNotifier {
  List<Contactdata> contacts;

  bool ascendente = false;

  AgendaData({
    List<Contactdata>? contacts,
  }) : contacts = contacts ?? [];

  @override
  String toString() {
    return contacts.map((e) => e.toString()).join("\n");
  }

  AgendaData copyWith({List<Contactdata>? contacts}) {
    return AgendaData(
        contacts: contacts ?? this.contacts.map((c) => c.copyWith()).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      if (contacts.isNotEmpty) "Contacts": contacts.map((c) => c.toJson())
    };
  }

  factory AgendaData.fromJson(Map<String, dynamic> data) {
    return AgendaData(
        contacts: data["contacts"] != null
            ? List.from(data["contacts"])
                .map((contacData) => Contactdata.fromJson(contacData))
                .toList()
            : []);
  }

  void addContact(Contactdata contact) {
    contacts.add(contact);
    notifyListeners();
  }

  void deleteContact(Contactdata contact) {
    contacts.remove(contact);
    notifyListeners();
  }

  void updateContact(Contactdata contact) {
    int index = contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      contacts[index] = contact;
      notifyListeners();
    }
  }

  void ordenar() {
    contacts.sort((a, b) {
      String nameA = removeDiacritics(a.name!.toLowerCase());
      String nameB = removeDiacritics(b.name!.toLowerCase());
      return ascendente ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
    });
    ascendente = !ascendente;
    notifyListeners();
  }
}
