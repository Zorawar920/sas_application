import 'package:form_field_validator/form_field_validator.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(6, errorText: 'Password must be atleast 6 characters long')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email address is required'),
  EmailValidator(errorText: "Enter a valid email address.")
]);

final nameValidator = RequiredValidator(errorText: 'Name is required');
