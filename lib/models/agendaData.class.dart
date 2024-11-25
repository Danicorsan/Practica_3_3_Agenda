// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:practica32cordan/models/contactData.class.dart';
import 'package:practica32cordan/models/enums/state_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaData extends ChangeNotifier {
  List<Contactdata> contacts;
  StateEnum _status;
  bool ascendente = false;

  // Getter público para status
  StateEnum get status => _status;

  AgendaData({
    List<Contactdata>? contacts,
  })  : _status = StateEnum.initial,
        contacts = contacts ?? [];

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

  int _generateUniqueId() {
    if (contacts.isEmpty) {
      return 1; // Si no hay contactos, comienza desde 1
    }
    // Encuentra el ID más alto y suma 1
    return contacts.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void addContact(Contactdata contact) {
    if (contacts.any((c) => c.id == contact.id)) {
      print("Contacto ya existe: ${contact.id}");
      return; // No agrega duplicados
    }

    if (contact.id == 0) {
      contact = contact.copyWith(id: _generateUniqueId());
    }

    contacts.add(contact);
    notifyListeners();
    save();
  }

  void deleteContact(Contactdata contact) {
    contacts.remove(contact);
    notifyListeners();
    save();
  }

  void updateContact(Contactdata contact) {
    int index = contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      contacts[index] = contact.copyWith(modification: DateTime.now());
    } else {
      print("No se encontró el contacto para actualizar");
    }

    notifyListeners();
    save();
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

  // Guardar la agenda
  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString =
        jsonEncode(contacts.map((e) => e.toJson()).toList());
    await prefs.setString('agenda', jsonString);
    print(jsonString);
  }

  Future<void> load() async {
    // Cambiar el estado a "Loading"
    _status = StateEnum.loading;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString('agenda');

      if (jsonString != null && jsonString.isNotEmpty) {
        // Si hay datos en SharedPreferences, los cargamos
        final List<dynamic> jsonData = jsonDecode(jsonString);
        contacts = jsonData.map((e) => Contactdata.fromJson(e)).toList();
        _status = StateEnum.ready;
      } else {
        // Si no hay datos, mantenemos la agenda vacía
        contacts = [];
        _status = StateEnum.initial;
      }
    } catch (e) {
      // Si ocurre un error, cambiamos el estado a Error
      _status = StateEnum.error;
      print("Error al cargar los contactos: $e");
    }

    // Notificamos que el estado ha cambiado
    notifyListeners();
  }
}
