import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Entrar',
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Criar conta',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => SignUpScren()),
              );
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (BuildContext context, Widget child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    validator: (text) {
                      if (text.isEmpty || !text.contains('@'))
                        return 'E-mail inválido';
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                    ),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return 'Senha inválida!';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Falha ao recuperar a senha!',
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          model.passwordRecovery(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Email enviado!',
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Esqueci minha senha',
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {}
                      model.signIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                      );
                    },
                  )
                ],
              ),
            );
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          'Falha ao entrar!',
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
