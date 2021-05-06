import 'package:flutter/cupertino.dart';

class SignupValidation with ChangeNotifier {
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
  ValidationItem _fullName = ValidationItem(null, null);

  //Getters
  ValidationItem get email => _email;
  ValidationItem get password => _password;
  ValidationItem get fullName => _fullName;
  bool get isValid {
    if (_password.value != null &&
        _email.value != null &&
        _fullName.value != null) {
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
      _email = ValidationItem(null, "Geçerli E mail giriniz");
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

  void changeFullName(String value) {
    if (value.length >= 2) {
      _fullName = ValidationItem(value, null);
    } else {
      _fullName = ValidationItem(null, "Boş bırakmayınız");
    }
    notifyListeners();
  }

  void submitData() {
    print(
        "FirstName: ${email.value}, LastName: ${password.value}}, FullName: ${fullName.value}");
  }
}

class ValidationItem {
  final String value;
  final String error;

  ValidationItem(this.value, this.error);
}
