import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../feeds/activity_feed.dart';
import '../feeds/feeds.dart';

import '../loginpages/login_page_tutor.dart';

import '../loginpages/login_page.dart';
import '../models/user.dart';

import '../drawerpages/page2.dart';
import '../drawerpages/page3.dart';
import '../profile/edit_profile_student.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

final DateTime timestamp = DateTime.now();

class UserProfile extends StatefulWidget {
  final String profileId;

  UserProfile({this.profileId});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfile> {
  final String currentUserId = currentUserStudent?.sid;

  File _image;
  String postOrientation = "grid";
  bool isFollowingStu = false;

  int followerCountStu = 0;
  int followingCountStu = 0;

  User user;

  @override
  void initState() {
    super.initState();

    getStuFollowers();
    getStuFollowing();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRefStu
        .document(widget.profileId)
        .collection('userFollowersStu')
        .document(currentUserTutor.tid)
        .get();
    setState(() {
      isFollowingStu = doc.exists;
    });
  }

  getStuFollowers() async {
    QuerySnapshot snapshot = await followersRefStu
        .document(widget.profileId)
        .collection('userFollowersStu')
        .getDocuments();
    setState(() {
      followerCountStu = snapshot.documents.length;
    });
  }

  getStuFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(widget.profileId)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingCountStu = snapshot.documents.length;
    });
  }

  GestureDetector buildCountColumn(String label, int count) {
    return GestureDetector(
      onTap: () => Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (context) => UserProfile(
            profileId: user.sid,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            count.toString(),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          Container(
              margin: EdgeInsets.only(top: 4.0),
              child: Column(
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('_image : $_image');
    });
  }

  Future getImage1() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Widget _buildAbout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'About Me',
            style: GoogleFonts.aclonica(
              textStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: 400,
      height: 0.7,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    void editProfile() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditProfileStudent(currentUserId: currentUserId)));
    }

    Container buildButton({String text, Function function}) {
      return Container(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, left: 50.0, right: 10.0),
        child: FlatButton(
          onPressed: function,
          child: Container(
            width: 150.0,
            height: 42.0,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isFollowingStu ? Colors.black45 : Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isFollowingStu ? Colors.white : Colors.lightBlue,
              border: Border.all(
                color: isFollowingStu ? Colors.black45 : Colors.lightBlue,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      );
    }

    buildProfileButton() {
      // viewing your own profile - should show edit profile button
      bool isProfileOwnerStu = currentUserStudent.sid == widget.profileId;
      if (isProfileOwnerStu) {
        return buildButton(text: "Edit Profile", function: editProfile);
      } else {
        return Text("button");
      }
    }

    handleUnfollowUser() {
      setState(() {
        isFollowingStu = false;
      });
      // remove follower
      followersRefStu
          .document((widget.profileId))
          .collection('userFollowersStu')
          .document(currentUserTutor.tid)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
      // remove following
      followingRefStu
          .document(currentUserTutor.tid)
          .collection('userFollowingStu')
          .document(widget.profileId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
      // delete activity feed item for them
      activityFeedRefStu
          .document(widget.profileId)
          .collection('feedItemsStu')
          .document(currentUserTutor.tid)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }

    handleFollowUser() {
      setState(() {
        isFollowingStu = true;
      });
      // Make auth user follower of THAT user (update THEIR followers collection)
      followersRefStu
          .document(widget.profileId)
          .collection('userFollowersStu')
          .document(currentUserTutor.tid)
          .setData({});
      // Put THAT user on YOUR following collection (update your following collection)

      followingRefStu
          .document(currentUserTutor.tid)
          .collection('userFollowingStu')
          .document(widget.profileId)
          .setData({});
      // add activity feed item for that user to notify about new follower (us)
      activityFeedRefStu
          .document(widget.profileId)
          .collection('feedItemsStu')
          .document(currentUserTutor.tid)
          .setData({
        "type": "follow",
        "ownerId": widget.profileId,
        "edustatus": currentUserTutor.edustatus,
        "userId": currentUserTutor.tid,
        "userProfileImg": currentUserTutor.photoUrl,
        "timestamp": timestamp,
        "displayName": currentUserTutor.displayName,
      });
    }

    buildAllButtons() {
      // viewing your own profile - should show edit profile button
      bool isProfileOwnerStu = currentUserId == widget.profileId;
      if (isProfileOwnerStu) {
        return buildButton(
          text: "Edit Profile",
          function: editProfile,
        );
      } else if (isFollowingStu) {
        return buildButton(
          text: "Cancel",
          function: handleUnfollowUser,
        );
      } else if (!isFollowingStu) {
        return buildButton(
          text: "Accept Registration",
          function: handleFollowUser,
        );
      }
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

    // logout() async {
    //   await googleSignIn.signOut();
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    // }
    // Widget buildedu() {
    //   return FutureBuilder(
    //       future: studentRef.document(widget.profileId).get(),
    //       builder: (context, snapshot) {
    //         if (!snapshot.hasData) {
    //           return circularProgress();
    //         }
    //         User user = User.fromDocument(snapshot.data);
    //         return Padding(
    //           padding: EdgeInsets.all(2.0),
    //           child: Column(
    //             children: <Widget>[
    //               Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.only(top: 1.0),
    //                 child: Text(
    //                   user.edustatus,
    //                   style: TextStyle(
    //                     fontFamily: 'Spectral',
    //                     color: Colors.black,
    //                     fontSize: 17.0,
    //                     fontWeight: FontWeight.w300,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       });
    // }

    Widget buildBio() {
      return FutureBuilder(
        future: studentRef.document(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildCountColumn("Request accepted", followerCountStu),
                        buildCountColumn(
                            "Request sent to Tutors", followingCountStu),
                        //buildMore("more"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //    buildProfileButton(),

                        buildAllButtons(),
                        SizedBox(height: 30),
                        //   buildButtonMore(),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildAbout(),
                    Container(
                        // color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          user.bio,
                          textAlign: TextAlign.center,
                          // style: bioTextStyle,
                          // style: GoogleFonts.aclonica(textStyle: TextStyle(color:Colors.black,fontWeight:FontWeight.w100),

                          style: TextStyle(color: Colors.black45),
                        )),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _buildDrawer(BuildContext context) {
      return new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                "${currentUserStudent.displayName}",
                style: GoogleFonts.aclonica(
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ),
              accountEmail: new Text(
                "${currentUserStudent.email}",
                style: GoogleFonts.aclonica(
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo[500],
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(currentUserStudent.photoUrl),
                //  child: new Text('Kain'),
              ),
            ),
            new ListTile(
                title: new Text(
                  'Feeds',
                  style: GoogleFonts.aclonica(
                    textStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w100),
                  ),
                ),
                trailing: new Icon(Icons.favorite),
                onTap: () {
                  Navigator.of(context).pop();

                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Feeds(),
                  ));
                }),

            new ListTile(
                title: new Text(
                  'Notifications',
                  style: GoogleFonts.aclonica(
                    textStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w100),
                  ),
                ),
                trailing: new Icon(Icons.notifications),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new ActivityFeed(),
                  ));
                }),
            new Divider(),
            // Text("Communicate",style:TextStyle(color: Colors.black)),
            new ListTile(
                title: new Text(
                  'About App',
                  style: GoogleFonts.aclonica(
                    textStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w100),
                  ),
                ),
                trailing: new Icon(Icons.android),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new NewPage2("Certificates"),
                  ));
                }),
            new ListTile(
                title: new Text(
                  'Share',
                  style: GoogleFonts.aclonica(
                    textStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w100),
                  ),
                ),
                trailing: new Icon(Icons.share),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new NewPage3('Locations'),
                  ));
                }),

            new ListTile(
              title: new Text(
                'Ratings',
                style: GoogleFonts.aclonica(
                  textStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w100),
                ),
              ),
              trailing: new Icon(Icons.star),
              onTap: logout,
            ),
            new ListTile(
              title: new Text(
                'Sign out',
                style: GoogleFonts.aclonica(
                  textStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w100),
                ),
              ),
              trailing: new Icon(Icons.close),
              onTap: logout,
            ),
          ],
        ),
      );
    }

    buildimg() {
      return FutureBuilder(
        future: studentRef.document(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
              ],
            ),
          );
        },
      );
    }

    buildname() {
      return FutureBuilder(
        future: studentRef.document(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    user.displayName,
                    style: GoogleFonts.aclonica(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Profile", style: GoogleFonts.aclonica()),
        backgroundColor: Colors.indigo[500],
        actions: <Widget>[
          SizedBox(
            width: 17,
          )
        ],
      ),
      //  drawer: _buildDrawer(context),

      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenSize.height / 10.4),
                      buildimg(),
                      buildname(),
                      // buildedu(),
                      buildBio(),
                      _buildSeparator(),
                      SizedBox(height: screenSize.height / 29.4),
                      SizedBox(height: screenSize.height / 100.4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
