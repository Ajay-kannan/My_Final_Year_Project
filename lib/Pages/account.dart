import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plantify/models/userName.dart';

import '../Provider/auth.dart'; // Assuming this is your Auth Provider

import 'dart:math' as math;

import 'package:expandable/expandable.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  UserName _userData = new UserName(
      name: "user name",
      email: "example@gmail.com"); // Use late for later initialization
  final AuthService _auth = new AuthService();

  @override
  void initState() {
    super.initState();
    getUserData().then((userData) => setState(() => _userData = userData));
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildUserBody() {
      // Ensure _userData is not null before using its properties
      return _userData == null
          ? CircularProgressIndicator()
          : Container(
              color: Color(0xff181a20),
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    child: Image.asset(
                      "assets/person_acc.jpg", // Set your logo image here
                    ),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userData.name ?? 'No Username',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _userData.email ?? 'No Email',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
    }

    Widget SignOut() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
          elevation: 2.0,
          color: Color(0xff181a20),
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              await _auth.signOut();
              setState(() {
                _userData = new UserName(
                    name: "user name",
                    email: "example@gmail.com"); // Clear user data on logout
              });
            },
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Logout",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget ScanCard() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          elevation: 4,
          shadowColor: Colors.grey,
          color: Color(0xFF00a86b),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.qr_code_scanner, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  "Scan Plants, Get Remedies",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Your plant's health, in your hands",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/logogreen.png"),
          radius: 30.0,
          backgroundColor: Color(0xff181a20),
        ), // Your logo widget
        title: Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, // Aligns title to the center
        backgroundColor: Color(0xff181a20),
      ),
      backgroundColor: Color(0xff181a20),
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            _buildUserBody(),
            ScanCard(),
            Card1(),
            Card2(),
            SignOut()
          ],
        ),
      ),
    );
  }

  Future<UserName> getUserData() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user?.email == null) {
      return UserName(
          name: "name",
          email: "email"); // Provide default values if no user is logged in
    }

    final userRef = FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: user?.email);

    final docSnapshot = await userRef.get();

    if (!docSnapshot.docs.isEmpty) {
      final userData = docSnapshot.docs.first.data() as Map<String, dynamic>;
      return UserName(name: userData['userName'], email: userData['email']);
    } else {
      return UserName(
          name: "User name",
          email:
              "example@gmail.com"); // Handle case where user data is not found
    }
  }
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, qui officia deserunt mollit anim id est laborum.";

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Color(0xff181a20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                  iconColor: Colors.white,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.perm_contact_calendar_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            "About",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    )),
                collapsed: Text(""),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          loremIpsum,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Color(0xff181a20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                  iconColor: Colors.white,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.contact_support,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            "Help & Support",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    )),
                collapsed: Text(""),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          loremIpsum,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
