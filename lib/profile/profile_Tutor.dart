import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../feeds/activity_feed.dart';
import '../feeds/feeds.dart';
import '../feeds/progress.dart';
import '../loginpages/login_page_tutor.dart' as tutor;
import '../loginpages/login_page_tutor.dart';
import '../models/tutormodel.dart';

import '../profile/edit_profile.dart';
import '../loginpages/login_page.dart';

import '../drawerpages/page2.dart';
import '../drawerpages/page3.dart';
import '../profile/post.dart';

import '../profile/profile_student.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'moreinfo.dart';

//import 'login.dart';
final DateTime timestamp = DateTime.now();

class TutorProfile extends StatefulWidget {
  final String profileTutorId;

  TutorProfile({this.profileTutorId});
  @override
  _TutorProfileState createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  final String currentUserTutorId = currentUserTutor?.tid;

  File _image;
  String postOrientation = "grid";
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  UserTutor user;
  UserProfile profileId;

  @override
  void initState() {
    super.initState();

    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .document(widget.profileTutorId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      isLoading = false;
      postCount = snapshot.documents.length;
      posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    }
    return Column(
      children: posts,
    );
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .document(widget.profileTutorId)
        .collection('userFollowers')
        .document(currentUserStudent.sid)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .document(widget.profileTutorId)
        .collection('userFollowers')
        .getDocuments();
    setState(() {
      followerCount = snapshot.documents.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRefStu
        .document(widget.profileTutorId)
        .collection('userFollowingStu')
        .getDocuments();
    setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid'
              ? Theme.of(this.context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == 'list'
              ? Theme.of(this.context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  Container buildButtonMore({String text, Function function}) {
    return Container(
      padding: const EdgeInsets.only(
          // top: 10.0,
          // bottom: 10.0,
          left: 0.0,
          right: 0.0),
      child: Column(
        children: <Widget>[
          RaisedButton(
              color: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 40.0, right: 30.0),
                child: Text(
                  'More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
              onPressed: () => Navigator.push(
                  this.context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MoreInfo(profileId: widget.profileTutorId)))),
        ],
      ),
    );
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

  Widget _buildPostHeading() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Posts',
            style: GoogleFonts.aclonica(
              textStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void editProfile() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditProfile(currentUserTutorId: currentUserTutorId)));
    }

    Container buildButton({String text, Function function}) {
      return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: FlatButton(
          onPressed: function,
          child: Container(
            width: 150.0,
            height: 40.0,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 8.0, left: 30.0, right: 30.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isFollowing ? Colors.black45 : Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isFollowing ? Colors.white : Colors.lightBlue,
              border: Border.all(
                color: isFollowing ? Colors.black45 : Colors.lightBlue,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      );
    }

    buildProfileButton() {
      // viewing your own profile - should show edit profile button
      bool isProfileOwner = currentUserTutorId == widget.profileTutorId;
      if (isProfileOwner) {
        return buildButton(text: "Edit Profile", function: editProfile);
      } else {
        return Text("button");
      }
    }

    GestureDetector buildCountColumn(String label, int count) {
      return GestureDetector(
        onTap: () => Navigator.push(
          this.context,
          MaterialPageRoute(
            builder: (context) => TutorProfile(
              profileTutorId: user.tid,
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

    handleUnfollowUser() {
      setState(() {
        isFollowing = false;
      });
      // remove follower
      followersRef
          .document((widget.profileTutorId))
          .collection('userFollowers')
          .document(currentUserStudent.sid)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
      // remove following
      followingRef
          .document(currentUserStudent.sid)
          .collection('userFollowing')
          .document(widget.profileTutorId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
      // delete activity feed item for them
      activityFeedRef
          .document(widget.profileTutorId)
          .collection('feedItems')
          .document(currentUserStudent.sid)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }

    handleFollowUser() {
      setState(() {
        isFollowing = true;
      });
      // Make auth user follower of THAT user (update THEIR followers collection)
      followersRef
          .document(widget.profileTutorId)
          .collection('userFollowers')
          .document(currentUserStudent.sid)
          .setData({});
      // Put THAT user on YOUR following collection (update your following collection)

      followingRef
          .document(currentUserStudent.sid)
          .collection('userFollowing')
          .document(widget.profileTutorId)
          .setData({});

      // add activity feed item for that user to notify about new follower (us)
      activityFeedRef
          .document(widget.profileTutorId)
          .collection('feedItems')
          .document(currentUserStudent.sid)
          .setData({
        "type": "follow",
        "ownerId": widget.profileTutorId,
        "edustatus": currentUserStudent.edustatus,
        "userId": currentUserStudent.sid,
        "userProfileImg": currentUserStudent.photoUrl,
        "timestamp": timestamp,
        "displayName": currentUserStudent.displayName,
      });
    }

    buildAllButtons() {
      // viewing your own profile - should show edit profile button
      bool isProfileOwner = currentUserTutorId == widget.profileTutorId;
      if (isProfileOwner) {
        return buildButton(
          text: "Edit Profile",
          function: editProfile,
        );
      } else if (isFollowing) {
        return buildButton(
          text: "Cancel",
          function: handleUnfollowUser,
        );
      } else if (!isFollowing) {
        return buildButton(
          text: "Register",
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

    logout() async {
      await tutor.googleSignIn.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPageTutor()));
    }

    // Widget buildedu() {
    //   return FutureBuilder(
    //       future: tutorRef.document(widget.profileTutorId).get(),
    //       builder: (context, snapshot) {
    //         if (!snapshot.hasData) {
    //           return circularProgress();
    //         }
    //         UserTutor user = UserTutor.fromDocument(snapshot.data);
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
        future: tutorRef.document(widget.profileTutorId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          UserTutor user = UserTutor.fromDocument(snapshot.data);
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
                        buildCountColumn(
                            "Request for registration", followerCount),
                        buildCountColumn("Registered Students", followingCount),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //  buildProfileButton(),

                        buildAllButtons(),
                        //       SizedBox(height:30),
                        buildButtonMore(),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildAbout(),
                    Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          user.bio,
                          textAlign: TextAlign.center,
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
                "${currentUserTutor.displayName}",
                style: GoogleFonts.aclonica(
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ),
              accountEmail: new Text(
                "${currentUserTutor.email}",
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
                    CachedNetworkImageProvider(currentUserTutor.photoUrl),
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
        future: tutorRef.document(widget.profileTutorId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          UserTutor user = UserTutor.fromDocument(snapshot.data);
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
        future: tutorRef.document(widget.profileTutorId).get(),
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
      ),
      // drawer: _buildDrawer(context),

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
                      //buildedu(),
                      buildBio(),
                      _buildSeparator(),
                      SizedBox(height: screenSize.height / 29.4),
                      _buildPostHeading(),
                      SizedBox(height: 1),
                      buildProfilePosts(),
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
