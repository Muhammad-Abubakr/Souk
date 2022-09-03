import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/authentication_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Form Global Key
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  // Text Field Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).size.width * (kIsWeb || isLandscape ? 0.25 : 0.15),
          vertical: 40,
        ),
        child: Column(
          children: [
            Form(
              key: _form,
              child: Column(
                children: [
                  Text(
                    'Souk',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontFamily: 'flix',
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Email field cannot be empty.'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter your password.' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context
                      .read<AuthenticationBloc>()
                      .add(ForgotPasswordEvent(email: _emailController.text.trim())),
                  child: const Text('Forgot Password ?'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      context.read<AuthenticationBloc>().add(AuthenticateWithEmailPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ));
                    }
                  },
                  style: TextButton.styleFrom(
                    elevation: 4,
                  ),
                  child: const Text('SIGN IN'),
                ),
              ],
            ),
            const Divider(height: 60),
            Text(
              "Or else",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  context.read<AuthenticationBloc>().add(AuthenticateWithGoogleEvent()),
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 6)),
                fixedSize: MaterialStateProperty.all(const Size.fromWidth(200)),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Continue with Google",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Image(
                      isAntiAlias: true,
                      image: Image.asset("lib/assets/images/google_G_logo.png").image,
                      fit: BoxFit.scaleDown,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
