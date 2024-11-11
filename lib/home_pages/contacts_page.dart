// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica32cordan/funciones/functions.dart';
import 'package:practica32cordan/home_pages/contact_details_page.dart';
import 'package:practica32cordan/models/agendaData.class.dart';
import 'package:practica32cordan/models/contactData.class.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Agenda", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<AgendaData>(context, listen: false).ordenar();
              },
              icon: Icon(iconoOrdenar(context), color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.filter_alt_rounded, color: Colors.white),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(28, 27, 32, 1),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                  icon: Icon(Icons.contact_page, color: Colors.white),
                  text: "Contactos"),
              Tab(
                  icon: Icon(Icons.star, color: Colors.white),
                  text: "Favoritos"),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(28, 27, 32, 1),
          child: Consumer<AgendaData>(
            builder: (context, agenda, child) {
              return TabBarView(
                children: [
                  agenda.contacts.isEmpty
                      ? Center(
                          child: Text(
                            "Agenda vacía. Toca + para añadir un contacto",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : _buildContactList(agenda.contacts),
                  agenda.contacts
                          .where((contacto) => contacto.isFavorite)
                          .isEmpty
                      ? Center(
                          child: Text(
                            "No tienes contactos favoritos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : _buildContactList(agenda.contacts
                          .where((contacto) => contacto.isFavorite)
                          .toList()),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: FloatingActionButton(
              onPressed: () {
                onCreateContact(context);
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactList(List<Contactdata> contactos) {
    return ListView.builder(
      itemCount: contactos.length,
      itemBuilder: (context, index) {
        final contact = contactos[index];
        IconData icono;
        if (contact.labels.isEmpty) {
          icono = Icons.question_mark;
        } else {
          switch (contact.labels.first) {
            case "Trabajo":
              icono = Icons.business;
              break;
            case "Amistad":
              icono = Icons.emoji_emotions;
              break;
            case "Familia":
              icono = Icons.family_restroom;
              break;
            case "Deporte":
              icono = Icons.fitness_center;
              break;
            default:
              icono = Icons.question_mark;
          }
        }
        return ListTile(
          leading: CircleAvatar(
            radius: 15,
            backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
            child: Icon(icono, color: Colors.white),
          ),
          title: Text(
            '${contact.name} ${contact.surname} ${(contact.isFavorite) ? "★" : ""}',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            generarSubtitulo(email: contact.email, telefono: contact.phone),
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          trailing: PopupMenuButton<int>(
            color: const Color.fromARGB(255, 60, 58, 68),
            onSelected: (int result) {
              if (result == 1) {
                _navigateToContactDetails(context, contact);
              } else if (result == 2) {
                onEditContact(context, contact);
              } else if (result == 3) {
                _eliminarContacto(context, contact);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Ver", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Editar", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Eliminar", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          onTap: () => _navigateToContactDetails(context, contact),
        );
      },
    );
  }

  void _navigateToContactDetails(BuildContext context, Contactdata contact) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactDetailsPage(contact: contact),
      ),
    );
  }

  String generarSubtitulo({String? email, String? telefono}) {
    return [email, telefono].where((e) => e != null).join(', ');
  }

  IconData iconoOrdenar(BuildContext context) {
    return Provider.of<AgendaData>(context, listen: false).ascendente
        ? FontAwesomeIcons.arrowDownZA
        : FontAwesomeIcons.arrowDownAZ;
  }

  void _eliminarContacto(BuildContext context, Contactdata contact) {
    Provider.of<AgendaData>(context, listen: false).deleteContact(contact);
  }
}
