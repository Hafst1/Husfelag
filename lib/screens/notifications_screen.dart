import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart'; //þessi tvö kannski í main?
import 'package:provider/provider.dart';
import './../providers/current_user_provider.dart';

import 'dart:io';

class NotificationScreen extends StatelessWidget {

  @override
    Widget build(BuildContext context) {
      print("TILKYNNINGAR BUILD");
      return Scaffold(
        appBar: AppBar(
        title: Text("Tilkynningar"),
        ),
      );
    }
}

