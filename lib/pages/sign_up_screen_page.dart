// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica32cordan/pages/boot_page.dart';
import 'package:practica32cordan/pages/login_screen_page.dart';
import 'package:practica32cordan/services/firebase_auth_services.dart';

class SignUpScreenPage extends StatefulWidget {
  const SignUpScreenPage({super.key});

  @override
  State<SignUpScreenPage> createState() => _SignUpScreenPageState();
}

class _SignUpScreenPageState extends State<SignUpScreenPage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  bool _isPasswordObscured = true; // Controla la visibilidad de la contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            key: _formKey, // Asigna la clave al formulario
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Registrate",
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
                  texto: "Introduzca de nuevo su email",
                  controller: _confirmEmailController,
                  validator: (value) {
                    if (value != _emailController.text) {
                      return 'El email no coincide';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
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
                entradaDeTexto(
                  texto: "Introduzca de nuevo su contraseña",
                  esContrasenia: true,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'La contraseña no coincide';
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
                      _singUp();
                    }
                  },
                  child: Text(
                    "Registrarse",
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
                      "¿Ya tienes cuenta?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreenPage(),
                            ));
                      },
                      child: const Text(
                        '¡Presiona Aquí!',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
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
                  _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
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

  void _singUp() async {
    String email = _emailController.text.trim();
    String contrasenia = _passwordController.text.trim();

    try {
      User? user = await _auth.signUpConEmailYContrasenia(email, contrasenia);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BootPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMensaje;
      switch (e.code) {
        case 'email-already-in-use':
          errorMensaje = 'El email ya está en uso por otra cuenta.';
          break;
        case 'invalid-email':
          errorMensaje = 'El email no es válido.';
          break;
        case 'operation-not-allowed':
          errorMensaje = 'El registro con email/contraseña no está habilitado.';
          break;
        case 'weak-password':
          errorMensaje = 'La contraseña es muy débil.';
          break;
        default:
          errorMensaje = 'Ocurrió un error inesperado. Intenta de nuevo.';
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
          title: Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            errorMensaje,
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
    } catch (e) {
      print("Error desconocido: $e");
    }
  }
}
