import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_map_polyline/google_map_polyline.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:s_tutor/feeds/drawer.dart';

class SearchMap extends StatefulWidget {
  LatLng location;
  final String user;

  SearchMap(this.user, this.location);

  @override
  _SearchState createState() => _SearchState(user, location);
}

class _SearchState extends State<SearchMap> {
  LatLng location;
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  final String user;
  bool mapToggle = false;
  var currentLocation;
  GoogleMapController mapController;
  var users = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var userRef = Firestore.instance.collection('users');
  bool usersToggle = false;
  final Set<Polyline> polyline = {};
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyBhDflq5iJrXIcKpeq0IzLQPQpOboX91lY");
  List<LatLng> routeCoords;

  _SearchState(this.user, this.location);

  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        //populateUsers();
      });
    });
  }

  handleSearch(location) {
    int distance = 10;
    setState(() {
      Geolocator()
          .distanceBetween(currentLocation.latitude, currentLocation.longitude,
              location.latitude, location.longitude)
          .then((calDist) {
        //getsomePoints(docs.documents[i].data);
        initMarker(location.latitude, location.longitude);
      });
    });
  }

  initMarker(latitude, longitude) {
    setState(() {
      var markerIdVal = "";
      final MarkerId markerId = MarkerId(markerIdVal);
      final Marker marker = (Marker(
        markerId: markerId,
        draggable: false,
        onTap: () {
          print("Marker Tapped");
        },
        position: LatLng(latitude, longitude),
        // infoWindow: InfoWindow(
        //title: user['displayName'], snippet: distance.toString() + " KM Away"),
      ));

      markers[markerId] = marker;
    });
  }

  // getsomePoints(users) {
  //   // print('aaaaaaaaaaaaa');
  //   //  var permissions =
  //   //     await Permission.getPermissionsStatus([PermissionName.Location]);
  //   // if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
  //   //   var askpermissions =
  //   //       await Permission.requestPermissions([PermissionName.Location]);
  //   // } else
  //   // {
  //   routeCoords = googleMapPolyline.getCoordinatesWithLocation(
  //       origin: LatLng(currentLocation.latitude, currentLocation.longitude),
  //       destination:
  //           LatLng(users['location'].latitude, users['location'].longitude),
  //       mode: RouteMode.driving) as List<LatLng>;
  //   // }
  // }

  // Widget clientCard(user) {
  //   return Padding(
  //       padding: EdgeInsets.only(left: 2.0, top: 10.0),
  //       child: InkWell(
  //           onTap: () {
  //             setState(() {
  //               zoomInMarker(user);
  //             });
  //           },
  //           child: Material(
  //             elevation: 4.0,
  //             borderRadius: BorderRadius.circular(5.0),
  //             child: Container(
  //                 height: 100.0,
  //                 width: 125.0,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(7.0),
  //                     ),
  //                     color: Colors.white),
  //                 child: Center(child: Text(user['name']))),
  //           )));
  // }

  // zoomInMarker(user) {
  //   mapController
  //       .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //           target: ((double.parse(latitude), double.parse(longitude))
  //           zoom: 17.0,
  //           bearing: 90.0,
  //           tilt: 45.0)))
  //       .then((val) {
  //     // setState(() {
  //     //   resetToggle = true;
  //     // });
  //   });
  // }

  //clearSearch() => searchController.clear(); // To Clear The Text Field!..

  buildContent() {
    //final Orientation orientation = MediaQuery.of(context).orientation;
    return MaterialApp(
      home: Scaffold(
        body: Flexible(
          child: Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: mapToggle
                      ? GoogleMap(
                          onMapCreated: onMapCreated,
                          polylines: polyline,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation.latitude,
                                currentLocation.longitude),
                            zoom: 10.0,
                          ),
                          markers: Set<Marker>.of(markers.values),
                        )
                      : Center(
                          child: Text(
                            'Loading... Please Wait!!!',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      //drawer: MyDrawer(currentUser: currentUser),
      body: buildContent(),
      //buildContent(),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      polyline.add(Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: routeCoords,
          width: 4,
          color: Colors.blue,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));
    });
  }
}

// class UserResult extends StatelessWidget {
//   final User user;

//   UserResult(this.user);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).primaryColor.withOpacity(0.7),
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () => print('tapped'),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 //backgroundImage: NetworkImage(user.photoUrl),
//               ),
//               title: new Text(
//                 user.name,
//                 style:
//                     TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               subtitle: new Text(
//                 user.username,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           Divider(
//             height: 2.0,
//             color: Colors.white54,
//           ),
//         ],
//       ),
//     );
//   }
// }
