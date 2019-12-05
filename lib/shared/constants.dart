library constants;

import 'package:flutter/material.dart';

// constants for user options.
const MY_PAGE = 'Mín Síða';
const MY_ASSOCIATION = 'Mitt húsfélag';
const SIGN_OUT = 'Skrá út';
const List<String> choices = <String>[MY_PAGE, MY_ASSOCIATION, SIGN_OUT];

// constants for collection names
const String RESIDENT_ASSOCIATIONS_COLLECTION = 'ResidentAssociations';
const String USERS_COLLECTION = 'Users';
const String APARTMENTS_COLLECTION = 'Apartments';
const String CONSTRUCTIONS_COLLECTION = 'Constructions';
const String DOCUMENTS_COLLECTION = 'Documents';
const String FOLDERS_COLLECTION = 'Folders';
const String MEETINGS_COLLECTION = 'Meetings';
const String CLEANING_ITEMS_COLLECTION = 'CleaningItems';
const String CLEANING_TASKS_COLLECTION = 'CleaningTasks';

// constants for properties
const String ACCESS_CODE = 'accessCode';
const String ADDRESS = 'address';
const String APARTMENT_NUMBER = 'apartmentNumber';
const String APARTMENT_ID = 'apartmentId';
const String AUTHOR_ID = 'authorId';
const String DATE = 'date';
const String DATE_FROM = 'dateFrom';
const String DATE_TO = 'dateTo';
const String DURATION = 'duration';
const String DESCRIPTION = 'description';
const String EMAIL = 'email';
const String IS_ADMIN = 'isAdmin';
const String LOCATION = 'location';
const String NAME = 'name';
const String RESIDENTS = 'residents';
const String RESIDENT_ASSOCIATION_ID = 'residentAssociationId';
const String TASK_DONE = 'taskDone';
const String TITLE = 'title';

// constants for months in icelandic.
const List<String> months = [
  'Janúar',
  'Febrúar',
  'Mars',
  'Apríl',
  'Maí',
  'Júní',
  'Júlí',
  'Ágúst',
  'September',
  'Október',
  'Nóvember',
  'Desember',
];

// constants for weekdays in icelandic.
const List<String> weekdays = [
  'Mánudagur',
  'Þriðjudagur',
  'Miðvikudagur',
  'Fimmtudagur',
  'Föstudagur',
  'Laugardagur',
  'Sunnudagur',
];

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);
