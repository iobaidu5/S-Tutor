import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../feeds/progress.dart';
import '../models/tutormodel.dart';
import "package:flutter/material.dart";
import '../models/user.dart';
import '../loginpages/login_page_tutor.dart';
import 'package:google_fonts/google_fonts.dart';
//import '../widgets/progress.dart';

class MoreInfo extends StatefulWidget {
  final String profileId;

  MoreInfo({
    this.profileId,
  });
  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  @override

////
  ///
  buildClass() {
    return FutureBuilder(
      future: tutorRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserTutor user = UserTutor.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.0),
                child: Text("CLASS: ${user.classlevel},",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  ///
  buildSub() {
    return FutureBuilder(
      future: tutorRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserTutor user = UserTutor.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 4.0),
                  child: ListTile(
                    title: Text("SUBJECTS: ${user.subjects},",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        )),
                  )),
            ],
          ),
        );
      },
    );
  }

////
  ///
  buildstuPreferred() {
    return FutureBuilder(
      future: tutorRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserTutor user = UserTutor.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.0),
                child: Text("Location: ${user.location}",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  ///
  buildSalary() {
    return FutureBuilder(
      future: tutorRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserTutor user = UserTutor.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.0),
                child: Text("SALARY: ${user.salary},",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  ///
  buildPhone() {
    return FutureBuilder(
      future: tutorRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserTutor user = UserTutor.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.0),
                child: Text("PHONE: ${user.phone},",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  ///
  buildTime() {
    return FutureBuilder(
      future: tutorRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserTutor user = UserTutor.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.0),
                child: Text("AVAILIBILTY TIME: ${user.availabilitytime},",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  buildemail() {
    return FutureBuilder(
      future: tutorRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserTutor user = UserTutor.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.0),
                child: Text("EMAIL: ${user.email},",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            backgroundColor: Colors.indigo[500],
            title: new Text("Tutor Detail", style: GoogleFonts.aclonica())),
        body: Container(
          //         decoration: BoxDecoration(
          //   gradient: LinearGradient(colors: [
          //     Colors.indigo[400],
          //     Colors.lightBlueAccent,
          //   ]),
          // ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 80),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.indigo[400],
                      Colors.lightBlueAccent,
                    ]),
                    //  color: Colors.orangeAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 130),
                    //buildname(),
                    buildClass(),
                    buildTime(),
                    buildstuPreferred(),

                    buildSalary(),

                    buildPhone(),
                    //  buildemail(),
                    buildSub(),
                    SizedBox(height: 100),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
