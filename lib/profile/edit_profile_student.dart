import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import '../models/user.dart';
import '../loginpages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
//import '../widgets/progress.dart';

class EditProfileStudent extends StatefulWidget {
  final String currentUserId;

  EditProfileStudent({this.currentUserId});

  @override
  _EditProfileStudentState createState() => _EditProfileStudentState();
}

class _EditProfileStudentState extends State<EditProfileStudent> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController eduController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

///////////////

  bool isLoading = false;
  User user;
  bool _displayNameValid = true;
  bool _bioValid = true;
  bool _eduValid = true;
  bool _cnicValid = true;
  bool _categoryValid = true;
  bool _phoneNumberValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc =
        await studentRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    eduController.text = user.edustatus;
    cnicController.text = user.cnic;

    setState(() {
      isLoading = false;
    });
  }

  Column buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Phone Number",
              style: TextStyle(color: Colors.white),
            )),
        TextField(
          controller: phoneNumberController,
          decoration: InputDecoration(
            hintText: "enter phone number",
            errorText: _phoneNumberValid ? null : "phone too short",
          ),
        )
      ],
    );
  }

////
  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.white),
            )),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "bio",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio too long",
          ),
        )
      ],
    );
  }

  Column buildedu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Education Status",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextField(
          controller: eduController,
          decoration: InputDecoration(
            hintText: "Update Education status",
            errorText: _eduValid ? null : "edu too long",
          ),
        )
      ],
    );
  }

  Column buildcnicField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "cnic",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextField(
          controller: cnicController,
          decoration: InputDecoration(
            hintText: "Update cnic",
            errorText: _cnicValid ? null : "cnic too long",
          ),
        )
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;

      eduController.text.trim().length > 100
          ? _eduValid = false
          : _eduValid = true;

      cnicController.text.trim().length > 100
          ? _cnicValid = false
          : _cnicValid = true;
    });

    if (_displayNameValid && _bioValid) {
      studentRef.document(widget.currentUserId).updateData({
        "displayName": displayNameController.text,
        "bio": bioController.text,
        "edustatus": eduController.text,
        "cnic": cnicController.text,
        "phoneNumber": phoneNumberController.text
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Container circularProgress() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.purple),
        ));
  }

  Container linearProgress() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.purple),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.indigo[500],
        centerTitle: true,
        title: Text("Edit Profile", style: GoogleFonts.aclonica()),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "S_Tutor",
                        style: new TextStyle(
                            fontSize: 43,
                            color: Colors.indigo[500],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Form(
                            child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                            buildedu(),
                            buildcnicField(),
                            buildPhoneField(),
                            SizedBox(height: 19),
                            RaisedButton(
                              onPressed: updateProfileData,
                              child: Text(
                                "Update Profile",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: FlatButton.icon(
                                onPressed: logout,
                                icon: Icon(Icons.cancel, color: Colors.red),
                                label: Text(
                                  "Logout",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    )),
              ],
            ),
    );
  }
}
