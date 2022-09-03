import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/login_form.dart';
import '../widgets/sign_up_form.dart';
import '../../app.dart';
import '../../logic/bloc/authentication_bloc.dart';
import '../../packages/firebase_api/firebase_auth_error_map.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int pageShown = 0;

  // PageView Controller
  final _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _showExitAlert(context),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.loggedIn:
              // Clear the Navigator Until we reach LoginScreen
              Navigator.of(context)
                  .popUntil((route) => route.settings.name == LoginScreen.routeName);

              //  Then push the App onto the Screen. Once the app has been
              //  rerendered because of the previous [pop]
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.of(context).popAndPushNamed(App.routeName);
              });
              break;

            case AuthenticationStatus.authenticating:
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (builderContext) => const Center(
                  child: CircularProgressIndicator(semanticsLabel: 'Authenticating the User'),
                ),
              );
              break;
            case AuthenticationStatus.error:
              // This will clear the Progress Indicator Dialog
              Navigator.of(context)
                  .popUntil((route) => route.settings.name == LoginScreen.routeName);

              // This will clear previous snackbars, if any
              ScaffoldMessenger.of(context).clearSnackBars();

              // Then show a new snack bar with the latest info/error
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                elevation: 0,
                backgroundColor: Theme.of(context).errorColor,
                duration: const Duration(seconds: 2),
                content: Text(
                  parseAuthError(state.exception!.code),
                  textAlign: TextAlign.center,
                ),
              ));
              break;

            case AuthenticationStatus.resetPassword:
              // This will clear the Progress Indicator Dialog
              Navigator.of(context)
                  .popUntil((route) => route.settings.name == LoginScreen.routeName);

              // This will clear previous snackbars, if any
              ScaffoldMessenger.of(context).clearSnackBars();

              // Then show a new snack bar with the latest info/error
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                duration: const Duration(seconds: 2),
                content: const Text(
                  'Check your inbox for an email to reset your password.',
                  textAlign: TextAlign.center,
                ),
              ));
              break;
            default:
              break;
          }
        },

        // ? View
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: PageView(
            onPageChanged: (pageNumber) => setState(() => pageShown = pageNumber),
            controller: _pageController,
            children: const [
              LoginForm(),
              SignUpForm(),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
              ? null
              : FloatingActionButton.extended(
                  elevation: 0,
                  focusElevation: 0,
                  disabledElevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  tooltip: 'Swipe horizontally to change screen',
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  backgroundColor: pageShown == 1
                      ? Theme.of(context).primaryColor.withAlpha(60)
                      : Colors.transparent,
                  onPressed: () => pageShown == 0
                      ? _pageController.nextPage(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn)
                      : _pageController.previousPage(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: pageShown == 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade50,
                        radius: 8,
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        backgroundColor: pageShown == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        radius: 8,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

Future<bool> _showExitAlert(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (builderContext) => AlertDialog(
      content: Text(
        "Do you really want to exit the application?",
        style: TextStyle(color: Colors.grey.shade600),
      ),
      actions: [
        TextButton(
            child: const Text('CANCEL'), onPressed: () => Navigator.of(context).pop(false)),
        ElevatedButton(
            child: const Text('EXIT'), onPressed: () => Navigator.of(context).pop(true)),
      ],
    ),
  ).then((value) => value);
}
