
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String sid;
 // final String username;
  final String cnic;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String location;
  final String edustatus;
    
   
    final String phone;

  User(
    {
    this.sid,
   // this.username,
    this.cnic,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.location,
    this.edustatus,

 this.phone,
    }
  );

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      sid: doc['id'],
      email: doc['email'],
   
      cnic: doc['cnic'],
         phone: doc['phoneNumber'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      location: doc['location'],
      edustatus: doc['edustatus'],
  
    );
    
  }
}
