import 'package:flutter/material.dart';

import '../Provider/auth.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
        Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            await _auth.signOut();
          },
          child: Text(
            "Log out",
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
      ),
        ]
      ),
    );
  }
}


