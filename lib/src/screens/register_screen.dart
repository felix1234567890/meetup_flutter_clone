import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetup/src/models/forms.dart';
import 'package:meetup/src/services/auth_api_service.dart';
import 'package:meetup/src/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  final AuthApiService auth = AuthApiService();
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // 1. Create GlobalKey for form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 2. Create autovalidate
  bool _autovalidate = false;
  BuildContext _scaffoldContext;
  // 3. Create instance of RegisterFormData
  RegisterFormData _registerData = RegisterFormData();
  _handleSuccess() {
    print('Success');
  }

  _handleError(res) {
    Scaffold.of(_scaffoldContext)
        .showSnackBar(SnackBar(content: Text(res['errors']['message'])));
  }

  // 4. Create Register function and print all of the data
  void _register() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      widget.auth
          .register(_registerData)
          .then(_handleSuccess())
          .catchError(_handleError);
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Register')),
        body: Builder(builder: (context) {
          _scaffoldContext = context;
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                // 5. Form Key
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTitle(),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                      // 6. Required Validator
                      validator: composeValidators('name', [requiredValidator]),
                      onSaved: (value) => _registerData.name = value,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Username',
                      ),
                      validator:
                          composeValidators('username', [requiredValidator]),
                      onSaved: (value) => _registerData.username = value,
                    ),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                        ),
                        validator: composeValidators(
                            'email', [requiredValidator, emailValidator]),
                        onSaved: (value) => _registerData.email = value,
                        keyboardType: TextInputType.emailAddress),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(
                          hintText: 'Avatar Url',
                        ),
                        validator:
                            composeValidators('avatar', [requiredValidator]),
                        onSaved: (value) => _registerData.avatar = value,
                        keyboardType: TextInputType.url),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      validator:
                          composeValidators('password', [requiredValidator]),
                      onSaved: (value) => _registerData.password = value,
                      obscureText: true,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Password Confirmation',
                      ),
                      validator: composeValidators(
                          'password confirmation', [requiredValidator]),
                      onSaved: (value) =>
                          _registerData.passwordConfirmation = value,
                      obscureText: true,
                    ),
                    _buildLinksSection(),
                    _buildSubmitBtn()
                  ],
                ),
              ));
        }));
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
        alignment: Alignment(-1.0, 0.0),
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          child: const Text('Submit'),
          onPressed: () {
            // 8. call register function and print data
            _register();
          },
        ));
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
            child: Text(
              'Already Registered? Login Now.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/meetups");
              },
              child: Text(
                'Continue to Home Page',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ))
        ],
      ),
    );
  }
}
