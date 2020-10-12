import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

  class NewPage3 extends StatefulWidget{
      final String title;
 NewPage3(this.title);

  @override
  State<StatefulWidget> createState() {
 
    return NewsFeed();

  }



  }
  class  NewsFeed extends State<NewPage3>{
    
  

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
    appBar: new AppBar(
backgroundColor: Colors.indigo[500],
      title: new Text("Ratings"), 
    
      ),
       body:
      //  Column(children: <Widget>[
      //  _buildFeed(1),
      //  _buildFeed(2),],),
      
        Container(child:
Column(children: <Widget>[
     Container(
     child:
Text('Locations',style: TextStyle(color: Colors.black,),
)
            
   ),
       
            ],),

        ),
        );
        
        
       





    
    
    
    





  }


  }




