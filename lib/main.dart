import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'afterlogin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo[500],
      ),
      home: AfterLogin(),
    );
  }
}
