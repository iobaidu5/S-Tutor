import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_tutor/feeds/activity_feed.dart';
import 'package:s_tutor/models/tutormodel.dart';

import '../loginpages/login_page_tutor.dart';
import 'search.dart';
//import 'drawer.dart';

final GoogleSignInAccount currentUser = googleSignIn.currentUser;

class StudentFeed extends StatefulWidget {
  // final UserTutor currentUserTutor;

  // Feeds({this.currentUserTutor});
  @override
  _StudentFeedState createState() => _StudentFeedState();
}

// ignore: camel_case_types
class _StudentFeedState extends State<StudentFeed>
    with AutomaticKeepAliveClientMixin<StudentFeed> {
  String search;
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  bool get wantKeepAlive => true;

  clearSearch() {
    searchController.clear();
  }

  Widget buildNoContent() {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: ProfileHeader(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Tutor",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Search(search: search)));
                      },
                    ),
                  ),
                ),
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              ),

              SizedBox(
                height: 16,
              ),

              //Container for heading
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Announcements",
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    textStyle: TextStyle(color: Colors.grey[800]),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              //Container for sub heading
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Select catorgary to find Your Class",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    textStyle: TextStyle(color: Colors.grey[500]),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              //Container for catorgaries
              Container(
                height: 300,
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width - 32,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 0.4,
                                spreadRadius: 0.3)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: SvgPicture.asset(
                              "assets/images/type${index + 1}.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Education",
                                  style: GoogleFonts.roboto(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      textStyle:
                                          TextStyle(color: Colors.grey[900])),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Select catoary to find Tutor ",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  textStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  shrinkWrap: true,
                ),
              ),

              SizedBox(
                height: 16,
              ),
              //Container for new feed heading
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Tutor's For You", // Pre Nes
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                      ),
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Tops Tutors Teasers",
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),

              Container(
                height: 300,
                padding: EdgeInsets.only(top: 16.0),
                child: Scaffold(
                  body: StreamBuilder(
                      stream:
                          Firestore.instance.collection("Tutors").snapshots(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot tutor =
                                snapshot.data.documents[index];
                            return Container(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: ClipOval(
                                    child: Image.network(tutor['photoUrl']),
                                  ),
                                  radius: 30,
                                ),
                                title: Text(
                                  tutor['displayName'],
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      textStyle:
                                          TextStyle(color: Colors.grey[800])),
                                ),
                                subtitle: Text(
                                  "Hi, I am certified Tutor available",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      textStyle: TextStyle(color: Colors.grey)),
                                ),
                                trailing: Text(
                                  "Hire Me!",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      textStyle:
                                          TextStyle(color: Colors.lightBlue)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                              ),
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        spreadRadius: 0.6,
                                        blurRadius: 0.7)
                                  ]),
                            );
                          },
                          shrinkWrap: false,
                          controller: ScrollController(
                              keepScrollOffset: false), // TRUE for check
                        );
                      }),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      //drawer: MyDrawer(currentUser: currentUser),
      body: searchResultsFuture == null
          ? buildNoContent()
          : Search(search: search),
    );
  }
}

class ProfileHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey[200], spreadRadius: 0.3, blurRadius: 0.4)
      ]),
      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hi, Welcome",
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      textStyle: TextStyle(color: Colors.grey[500])),
                ),
                Text(
                  "${currentUser.displayName}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      textStyle: TextStyle(color: Colors.grey[900])),
                )
              ],
            ),
          ),
          InkWell(
              onTap: () => showProfile(context, profileId: currentUser.id),
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(currentUser.photoUrl),
              )),
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 100;

  @override
  // TODO: implement minExtent
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
