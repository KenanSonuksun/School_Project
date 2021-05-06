import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  var profile;
  var index = 0;
  getProfil(email) async {
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (email == value.docs[i].id.toString()) {
          index = i;
        }
      }
      profile = value.docs[index];
    });
    notifyListeners();
  }
}
