import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../blocs/login_cubit/login_cubit.dart';
import '../utils/translate_keys.dart';
import 'navigation.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final loginCubit = LoginCubit();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: loginCubit,
        listener: (context, snapshot) {
          if (snapshot is LoginSuccess) {
            BotToast.closeAllLoading();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const NavPage()));
          } else if (snapshot is LoginFailed) {
            BotToast.closeAllLoading();
            BotToast.showText(
              text: snapshot.errorMessage,
              duration: const Duration(seconds: 3),
            );
          } else if (snapshot is LoginLoading) {
            BotToast.showLoading();
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Text(translate(Keys.welcome),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 6),
                    Text(translate(Keys.loginmessage),
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Image(
                            width: 250.0,
                            fit: BoxFit.fill,
                            image: AssetImage('assets/logo.png')),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate(Keys.enteremail);
                          }
                          if (!RegExp(
                                  r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
                              .hasMatch(value)) {
                            return translate(Keys.validemail);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: translate(Keys.emailaddress),
                          labelStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate(Keys.enterpassword);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: translate(Keys.password),
                          labelStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            loginCubit.loginUser(usernameController.value.text,
                                passwordController.value.text);
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(
                              maxWidth: double.infinity, minHeight: 50),
                          child: Text(
                            translate(Keys.loginbutton),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
