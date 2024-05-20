import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';
import 'package:user_tracking_flutter/blocs/auth/auth_bloc.dart';
import 'package:user_tracking_flutter/routes/routes.dart';
import 'package:user_tracking_flutter/utils/validator.dart';
import 'package:user_tracking_flutter/widgets/button_widget.dart';
import 'package:user_tracking_flutter/widgets/input_text_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with Validator {
  GlobalKey<FormState>? formKey;

  final Map<String, dynamic> fields = {};

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('UserTracking'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: Colors.deepPurple, shape: BoxShape.circle),
            child: const Icon(
              CupertinoIcons.person,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InputText(
                      label: 'Email',
                      validator: validateEmail,
                      onSaved: (value) {
                        setState(() {
                          fields['email'] = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputPassword(
                      label: 'Password',
                      validator: validatePassword,
                      onSaved: (value) {
                        setState(() {
                          fields['password'] = value;
                        });
                      },
                    )
                  ],
                ),
              )),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        onPressed: () {
                          if (formKey?.currentState?.validate() ?? false) {
                            formKey!.currentState!.save();
                            context.read<AuthBloc>().add(LoginEvent(
                                email: fields['email'],
                                password: fields['password']));
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Routemaster.of(context).push(Routes.register);
                        },
                        child: const Text('Create user'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
