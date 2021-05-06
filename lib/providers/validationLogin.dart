import 'package:flutter/cupertino.dart';

class LoginValidation with ChangeNotifier {
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  //Getters
  ValidationItem get email => _email;
  ValidationItem get password => _password;
  bool get isValid {
    if (_password.value != null && _email.value != null) {
      return true;
    } else {
      return false;
    }
  }

  //Setters
  void changeEmail(String value) {
    if (value.contains('@') == true) {
      _email = ValidationItem(value, null);
    } else {
      _email = ValidationItem(null, "Geçerli bir E mail giriniz");
    }
    notifyListeners();
  }

  void changePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(value) && value.length >= 8) {
      _password = ValidationItem(value, null);
    } else {
      _password = ValidationItem(null,
          "Şifreniz özel karekter, rakam ve büyük harf içerip en az 8 karakter uzunluğunda olmalıdır");
    }
    notifyListeners();
  }

  void submitData() {
    print("FirstName: ${email.value}, LastName: ${password.value}}");
  }
}

class ValidationItem {
  final String value;
  final String error;

  ValidationItem(this.value, this.error);
}
