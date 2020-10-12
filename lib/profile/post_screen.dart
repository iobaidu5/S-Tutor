import '../loginpages/login_page.dart';
import '../loginpages/login_page_tutor.dart';
import 'package:flutter/material.dart';

import '../profile/post.dart';
import '../feeds/progress.dart';
import 'package:google_fonts/google_fonts.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: new AppBar(
              centerTitle: true,
              title: new Text("Profile", style: GoogleFonts.aclonica()),
              backgroundColor: Colors.indigo[500],
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
