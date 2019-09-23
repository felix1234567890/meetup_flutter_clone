import 'package:flutter/material.dart';
import 'package:meetup/src/models/forms.dart';
import 'package:meetup/src/screens/meetup_home_screen.dart';
import 'package:meetup/src/screens/register_screen.dart';
import 'package:meetup/src/services/auth_api_service.dart';
import 'package:meetup/src/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/login';
  final AuthApiService authApi = AuthApiService();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();
  LoginFormData _loginData = LoginFormData();
  bool _autovalidate = false;
  BuildContext _scaffoldContext;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  initState() {
    super.initState();
  }

  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    widget.authApi.login(_loginData).then((data) {
      Navigator.pushNamed(context, MeetupHomeScreen.route);
    }).catchError((res) {
      Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
        content: Text(res['errors']['message']),
      ));
    });
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  Widget _buildLinks() {
    return Padding(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RegisterScreen.route),
            child: Text(
              'Not registered yet.Register now',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, MeetupHomeScreen.route),
            child: Text(
              'Continue to Home Page',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(builder: (context) {
          _scaffoldContext = context;
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'Login And Explore',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                        key: _emailKey,
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(hintText: 'Email Address'),
                        onSaved: (value) => _loginData.email = value,
                        validator: composeValidators('email', [
                          requiredValidator,
                          minLengthValidator,
                          emailValidator
                        ])),
                    TextFormField(
                        key: _passwordKey,
                        obscureText: true,
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(hintText: 'Password'),
                        onSaved: (value) => _loginData.password = value,
                        validator: composeValidators('password', [
                          requiredValidator,
                          minLengthValidator,
                        ])),
                    _buildLinks(),
                    Container(
                        alignment: Alignment(-1.0, 0.0),
                        margin: EdgeInsets.only(top: 10.0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          child: const Text('Submit'),
                          onPressed: () {
                            _submit();
                          },
                        ))
                  ],
                ),
              ));
        }),
        appBar: AppBar(title: Text('Login')));
  }
}
