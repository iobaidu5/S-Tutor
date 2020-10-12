import 'package:s_tutor/loginpages/login_page_tutor.dart';

import '../profile/profile_Tutor.dart';

import '../services/auth.dart';
import '../services/firebase_auth.dart';
//import '../services/root_page.dart';
import '../loginpages/student_sign.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../feeds/feeds.dart';
import 'login_page.dart';

// class AfterLogin extends StatelessWidget{
//   //AfterLogin({this.auth, this.onSignOut});
//  // final BaseAuth auth;
//  // final VoidCallback onSignOut;

//   @override
//   Widget build(BuildContext context) {

//     // void _signOut() async {
//     //   try {
//     //     await auth.signOut();
//     //     onSignOut();
//     //   } catch (e) {
//     //     print(e);
//     //   }

//     // }
//     return Scaffold(
//       appBar: AppBar(
//          actions: <Widget>[
//             // new FlatButton(

//             //     onPressed: _signOut,
//             //     child: new Text('create a new mail', style: new TextStyle(fontSize: 17.0, color: Colors.white))
//             // )
//           ],

//         backgroundColor: Colors.indigo[500],
//       ),
// body: Center(
//   child:Column(
// //crossAxisAlignment: CrossAxisAlignment.center,
// mainAxisAlignment: MainAxisAlignment.center,
//   children: <Widget>[

//              RaisedButton(
//                           color: Colors.lightBlue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 10.0,
//                                 bottom: 10.0,
//                                 left: 37.0,
//                                 right: 35.0),
//                             child: Text(
//                               'Student',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 19,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>  FormScreen()));

//                           },
//                         ),

//                         SizedBox(
//                           height:15,
//                         ),

//                         RaisedButton(
//                           color: Colors.lightBlue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 10.0,
//                                 bottom: 10.0,
//                                 left: 45.0,
//                                 right: 45.0),
//                             child: Text(
//                               'Tutor',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 19,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                             onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>TutorReg()));

//                           },
//                         ),

// RaisedButton(      child: Text(
//                               'SignOutFromGoogle',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 19,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),  onPressed: (){
//                               googleSignIn.signOut();
//             //  UserManagement().logOut();

//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                    // builder: (context) =>  RootPage(auth: new Auth())));
//                             builder: (context) => LoginPage()));

//               },),

//   ],
// ),

// ),
//     );
//   }
//     }

//aftercorreting

String username;
String cnic;
String phoneNumber;

class AfterLogin extends StatefulWidget {
  @override
  _AfterLoginState createState() => _AfterLoginState();
}

class _AfterLoginState extends State<AfterLogin> {
  int _currentIndex = 0;
// final List<Widget> _children=
// [
//   Feeds(),
//    UserProfile(),
// ];
  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // void _signOut() async {
    //   try {
    //     await auth.signOut();
    //     onSignOut();
    //   } catch (e) {
    //     print(e);
    //   }

    // }
    return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: onTappedBar,
//         currentIndex: _currentIndex,

//         items: [
// BottomNavigationBarItem(icon:
// Icon(Icons.home),
// title: Text('home'),

// ),
// BottomNavigationBarItem(icon:
// Icon(Icons.person),
// title: Text('profile'),

// )

//       ],),
      appBar: AppBar(
        actions: <Widget>[
          // new FlatButton(

          //     onPressed: _signOut,
          //     child: new Text('create a new mail', style: new TextStyle(fontSize: 17.0, color: Colors.white))
          // )
        ],
        backgroundColor: Colors.indigo[500],
      ),
//body:_children[_currentIndex],
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 37.0, right: 35.0),
                child: Text(
                  'Student',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              color: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 45.0, right: 45.0),
                child: Text(
                  'Tutor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPageTutor()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
