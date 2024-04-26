String? validatePassword(String? password) {
  if (password!.isEmpty) {
    return 'Please enter password';
  }
  return null;
}
