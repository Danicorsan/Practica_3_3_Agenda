// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica32cordan/data/datos_agenta.dart';
import 'package:practica32cordan/home_pages/contact_details_page.dart';
import 'package:practica32cordan/models/agendaData.class.dart';
import 'package:practica32cordan/models/contactData.class.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  @override
  Widget build(BuildContext context) {
    AgendaData agenda =
        Provider.of<AgendaData>(context); 

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Agenda",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
          actions: [
            IconButton(
              onPressed: () {
                agenda.ordenar();
              },
              icon: Icon(
                iconoOrdenar(),
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_alt_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(28, 27, 32, 1),
          child: TabBar(
            labelColor:
                Colors.white, 
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                  icon: Icon(
                    Icons.contact_page,
                    color: Colors.white,
                  ),
                  text: "Contactos"),
              Tab(
                  icon: Icon(Icons.star, color: Colors.white),
                  text: "Favoritos"),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(28, 27, 32, 1),
          child: TabBarView(
            children: [
              _buildContactList(agenda.contacts),
              _buildContactList(agenda.contacts
                  .where(
                    (contacto) => contacto.isFavorite,
                  )
                  .toList()),
            ],
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
        return ListenableBuilder(
          listenable: contact,
          builder: (context, _) {
            return ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
                child: Icon(
                  icono,
                  color: Colors.white,
                ),
              ),
              title: Text(
                '${contact.name} ${contact.surname} ${(contact.isFavorite) ? "★" : ""}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                generarSubtitulo(email: contact.email, telefono: contact.phone),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    wordSpacing: 0,
                    letterSpacing: 0),
              ),
              trailing: PopupMenuButton<int>(
                color: const Color.fromARGB(255, 60, 58, 68),
                onSelected: (int result) {
                  if (result == 1) {
                    _navigateToContactDetails(context, contact);
                  } else if (result == 2) {
                    print("Editar contacto");
                  } else if (result == 3) {
                    print("Eliminar contacto");
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Ver",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text("Editar", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
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
      },
    );
  }

  void _navigateToContactDetails(
      BuildContext context, Contactdata contact) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactDetailsPage(contact: contact),
      ),
    );
    contact.modification = DateTime.now();

    Provider.of<AgendaData>(context, listen: false).notifyListeners();
  }

  String generarSubtitulo({String? email, String? telefono}) {
    return [email, telefono].where((e) => e != null).join(', ');
  }

  IconData iconoOrdenar() {
    if (agenda.ascendente) {
      return FontAwesomeIcons.arrowDownZA;
    } else {
      return FontAwesomeIcons.arrowDownAZ;
    }
  }
}
