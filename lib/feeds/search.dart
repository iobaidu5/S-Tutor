import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'drawer.dart';
import 'package:s_tutor/feeds/search_map.dart';
import 'package:s_tutor/models/tutormodel.dart';
import 'package:s_tutor/profile/profile_Tutor.dart';
import 'feeds.dart';
import '../feeds/progress.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  String search;
  Search({this.search});
  @override
  _SearchState createState() => _SearchState(search);
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin<Search> {
  String search;
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  _SearchState(String search);

  // handleSearch(search) {}

  clearSearch() {
    searchController.clear();
  }

  buildSearchResults({search}) {
    Future<QuerySnapshot> users = Firestore.instance
        .collection('Tutors')
        .where("subjects", isEqualTo: search)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();

              Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Feeds(),
              ));
            }),
      ),
      body: FutureBuilder(
        future: searchResultsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            circularProgress();
            return Text("No Result Found!");
          }
          List<UserResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            UserTutor user = UserTutor.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });
          return ListView(
            children: searchResults,
          );
        },
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      //drawer: MyDrawer(currentUser: currentUser),
      body: buildSearchResults(),
    );
  }
} //end of class

class UserResult extends StatelessWidget {
  final UserTutor user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TutorProfile(
                  profileTutorId: user.tid,
                ),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.edustatus,
                style: TextStyle(color: Colors.white),
              ),
              trailing: SizedBox.fromSize(
                size: Size(30, 30),
                child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    child: Icon(Icons.location_on),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            SearchMap(user.tid, user.location as LatLng),
                      );
                    }),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
