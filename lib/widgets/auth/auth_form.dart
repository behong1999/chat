import 'dart:io';

import 'package:chat/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;

  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
    File image,
    BuildContext context,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //* They allow widgets to change parents anywhere in your app without losing state,
  //* or they can be used to access information about another widget in a completely different part of the widget tree.
  //* An example of the first scenario might if you wanted to show the same widget on two different screens,
  //* but holding all the same state, you’d want to use a GlobalKey.
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _userImageFile;

  //! Retrieve Picked Image to Save into the Firebase Storage
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _checkSubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    //! Check if the user has uploaded the avatar
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick an Image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      //* Trigger onSaved function
      _formKey.currentState.save();
      widget.submitFn(
        //* trim is used to trim the whitespace
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        _userImageFile,
        context,
      );
      //Use those values to send out path request
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      //* ValueKey is used to identify each TextFormField uniquely
                      //* Not only that, the input won't be pushed to another text field when the number of TextFormField changes
                      key: ValueKey('email'),
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || value.contains('@') == false) {
                          return 'Please Return A Valid Email Address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    //*The username textformfield only shows in Sign Up stage
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Username must be at least 4 characters long.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password must be at least 8 characters long.';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        onPressed: _checkSubmit,
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create New Account'
                            : 'I Already Have An Account.'),
                      )
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
