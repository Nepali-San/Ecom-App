import 'package:flutter/material.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false,
  };

  AuthMode _authMode = AuthMode.Login;

  final TextEditingController _passwordTextController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
      image: AssetImage("images/background_auth.jpg"),
    );
  }

  Widget _buildEmailTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['email'] = value.trim();
      },
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
    );
  }

  Widget _buildPasswordTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      controller: _passwordTextController,
      onSaved: (String value) {
        _formData['password'] = value;
      },
      validator: (String value) {
        if (value.isEmpty && value.length < 6) {
          return "Invalid password !!!";
        }
      },
    );
  }

  Widget _buildConfirmPasswordTextfield() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: "Confirm Password",
          filled: true,
          fillColor: Colors.white,
        ),
        obscureText: true,
        validator: (String value) {
          if (value != _passwordTextController.text) {
            return "password do not match!!!";
          }
        });
  }

  SwitchListTile _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        _formData['acceptTerms'] = value;
      },
      title: Text("Accept Terms"),
    );
  }

  void _buildSubmitform(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }

    _formKey.currentState.save();

    Map<String, dynamic> successInfo;

    successInfo = await authenticate(
      _formData['email'],
      _formData['password'],
      _authMode,
    );

    if (successInfo['success']) {
      // Navigator.pushReplacementNamed(context, "/");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("An Error occured !!!"),
            content: Text(successInfo['message']),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text(_authMode == AuthMode.Login ? "Login" : "Sign Up"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextfield(),
                    SizedBox(height: 10.0),
                    _buildPasswordTextfield(),
                    SizedBox(height: 10.0),
                    _authMode == AuthMode.Signup
                        ? _buildConfirmPasswordTextfield()
                        : Container(),
                    SizedBox(height: 10.0),
                    _buildAcceptSwitch(),
                    SizedBox(height: 10.0),
                    FlatButton(
                      child: Text(
                          "Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}"),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.Signup
                              : AuthMode.Login;
                        });
                      },
                    ),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(_authMode == AuthMode.Login
                                    ? "Login"
                                    : "Sign Up"),
                                onPressed: () =>
                                    _buildSubmitform(model.authenticate),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
