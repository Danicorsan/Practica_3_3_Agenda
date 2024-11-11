// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica32cordan/models/agendaData.class.dart';
import 'package:practica32cordan/models/contactData.class.dart';
import 'package:provider/provider.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contactdata contact;

  const ContactDetailsPage({required this.contact, super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    AgendaData agenda = Provider.of<AgendaData>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              (widget.contact.isFavorite) ? Icons.star : Icons.star_border,
            ),
            color: Colors.white,
            onPressed: () {
              setState(() {
                widget.contact.isFavorite = !widget.contact.isFavorite;
              });
              agenda.updateContact(widget.contact);
              print(widget.contact.isFavorite);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      radius: 70,
                      child: Center(
                        child: Icon(
                          _cambiarIcono(widget.contact),
                          color: Colors.white,
                          size: 75,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${widget.contact.name ?? ""}  ${widget.contact.surname ?? ""}",
                      style: TextStyle(
                        color: Colors.white,
                        wordSpacing: -5,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Correo electrónico",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                widget.contact.email ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              trailing: Icon(
                Icons.email,
                color: Colors.white,
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Enviando email a ${widget.contact.email}..."),
                  duration: Duration(seconds: 2),
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Teléfono",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                widget.contact.phone ?? "",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              trailing: Icon(
                Icons.call,
                color: Colors.white,
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Llamando a ${widget.contact.name} ${widget.contact.surname}...",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  duration: Duration(seconds: 2),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nacimiento",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            widget.contact.birthdate != null
                                ? DateFormat('MMM dd, yyyy')
                                    .format(widget.contact.birthdate!)
                                : "",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Edad",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          widget.contact.birthdate != null
                              ? (DateTime.now().year -
                                      widget.contact.birthdate!.year)
                                  .toString()
                              : "",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Etiquetas",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                (widget.contact.labels).join(", "),
                style: TextStyle(color: Colors.white, fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: _editarEtiquetas,
            ),
            Divider(),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Aded on ${widget.contact.creation != null ? DateFormat('dd-MM-yyyy hh:mm').format(widget.contact.creation!) : ""}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${widget.contact.modification != null ? "Modiffied on " + DateFormat('dd-MM-yyyy hh:mm').format(widget.contact.modification!) : ""}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editarEtiquetas() {
    final TextEditingController labelsController = TextEditingController(
      text: widget.contact.labels
          .map((s) => s[0].toUpperCase() + s.substring(1).toLowerCase())
          .join(", "),
    );

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext contexto) {
        return Container(
          color: const Color.fromRGBO(28, 27, 32, 1),
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            children: [
              TextFormField(
                controller: labelsController,
                style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 255, 255, 255)),
                decoration: InputDecoration(
                    labelText: "Etiquetas",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      widget.contact.labels = labelsController.text
                          .split(',')
                          .map((label) => label.trim().toLowerCase())
                          .where((label) => label.isNotEmpty)
                          .map((s) =>
                              s[0].toUpperCase() + s.substring(1).toLowerCase())
                          .toList();
                    });
                    Navigator.pop(context);
                    print("Etiquetas actualizadas: ${widget.contact.labels}");
                  },
                  child: Text("Aplicar"),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  IconData _cambiarIcono(Contactdata contact) {
    if (contact.labels.isEmpty) {
      return Icons.question_mark;
    } else {
      switch (contact.labels.first) {
        case "Trabajo":
          return Icons.business;
        case "Amistad":
          return Icons.emoji_emotions;
        case "Familia":
          return Icons.family_restroom;
        case "Deporte":
          return Icons.fitness_center;
        default:
          return Icons.question_mark;
      }
    }
    
  }
}
