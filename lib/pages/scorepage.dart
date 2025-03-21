import 'package:flutter/material.dart';
import 'package:skills_wedstrijd_dag_2/pages/homepage.dart';
import 'package:skills_wedstrijd_dag_2/pages/quizpage.dart';

class Scorepage extends StatefulWidget {
  const Scorepage({super.key});

  @override
  State<Scorepage> createState() => _ScorepageState();
}

class _ScorepageState extends State<Scorepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 90, 66, 131),
        title: Text("Scorebord"),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(),));
        }, icon: Icon(Icons.home_outlined)),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Quizpage()));
          },
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            backgroundColor: WidgetStatePropertyAll(Colors.black)
          ),
          child: Text("Start de quiz"),
          )
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 90, 66, 131),
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(),
          child: ListView(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Text("1"),
                ),
                title: Text("naam"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}