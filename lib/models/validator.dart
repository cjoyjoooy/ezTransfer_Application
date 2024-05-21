import 'package:eztransfer/models/extensions.dart';


String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your first name';
  }
  if (!value.isValidName) {
    return 'Enter a valid first name';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password!.isEmpty) {
    return 'Please enter password';
  }
  return null;
}

String? validateField(String? value) {
  if (value!.isEmpty) {
    return 'Field empty. Please input information';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == "") {
    return 'Please enter your email';
  }
  if (!value!.isValidEmail) {
    return 'Enter valid email';
  }
  return null;
}
