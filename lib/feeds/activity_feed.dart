import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../drawerpages/page2.dart';
import '../drawerpages/page3.dart';

import '../feeds/progress.dart';
import '../loginpages/login_page_tutor.dart';
import '../profile/post_screen.dart';
import '../profile/profile_student.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'feeds.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUserTutor.tid)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo[500],
        title: new Text("Notifications", style: GoogleFonts.aclonica()),
        centerTitle: true,
      ),

      // drawer: _buildDrawer(context),
      body: Container(
          child: FutureBuilder(
        future: getActivityFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String displayName;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;

  final Timestamp timestamp;

  ActivityFeedItem({
    this.displayName,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      displayName: doc['displayName'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: postId,
          userId: userId,
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == "like") {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaUrl),
                  ),
                ),
              )),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      activityItemText = "Interested in your post";
    } else if (type == 'follow') {
      activityItemText = "Requested";
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  profileId: userId,
                ),
              ),
            ),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: displayName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$activityItemText',
                    ),
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserProfile(
        profileId: profileId,
      ),
    ),
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
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
            ),
          ),
          accountEmail: new Text(
            "${currentUserTutor.email}",
            style: GoogleFonts.aclonica(
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
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
          // otherAccountsPictures: <Widget>[
          //   new CircleAvatar(
          //       backgroundColor: Colors.white, child: new Text('k'))
          // ],
        ),
        new ListTile(
            title: new Text(
              'Feeds',
              style: GoogleFonts.aclonica(
                textStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
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
                textStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
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
                textStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
              ),
            ),
            trailing: new Icon(Icons.android),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new NewPage2("About S_Tutor"),
              ));
            }),
        new ListTile(
            title: new Text(
              'Share',
              style: GoogleFonts.aclonica(
                textStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
              ),
            ),
            trailing: new Icon(Icons.share),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new NewPage3('Locations'),
              ));
            }),

        new ListTile(
          title: new Text(
            'Ratings',
            style: GoogleFonts.aclonica(
              textStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
            ),
          ),
          trailing: new Icon(Icons.star),
          onTap: logout,
        ),
        new ListTile(
          title: new Text(
            'Sign out',
            style: GoogleFonts.aclonica(
              textStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
            ),
          ),
          trailing: new Icon(Icons.close),
          onTap: logout,
        ),
      ],
    ),
  );
}

logout() {
  // tutor.googleSignIn.signOut();
}
