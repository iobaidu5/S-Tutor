//import 'package:first_app/package';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String id;
  final db = Firestore.instance;
  String name;
  String edustatus = "Student";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username;
  String cnic;
  String phoneNumber;
  submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print('doneeee');

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, edustatus);
      });
    }
  }

  // Widget _buildedu() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //       labelText: 'Education Status',
  //       labelStyle: (TextStyle(color: Colors.white)),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
  //       contentPadding: EdgeInsets.all(3),
  //       prefixIcon: Icon(Icons.people, color: Colors.white),
  //       hintText: "Tutor or Student",
  //       hintStyle: TextStyle(color: Colors.white),
  //     ),
  //     maxLength: 15,
  //     validator: (String value) {
  //       if (value.isEmpty) {
  //         return 'Name is Required';
  //       }

  //       return null;
  //     },
  //     onSaved: (String value) {
  //       edustatus = value;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: Text(" Sign Up", style: GoogleFonts.aclonica()),
          backgroundColor: Colors.indigo[500],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.indigo[300],
              Colors.lightBlue,
            ]),
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "S_Tutor",
                      style: GoogleFonts.aclonica(
                          textStyle:
                              TextStyle(fontSize: 43, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Column(children: <Widget>[
                SizedBox(height: 100),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        //_buildedu(),
                        Padding(
                          padding: EdgeInsets.all(1),
                          child: RaisedButton(
                            padding: EdgeInsets.only(
                                left: 135, right: 135, bottom: 12, top: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.indigo[500],
                            child: Text(
                              'tHIS IS eDU',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: submit,
                          ),
                        ),
                      ],
                    )),
              ])
            ],
          ),
        ));
  }
}
//ending
