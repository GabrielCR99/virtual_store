import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/user_model.dart';

class SignUpScren extends StatefulWidget {
  @override
  _SignUpScrenState createState() => _SignUpScrenState();
}

class _SignUpScrenState extends State<SignUpScren> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Criar conta',
        ),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  validator: (text) {
                    if (text.isEmpty) return 'Nome inválido!';
                  },
                  decoration: InputDecoration(
                    hintText: 'Nome completo',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (text) {
                    if (text.isEmpty || !text.contains('@'))
                      return 'E-mail inválido';
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
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Endereço',
                  ),
                  validator: (text) {
                    if (text.isEmpty) return 'Endereço inválido';
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      'Criar conta',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'address': _addressController.text,
                        };

                        model.signUp(
                          userData: userData,
                          password: _passwordController.text,
                          onSuccess: _onSuccess,
                          onFail: (errorMessage) {
                            _onFail(errorMessage);
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Usuário criado com sucesso!',
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail(String errorMessage) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          '$errorMessage',
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
