// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

// Defining base interface
abstract class AuthenticationEvent {}

// Defining events for the authentication bloc
class AuthenticateWithGoogleEvent implements AuthenticationEvent {}

class AuthenticateWithEmailPassword implements AuthenticationEvent {
  final String email;
  final String password;

  AuthenticateWithEmailPassword({
    required this.email,
    required this.password,
  });
}

class SignUpWithEmailAndPassword implements AuthenticationEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const SignUpWithEmailAndPassword({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class ForgotPasswordEvent implements AuthenticationEvent {
  final String email;

  const ForgotPasswordEvent({
    required this.email,
  });
}

class SignOutEvent implements AuthenticationEvent {}

class _UserChangeEvent implements AuthenticationEvent {
  final User? user;
  _UserChangeEvent({
    this.user,
  });
}
