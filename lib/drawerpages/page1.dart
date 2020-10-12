import 'package:flutter/material.dart';


//import 'package:flutter/rendering.dart';

class NewPage extends StatefulWidget{
 final String title;
 NewPage(this.title);

  @override
  State<StatefulWidget> createState() {
   
    return NewPageState();
  }


  
}


class NewPageState extends State<NewPage>{
 

 //final String title;
 //NewPageState(this.title);
  @override

  Widget build(BuildContext context) {
    // final _height=MediaQuery.of(context).size.height;
    return new Scaffold(
    appBar: new AppBar(
backgroundColor: Colors.indigo[500],
      title: new Text("Courses")),
   body: new SafeArea(child:
   Container(
     child:
Text('courses',style: TextStyle(color: Colors.black,),
)
            
   )
          
             ),
          
              );
            }
  

  
}
