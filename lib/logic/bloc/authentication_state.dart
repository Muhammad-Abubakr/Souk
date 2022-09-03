// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  loggedOut,
  authenticating,
  loggedIn,
  error,
  resetPassword,
}

abstract class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final User? user;
  final FirebaseException? exception;

  const AuthenticationState({
    required this.status,
    this.user,
    this.exception,
  });

  @override
  List<Object?> get props => [status, user, exception];
}

class _AuthenticationInitialState extends AuthenticationState {
  const _AuthenticationInitialState({required super.status});
}

class _AuthenticationStateUpdate extends AuthenticationState {
  const _AuthenticationStateUpdate({required super.status, super.user, super.exception});
}
