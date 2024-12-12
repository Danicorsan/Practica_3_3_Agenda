import 'package:firebase_auth/firebase_auth.dart';

//CLASE PARA HACER EL SIGNUP Y EL LOGIN

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para registro de usuario
  Future<User?> signUpConEmailYContrasenia(
      String email, String contrasenia) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: contrasenia,
    );
    return userCredential.user;
  }

  // Método para inicio de sesión
  Future<User?> loginWithEmailAndPassword(
      String email, String contrasenia) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: contrasenia,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
