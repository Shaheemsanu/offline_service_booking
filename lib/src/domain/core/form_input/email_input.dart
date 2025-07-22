import 'package:formz/formz.dart';

// Create form input for validation using formz package like this
enum EmailInputError { empty, invalid }

class EmailInput extends FormzInput<String, EmailInputError> {
  const EmailInput.pure({String value = ''}) : super.pure(value);

  const EmailInput.dirty({String value = ''}) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailInputError? validator(String value) {
    if (value.isEmpty) return EmailInputError.empty;
    if (!_emailRegExp.hasMatch(value)) return EmailInputError.invalid;
    return null;
  }
}
