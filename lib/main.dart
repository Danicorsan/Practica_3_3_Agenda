import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practica32cordan/models/events_hub.dart';
import 'package:practica32cordan/models/agendaData.class.dart';
import 'package:practica32cordan/pages/login_screen_page.dart';
import 'package:practica32cordan/services/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AgendaData(), // Proveedor de AgendaData
        ),
        ChangeNotifierProvider(
          create: (_) => EventsHub(), // Proveedor de EventsHub
        ),
      ],
      child: const MaterialApp(
        title: "Agenda",
        debugShowCheckedModeBanner: false,
        home: LoginScreenPage(),
      ),
    );
  }
}
