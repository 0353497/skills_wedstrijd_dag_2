import 'package:flutter/material.dart';
import 'package:skills_wedstrijd_dag_2/pages/quizpage.dart';
import 'package:skills_wedstrijd_dag_2/pages/scorepage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 90, 66, 131),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Scorepage(fromQuiz: false,)));
            },
          icon: Icon(Icons.leaderboard_outlined))
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 90, 66, 131),
        child: Row(
          children: [
            Image.asset("assets/dieren_illustratie.png"),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Test jouw \n Dierenkennis!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold
                    ),
                  textAlign: TextAlign.center,
                ),
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
            )
          ],
        ),
      ),
    );
  }
}