import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../loginpages/login_page_tutor.dart';
import '../models/tutormodel.dart';
import "package:flutter/material.dart";

import 'package:google_fonts/google_fonts.dart';
//import '../widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserTutorId;

  EditProfile({this.currentUserTutorId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController eduController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController categoryController = TextEditingController();
  TextEditingController classlevelController = TextEditingController();
  TextEditingController subjectsController = TextEditingController();

  TextEditingController availabilitytimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

///////////////

  bool isLoading = false;
  UserTutor user;
  bool _displayNameValid = true;
  bool _bioValid = true;
  bool _eduValid = true;
  bool _cnicValid = true;
  bool _categoryValid = true;
  bool _phoneNumberValid = true;

  bool _classlevelValid = true;

  bool _subjectsValid = true;

  bool _availabilitytimeValid = true;

  bool _location = true;

  bool _salaryValid = true;

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
        await tutorRef.document(widget.currentUserTutorId).get();
    user = UserTutor.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    eduController.text = user.edustatus;
    cnicController.text = user.cnic;

    categoryController.text = user.category;
    classlevelController.text = user.classlevel;
    subjectsController.text = user.subjects;
    phoneNumberController.text = user.phone;

    availabilitytimeController.text = user.availabilitytime;
    locationController.text = user.location as String;
    salaryController.text = user.salary;

    setState(() {
      isLoading = false;
    });
  }

  getUserLocation() async {
    LatLng _location;
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print(position);

    setState(() {
      _location = LatLng(position.latitude, position.longitude);
    });
    print(_location);
    return _location;
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

  Column buildAvailabiltyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              " Availablity Time",
              style: TextStyle(color: Colors.white),
            )),
        TextField(
          controller: availabilitytimeController,
          decoration: InputDecoration(
            hintText: "input if you are Tutor",
            errorText:
                _availabilitytimeValid ? null : "availabilitytime too short",
          ),
        )
      ],
    );
  }

  Column buildLocation() {
    return Column(
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            controller: locationController,
            decoration: InputDecoration(
              hintText: "Type Your Location",
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          width: 200.0,
          height: 100.0,
          alignment: Alignment.center,
          child: RaisedButton.icon(
            label: Text(
              "Use Current Location",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.blue,
            onPressed: getUserLocation,
            icon: Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Column buildClassLevelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Class Level",
              style: TextStyle(color: Colors.white),
            )),
        TextField(
          controller: classlevelController,
          decoration: InputDecoration(
            hintText: "input if you are Tutor",
            errorText: _classlevelValid ? null : "class level too short",
          ),
        )
      ],
    );
  }

  Column buildSalaryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Salary",
              style: TextStyle(color: Colors.white),
            )),
        TextField(
          controller: salaryController,
          decoration: InputDecoration(
            hintText: "input if you are Tutor",
            errorText: _salaryValid ? null : " Salary too short",
          ),
        )
      ],
    );
  }

  Column buildsubjectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Subjects",
              style: TextStyle(color: Colors.white),
            )),
        TextField(
          controller: subjectsController,
          decoration: InputDecoration(
            hintText: "input if you are Tutor",
            errorText: _subjectsValid ? null : "subjects too short",
          ),
        )
      ],
    );
  }

  Column buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Category(engMedium/urduMedium)",
              style: TextStyle(color: Colors.white),
            )),
        TextField(
          controller: categoryController,
          decoration: InputDecoration(
            hintText: "input if you are tutor",
            errorText: _categoryValid ? null : "category too short",
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

      subjectsController.text.trim().length > 100
          ? _subjectsValid = false
          : _subjectsValid = true;
      phoneNumberController.text.trim().length > 100
          ? _phoneNumberValid = false
          : _phoneNumberValid = true;

      salaryController.text.trim().length > 100
          ? _salaryValid = false
          : _salaryValid = true;

      availabilitytimeController.text.trim().length > 100
          ? _availabilitytimeValid = false
          : _availabilitytimeValid = true;

      classlevelController.text.trim().length > 100
          ? _classlevelValid = false
          : _classlevelValid = true;

      locationController.text.trim().length > 100
          ? _location = false
          : _location = true;

      categoryController.text.trim().length > 100
          ? _categoryValid = false
          : _categoryValid = true;
    });

    if (_displayNameValid && _bioValid) {
      tutorRef.document(widget.currentUserTutorId).updateData({
        "displayName": displayNameController.text,
        "bio": bioController.text,
        "edustatus": eduController.text,
        "cnic": cnicController.text,
        "category": categoryController.text,
        "classlevel": classlevelController.text,
        "subjects": subjectsController.text,
        "availabilitytime": availabilitytimeController.text,
        "location": locationController.text,
        "salary": salaryController.text,
        "phoneNumber": phoneNumberController.text
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPageTutor()));
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
                            buildCategoryField(),
                            buildAvailabiltyField(),
                            buildClassLevelField(),
                            buildLocation(),
                            buildSalaryField(),
                            buildsubjectField(),
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
