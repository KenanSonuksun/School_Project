import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassesProvider with ChangeNotifier {
  var classes;
  var docId;
  getData(email) async {
    await FirebaseFirestore.instance.collection(email).get().then((value) {
      classes = value.docs;
    });
    notifyListeners();
  }
}
