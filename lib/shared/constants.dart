import 'package:flutter/material.dart';

class Constants {
  static const MyPage = 'Mín Síða';
  static const SignOut = 'Skrá út';

  static const List<String> choices = <String>[MyPage, SignOut];

  static const List<String> months = [
    "Janúar",
    "Febrúar",
    "Mars",
    "Apríl",
    "Maí",
    "Júní",
    "Júlí",
    "Ágúst",
    "September",
    "Október",
    "Nóvember",
    "Desember",
  ];

  static const List<String> weekdays = [
    "Mánudagur",
    "Þriðjudagur",
    "Miðvikudagur",
    "Fimmtudagur",
    "Föstudagur",
    "Laugardagur",
    "Sunnudagur",
  ];
}

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);
