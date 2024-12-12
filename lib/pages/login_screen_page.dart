// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica32cordan/pages/boot_page.dart';
import 'package:practica32cordan/pages/sign_up_screen_page.dart';
import 'package:practica32cordan/services/firebase_auth_services.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Agenda",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bienvenido",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(
                  height: 40,
                ),
                entradaDeTexto(
                  texto: "Email",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su email';
                    }
                    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                      return 'Ingrese un email válido';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                entradaDeTexto(
                  texto: "Contraseña",
                  esContrasenia: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login(context);
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "¿No tienes cuenta?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreenPage()),
                        );
                      },
                      child: const Text('¡Presiona Aquí!',
                          style: TextStyle(color: Colors.lightBlue)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //METODO DONDE SE COMUNICA APP CON LA CLASE QUE SE COMUNICA CON FIREBASE

  void login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? usuario = await _auth.loginWithEmailAndPassword(email, password);

      if (usuario != null) {
        print("Usuario registrado con éxito");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BootPage(),
          ),
        );
      }
    } on FirebaseAuthException {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
          title: Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "No existe ninguna cuenta con esas credencias",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget entradaDeTexto({
    String? texto,
    bool? esContrasenia,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: texto,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(255, 218, 218, 218),
        suffixIcon: esContrasenia == true
            ? IconButton(
                icon: Icon(
                  _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
              )
            : null,
      ),
      cursorWidth: 1,
      obscureText: esContrasenia == true ? _isPasswordObscured : false,
    );
  }
}
