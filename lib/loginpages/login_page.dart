import 'package:cloud_firestore/cloud_firestore.dart';
import '../feeds/activity_feed.dart';

import '../feeds/feeds.dart';
import '../feeds/stu_activity_feed.dart';
import '../feeds/timeline.dart';
import '../models/user.dart';
import '../profile/profile_Tutor.dart';
import '../feeds/search.dart';
import '../profile/profile_student.dart';
import '../profile/upload.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import '../loginpages/student_sign.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../services/firebase_auth.dart';
//import '../student_sign.dart';
import 'package:flutter/material.dart';
//import '../primary_button.dart';
//import '../services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../afterlogin.dart';
import 'login_page_tutor.dart';

//after
// final DateTime timestamp = DateTime.now();
final GoogleSignIn googleSignIn = GoogleSignIn();
final DateTime timestamp = DateTime.now();

final studentRef = Firestore.instance.collection('students');

User currentUserStudent;
String edustatus = "Student";

// final postsRef = Firestore.instance.collection('posts');
// final commentsRef = Firestore.instance.collection('comments');
//final StorageReference storageRef = FirebaseStorage.instance.ref();
final activityFeedRefStu = Firestore.instance.collection('Stufeed');
final followersRefStu = Firestore.instance.collection('Stufollowers');
final followingRefStu = Firestore.instance.collection('Stufollowing');

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  bool isAuth = false;
  String _email;
  String _password;

  PageController pageController;
  int pageIndex = 0;
  String formkey;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await studentRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      // final edustatus = await Navigator.push(
      //     context, MaterialPageRoute(builder: (context) =>AfterLogin()));
      // final edustatus = await Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => FormScreen()));

//       final cnic= await Navigator.push(
//       context, MaterialPageRoute(builder: (context) => FormScreen()));

//  final phoneNumber= await Navigator.push(
//       context, MaterialPageRoute(builder: (context) => FormScreen()));
// 3) get username from create account, use it to make new user document in users collection
      studentRef.document(user.id).setData({
        "id": user.id,
        "edustatus": edustatus,

        "timestamp": timestamp,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "cnic": "",
        "phoneNumber": "",

        //"category":"",
        //"classlevel":"",
        //"subjects":"",
        //"availabilitytime":"",
//"studentpreferred":"",
//"salary":"",

        // "timestamp": timestamp
      });
      // make new user their own follower (to include their posts in their timeline)

      doc = await studentRef.document(user.id).get();
    }

    currentUserStudent = User.fromDocument(doc);
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
          child: new TextFormField(
        key: new Key('email'),
        decoration: new InputDecoration(
            labelText: 'Email', prefixIcon: Icon(Icons.email)),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val,
      )),
      padded(
          child: new TextFormField(
        key: new Key('password'),
        decoration: new InputDecoration(
            labelText: 'Password', prefixIcon: Icon(Icons.enhanced_encryption)),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      )),
      RaisedButton(
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, bottom: 15.0, left: 65.0, right: 65.0),
          child: Text(
            'Lets Start',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        onPressed: () {},
      ),
    ];
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
        body: PageView(
          children: <Widget>[
            Feeds(),
            UserProfile(profileId: currentUserStudent?.sid),
            Search(),
            ActivityFeedStu(),
            RaisedButton(
              child: Text('Logout'),
              onPressed: logout,
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 35.0,
              ),
              title: Text('my profile'),
            ),
            // BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text('Graph'),),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search Tutor'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              title: Text('Notifications'),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.autorenew),
              title: Text('logout'),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Scaffold buildUnAuthScreen() {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text("Student Login"),
            centerTitle: true,
          ),
          backgroundColor: Colors.grey[300],
          body: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,

            // mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 100,
              ),
              Container(
                margin: const EdgeInsets.only(top: 230.0, left: 40),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GoogleSignInButton(
                    onPressed: () => login(),

                    textStyle: GoogleFonts.aclonica(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo[500]),
                    ),
                    darkMode: false, // default: false
                  ),
                ),
              ),
            ],
          ));
    }

    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
  // }
}
