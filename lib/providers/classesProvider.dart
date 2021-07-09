import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassesProvider with ChangeNotifier {
  var classes;
  bool loading = true;
  bool error = false;
  getData(email) async {
    await FirebaseFirestore.instance.collection(email).get().then((value) {
      if (value != null) {
        classes = value.docs;
        loading = false;
      } else {
        loading = false;
        error = true;
      }
    });
    notifyListeners();
  }
}
