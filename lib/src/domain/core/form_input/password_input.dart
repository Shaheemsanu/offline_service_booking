import 'package:formz/formz.dart';

enum PasswordInputError { empty, short, capitalLetter, digit }

class PasswordInput extends FormzInput<String, PasswordInputError> {
  const PasswordInput.pure({String value = ''}) : super.pure(value);
  const PasswordInput.dirty({String value = ''}) : super.dirty(value);

  static final capitalLetter = RegExp('[A-Z]');
  static final digit = RegExp('[0-9]');

  @override
  PasswordInputError? validator(String value) {
    if (value.isEmpty) return PasswordInputError.empty;
    if (value.length < 8) return PasswordInputError.short;
    if (!capitalLetter.hasMatch(value)) return PasswordInputError.capitalLetter;
    if (!digit.hasMatch(value)) return PasswordInputError.digit;
    return null;
  }
}
