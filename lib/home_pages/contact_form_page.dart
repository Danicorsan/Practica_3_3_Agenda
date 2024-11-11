import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica32cordan/models/agendaData.class.dart';
import 'package:provider/provider.dart';
import 'package:practica32cordan/models/contactData.class.dart';

class ContactFormPage extends StatefulWidget {
  final Contactdata contact;

  const ContactFormPage({super.key, required this.contact});

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthdateController;

  late Contactdata initialContact;

  bool isSaveEnabled = false;

  var icono = Icon(Icons.save, color: Colors.white30);

  @override
  void initState() {
    super.initState();

    initialContact = widget.contact.copyWith();

    _nameController = TextEditingController(text: widget.contact.name ?? "");
    _surnameController =
        TextEditingController(text: widget.contact.surname ?? "");
    _phoneController = TextEditingController(text: widget.contact.phone ?? "");
    _emailController = TextEditingController(text: widget.contact.email ?? "");
    _birthdateController = TextEditingController(
      text: widget.contact.birthdate != null
          ? DateFormat('dd/MM/yyyy').format(widget.contact.birthdate!)
          : "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void onDataChange() {
    widget.contact.name = _nameController.text;
    widget.contact.surname = _surnameController.text;
    widget.contact.phone = _phoneController.text;
    widget.contact.email = _emailController.text;
    widget.contact.birthdate = _birthdateController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(_birthdateController.text)
        : null;

    setState(() {
      if (widget.contact == initialContact) {
        isSaveEnabled = false;
      } else {
        isSaveEnabled = true;
        icono = Icon(Icons.save, color: Colors.white);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title =
        widget.contact.id == 0 ? "Nuevo contacto" : "Edición de contacto";

    if (widget.contact.id == 0) widget.contact.creation = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
        leading: IconButton(
          onPressed: () {
            _showExitConfirmationDialog(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: icono,
            onPressed: isSaveEnabled ? () => _saveContact(context) : null,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(28, 27, 32, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTextFormField(
                      controller: _nameController,
                      label: "Nombre",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El nombre es obligatorio";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTextFormField(
                    controller: _surnameController,
                    label: "Apellidos",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTextFormField(
                      controller: _phoneController,
                      label: "Teléfono",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El teléfono es obligatorio";
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return "El teléfono debe contener solo números";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTextFormField(
                      controller: _emailController,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "El email es obligatorio";
                        final emailRegExp = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (!emailRegExp.hasMatch(value))
                          return "Ingrese un email válido";
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _birthdateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Fecha de nacimiento",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "La fecha de nacimiento es obligatoria";
                      }
                      return null;
                    },
                    onChanged: (value) => onDataChange(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: keyboardType,
      onChanged: (value) {
        onDataChange();
      },
      validator: validator,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: "Selecciona la fecha de nacimiento",
      cancelText: "Cancelar",
      confirmText: "Aceptar",
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _birthdateController.text = formattedDate;
        widget.contact.birthdate = pickedDate;
      });
      onDataChange();
    }
  }

  void _saveContact(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final agenda = Provider.of<AgendaData>(context, listen: false);
      if (widget.contact.id == 0) {
        agenda.addContact(widget.contact);
      } else {
        agenda.updateContact(widget.contact);
      }
      Navigator.pop(context, true);
    }
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar salida"),
        content: Text(
            "Tienes cambios sin guardar. ¿Estás seguro de que deseas salir?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
            },
            child: Text("Salir"),
          ),
        ],
      ),
    );
  }
}
