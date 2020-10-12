import 'package:flutter/material.dart';

class NewPage2 extends StatelessWidget{
 final String title;
 NewPage2(this.title);
  @override

  Widget build(BuildContext context) {
    
    return new Scaffold(
    appBar: new AppBar(
backgroundColor: Colors.indigo[500],
      title: new Text(title)),
   body: GestureDetector(
     onTap: (){
       FocusScope.of(context).requestFocus(new FocusNode());



     },
     child: Column(children: <Widget>[
     Container(
     child:
Text('About ',style: TextStyle(color: Colors.black,),
)
            
   ),
       
            ],),
       
            
          ),
       
           );
         }
     

  
}
