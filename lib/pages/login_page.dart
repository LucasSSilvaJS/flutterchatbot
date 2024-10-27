import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../appbar.dart';
import '../input.dart';
import '../scrollable_column.dart';

class LoginPage extends StatefulWidget {
  const LoginPage() : super();
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMeChecked = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Login to your account"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Form(
          key: _formKey,
          child: ScrollableColumn(
            children: [
              CustomInputField(
                keyboardType: TextInputType.emailAddress,
                hintText: "Email",
                controller: _emailController,
                validator: (String? email) {
                  if (email == null) {
                    return null;
                  }
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email);
                  return emailValid ? null : "Email is not valid";
                },
              ),
              SizedBox(height: 24),
              CustomInputField(
                keyboardType: TextInputType.visiblePassword,
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
                validator: (String? password) {
                  if (password == null) {
                    return null;
                  }
                  if (password.length < 6) {
                    return "Password is too short";
                  }
                },
              ),
              SizedBox(height: 24),
              CustomCheckbox(
                labelText: "Remember me",
                value: _rememberMeChecked,
                onChanged: (checked) =>
                    setState(() => _rememberMeChecked = checked ?? false),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text("Login"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Tenta autenticar o usuário
                      UserCredential result = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      // Navega para a tela principal se o login for bem-sucedido
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/main', (_) => false);
                    } on FirebaseAuthException catch (e) {
                      String message;

                      // Verifica o código de erro e atribui a mensagem apropriada
                      switch (e.code) {
                        case 'invalid-email':
                          message = 'O endereço de e-mail está malformado.';
                          break;
                        case 'user-disabled':
                          message = 'Este usuário foi desativado.';
                          break;
                        case 'user-not-found':
                          message =
                              'Nenhum usuário correspondente ao e-mail informado.';
                          break;
                        case 'wrong-password':
                          message = 'A senha informada é incorreta.';
                          break;
                        default:
                          message = 'Ocorreu um erro ao tentar efetuar login.';
                      }

                      // Exibe um alerta com a mensagem de erro
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Erro de Login'),
                          content: Text(message),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Don't have an account",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () =>
                        {Navigator.of(context).pushNamed("/register")},
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
