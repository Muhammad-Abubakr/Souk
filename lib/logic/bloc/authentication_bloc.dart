import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../packages/firebase_api/firebase_link.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  // Since we are subscribing to a stream we must close it to avoid memory leaks
  late final StreamSubscription<User?> _userStreamSubscription;

  AuthenticationBloc()
      : super(const _AuthenticationInitialState(status: AuthenticationStatus.loggedOut)) {
    // we must register a user change event handler before emitting the event
    on<_UserChangeEvent>(_userChangeEmitter);

    // listening to the changes to user stream
    _userStreamSubscription = user.listen((user) => add(_UserChangeEvent(user: user)));

    // registering event handlers
    on<AuthenticateWithGoogleEvent>(_onAuthenticateWithGoogle);
    on<AuthenticateWithEmailPassword>(_onAuthenticateWithEmailPassword);
    on<SignOutEvent>(_onSignOut);
    on<SignUpWithEmailAndPassword>(_onSignUpWithEmailAndPassword);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  // ? Sign In with Google Auth Provider
  FutureOr<void> _onAuthenticateWithGoogle(
      AuthenticateWithGoogleEvent event, Emitter<AuthenticationState> emit) async {
    // Tell the application that we have started initializing the state
    emit(const _AuthenticationStateUpdate(status: AuthenticationStatus.authenticating));

    // calling the authWithGoogle intermediary api call that then communicates
    // with firebase to provide the authentication
    try {
      UserCredential userCredential = await authWithGoogle();

      emit(_AuthenticationStateUpdate(
          status: AuthenticationStatus.loggedIn, user: userCredential.user));

      // incase of error store the message
      // will display the message on the
    } on FirebaseAuthException catch (e) {
      emit(_AuthenticationStateUpdate(status: AuthenticationStatus.error, exception: e));
    }
  }

  // ? ---------- Sign Up using email and password ---------- //
  FutureOr<void> _onAuthenticateWithEmailPassword(
      AuthenticateWithEmailPassword event, Emitter<AuthenticationState> emit) async {
    // Tell the application that we have started initializing the state
    emit(const _AuthenticationStateUpdate(status: AuthenticationStatus.authenticating));

    try {
      // using the intermediary api call
      final UserCredential userCredential =
          await signInWithEmailPassword(event.email, event.password);

      // emit the state with the user obtained
      emit(
        _AuthenticationStateUpdate(
          status: AuthenticationStatus.loggedIn,
          user: userCredential.user,
        ),
      );
    } on FirebaseAuthException catch (e) {
      // incase of error
      emit(_AuthenticationStateUpdate(status: AuthenticationStatus.error, exception: e));
    }
  }

  // ? User Sign Up
  FutureOr<void> _onSignUpWithEmailAndPassword(
      SignUpWithEmailAndPassword event, Emitter<AuthenticationState> emit) async {
    // Tell the application that we have started initializing the state
    emit(const _AuthenticationStateUpdate(status: AuthenticationStatus.authenticating));

    try {
      // Formatting the display name
      String firstName = event.firstName.trim();
      String lastName = event.lastName.trim();

      final firstUpper = firstName.substring(0, 1).toUpperCase();
      firstName = firstName.toLowerCase().replaceFirst(RegExp(r'[a-z]{0,1}'), firstUpper);

      final lastUpper = lastName.substring(0, 1).toUpperCase();
      lastName = lastName.toLowerCase().replaceFirst(RegExp(r'[a-z]{0,1}'), lastUpper);

      final String displayName = '$firstName $lastName';

      // creating a user with the provided data
      // using the intermediary API call

      // create the user
      await signUpWithEmailPassword(displayName, event.email, event.password);

      // sign in with the user
      final userCredential = await signInWithEmailPassword(event.email, event.password);

      // emit the state
      emit(_AuthenticationStateUpdate(
          status: AuthenticationStatus.loggedIn, user: userCredential.user));

      // incase of error
    } on FirebaseAuthException catch (e) {
      emit(_AuthenticationStateUpdate(status: AuthenticationStatus.error, exception: e));
    }
  }

  // ? Sign Out of firebase
  FutureOr<void> _onSignOut(SignOutEvent event, Emitter<AuthenticationState> emit) {
    // Using the intermediary Api
    signOut();

    // emitting the state
    emit(const _AuthenticationStateUpdate(status: AuthenticationStatus.loggedOut));
  }

  // ? Forgot Password Event Handler
  FutureOr<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthenticationState> emit) async {
    // Tell the application that we have started initializing the state
    emit(const _AuthenticationStateUpdate(status: AuthenticationStatus.authenticating));

    try {
      // intermediary call
      await resetPassword(event.email);

      // telling application to inform the user that an email has been sent
      // for their password reset
      emit(const _AuthenticationStateUpdate(status: AuthenticationStatus.resetPassword));

      // incase of error
    } on FirebaseException catch (e) {
      emit(_AuthenticationStateUpdate(status: AuthenticationStatus.error, exception: e));
    }
  }

  // ? Listening to the user changes from the firebase and emitting state
  FutureOr<void> _userChangeEmitter(
      _UserChangeEvent event, Emitter<AuthenticationState> emit) {
    // Setting the user status based on whether the user is null
    final status =
        event.user == null ? AuthenticationStatus.loggedOut : AuthenticationStatus.loggedIn;

    // emitting the status based on the user state
    emit(_AuthenticationStateUpdate(status: status, user: event.user));
  }

  // on authentication bloc close
  @override
  Future<void> close() {
    // close all the streams too
    _userStreamSubscription.cancel();

    return super.close();
  }
}
