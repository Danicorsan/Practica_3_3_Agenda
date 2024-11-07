import 'package:flutter/material.dart';

class Contactdata extends ChangeNotifier {
  int id;
  String? name;
  String? surname;
  String? email;
  String? phone;
  DateTime? birthdate;
  DateTime? creation;
  DateTime? modification;
  bool isFavorite;
  List<String> labels;

  Contactdata({
    required this.id,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.birthdate,
    this.creation,
    this.modification,
    this.isFavorite = false,
    List<String>? labels,
  }) : labels = labels ?? [];

  factory Contactdata.fromJson(Map<String, dynamic> data) {
    return Contactdata(
      id: data["id"] ?? 0,
      name: data["name"],
      surname: data["surname"],
      email: data["email"],
      phone: data["phone"],
      birthdate: DateTime.tryParse(data["birthdate"]),
      creation: DateTime.tryParse(data["creation"]),
      modification: DateTime.tryParse(data["modification"]),
      isFavorite: data["isFavorite"] ?? false,
      labels: data["labels"] != null ? List.from(data["labels"]) : [],
    );
  }

  @override
  String toString() {
    return "Contactdata(\n${[
      [
        "id: $id",
        if (name != null) "Name: $name",
        if (surname != null) "Surname: $surname",
        if (email != null) "Email: $email",
        if (phone != null) "Phone: $phone",
        if (birthdate != null) "Birthdate: $birthdate",
        if (creation != null) "Creation: $creation",
        if (modification != null) "modification: $modification",
        if (isFavorite) "Is favorite",
        if (labels.isNotEmpty) "labels: ${labels.join(", ")}",
      ]
    ].map(
          (e) => "\te",
        ).join(",\n")})\n";
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      if (name != null) "Name": name,
      if (surname != null) "Surname": surname,
      if (email != null) "Email": email,
      if (phone != null) "Phone": phone,
      if (birthdate != null) "Birthdate": birthdate!.toIso8601String(),
      if (creation != null) "Creation": creation!.toIso8601String(),
      if (modification != null) "modification": modification!.toIso8601String(),
      if (isFavorite) "isFavorite": true,
      if (labels.isNotEmpty) "labels": List.from(labels),
    };
  }

  Contactdata copyWith({
    int? id,
    String? name,
    String? surname,
    String? email,
    String? phone,
    DateTime? birthdate,
    DateTime? creation,
    DateTime? modification,
    bool? isFavorite,
    List<String>? labels,
  }) {
    return Contactdata(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        birthdate: birthdate ?? this.birthdate,
        creation: creation ?? this.creation,
        modification: modification ?? this.modification,
        isFavorite: isFavorite ?? this.isFavorite,
        labels: labels ?? List.from(this.labels));
  }

  void copyValuesFrom(Contactdata source) {
    id = source.id;
    name = source.name;
    surname = source.surname;
    email = source.email;
    phone = source.phone;
    birthdate = source.birthdate;
    creation = source.creation;
    modification = source.modification;
    isFavorite = source.isFavorite;
    labels = List.from(source.labels);
  }
}
