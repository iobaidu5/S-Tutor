import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserTutor {
  final String tid;

  final String cnic;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String location;
  final String edustatus;

  final String category;
  final String classlevel;
  final String subjects;
  final String availabilitytime;
  final String studentpreferred;
  final String salary;

  final String phone;

  UserTutor({
    this.tid,
    this.cnic,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.location,
    this.edustatus,
    this.category,
    this.classlevel,
    this.subjects,
    this.availabilitytime,
    this.studentpreferred,
    this.salary,
    this.phone,
  });

  factory UserTutor.fromDocument(DocumentSnapshot doc) {
    return UserTutor(
      tid: doc['id'],
      email: doc['email'],
      cnic: doc['cnic'],
      phone: doc['phoneNumber'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      location: doc['location'],
      edustatus: doc['edustatus'],
      category: doc['category'],
      classlevel: doc['classlevel'],
      subjects: doc['subjects'],
      availabilitytime: doc['availabilitytime'],
      studentpreferred: doc['studentpreferred'],
      salary: doc['salary'],
    );
  }
}
