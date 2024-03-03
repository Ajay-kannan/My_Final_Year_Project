import 'package:flutter/material.dart';
import 'package:plantify/Provider/auth.dart';
import 'package:plantify/models/loginuser.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({super.key, this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  final AuthService _auth = AuthService();

  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      controller: _email,
      autofocus: false,
      validator: (value) {
        if (value != null) {
          if (value.contains('@') && value.endsWith('.com')) {
            return null;
          }
          return 'Enter a Valid Email Address';
        }
      },
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ), // Text color when typing
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        hintStyle: TextStyle(color: Color(0xff9e9e9f)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        prefixIcon: Icon(Icons.email),

        fillColor: Theme.of(context)
            .colorScheme
            .secondary, // Set background color here
        filled: true, // Set to true to enable background color
      ),
    );
    final passwordField = TextFormField(
        obscureText: _obscureText,
        controller: _password,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          if (value.trim().length < 8) {
            return 'Password must be at least 8 characters in length';
          }
          // Return null if the entered password is valid
          return null;
        },
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          hintStyle: TextStyle(color: Color(0xff9e9e9f)),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          prefixIcon: Icon(Icons.lock),
          fillColor: Theme.of(context)
              .colorScheme
              .secondary, // Set background color here
          filled: true, // Set to true to enable background color
        ));

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: Row(
          children: [
            const Text('Already have an account? '),
            const Text(
              'Log in',
              style: TextStyle(color: Color(0xff00a86b)),
            )
          ],
        ));

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            dynamic result = await _auth.registerEmailPassword(
                LoginUser(email: _email.text, password: _password.text));
            if (result.uid == null) {
              //null means unsuccessfull authentication
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code),
                    );
                  });
            }
          }
        },
        child: Text(
          "Register",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        color:   Color(0xff00a86b),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Text(
                    "Join Plantify Today 👳🏼",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                   Text(
                    "Create Your Account",
                    style: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 45.0),
                  emailField,
                  const SizedBox(height: 25.0),
                  passwordField,
                  const SizedBox(height: 25.0),
                  txtbutton,
                  const SizedBox(height: 35.0),
                  registerButton,
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
