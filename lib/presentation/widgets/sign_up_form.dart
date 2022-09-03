import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/authentication_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // Form Key for validation and Submission
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return SafeArea(
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal:
                MediaQuery.of(context).size.width * (kIsWeb || isLandscape ? 0.25 : 0.1),
            vertical: 80,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Souk',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'flix',
                      ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Registration Form',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black45,
                    ),
              ),
              const Divider(height: 60),

              // ? Personal Details
              _buildFormSection(
                  context,
                  [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        label: Text('First Name'),
                        helperText: 'Enter your first name here.',
                      ),
                      maxLength: 12,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your first name here.' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        label: Text('Last Name'),
                        helperText: 'Enter your last name here.',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your last name here.' : null,
                      maxLength: 12,
                      keyboardType: TextInputType.name,
                    ),
                  ],
                  "Personal Details"),

              // ? Personal Details
              _buildFormSection(
                  context,
                  [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        helperText: 'Provide your email here.',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty ? 'Provide your email here.' : null,
                      maxLength: 64,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Note: Additional Contact Details like contact number may be required when placing an order',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  "Contact Details"),

              // ? Account Details
              _buildFormSection(
                  context,
                  [
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                        helperMaxLines: 3,
                        errorMaxLines: 3,
                        helperText:
                            'A password must be greater than 6 characters & contain at least one alphabet and one number.',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty
                          ? 'A password must be greater than 6 characters & contain at least one alphabet and one number.'
                          : null,
                      maxLength: 64,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        label: Text('Confirm Password'),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty ||
                              _passwordController.text != _confirmPasswordController.text
                          ? 'Passwords do not match.'
                          : null,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ],
                  "Account Details"),

              // Sign Up Button
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        context.read<AuthenticationBloc>().add(SignUpWithEmailAndPassword(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ));
                      }
                    },
                    child: const Text('REGISTER'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFormSection(BuildContext context, List<Widget> fields, String header) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        header,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black54),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.04,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...fields,
          ],
        ),
      ),
    ],
  );
}
