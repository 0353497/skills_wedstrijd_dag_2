import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:skills_wedstrijd_dag_2/models/question.dart';
import 'package:skills_wedstrijd_dag_2/pages/homepage.dart';
import 'package:skills_wedstrijd_dag_2/utils/bloc.dart';
import 'package:skills_wedstrijd_dag_2/utils/json.dart';

class Quizpage extends StatefulWidget {
  const Quizpage({super.key});

  @override
  State<Quizpage> createState() => _QuizpageState();
}

class _QuizpageState extends State<Quizpage> {
  late List<Vraag> lijstVragen;
  int score = 0;
  int CurrentIndex =0 ;
  _getVragen() async{
    Map<String, dynamic> json = await JsonService.Readquestions("assets/quizvragen.json");
    List dynamicVragen = json["quizvragen"];
    List<Vraag> vragen = dynamicVragen.map((vraag) => Vraag.fromJSON(vraag)).toList();
    vragen.shuffle();
    vragen.sublist(4);
    print("$vragen");
    lijstVragen = vragen;
    nextQuestion();
  }

  final Bloc _bloc =Bloc();
  @override
  void initState() {
    super.initState();
    _getVragen();
  }

  void nextQuestion() {
    if (lijstVragen.isNotEmpty) {
      _bloc.sedCurrentQuestion(lijstVragen[CurrentIndex]);
      if (CurrentIndex == 4) {
        CurrentIndex = 0;
      _bloc.sedIndexQuestion(CurrentIndex);
      } else {
      CurrentIndex++;
      _bloc.sedIndexQuestion(CurrentIndex);
      }
    }
  }
  void CheckQuestion(String antwoord) {
    print(" $antwoord is ${lijstVragen[CurrentIndex].goed_antwoord}");
    if (antwoord == _bloc.GetCurrentQuestion.goed_antwoord) {
      print("correct");
      score += 20;
      _bloc.setCurrentScoreQuestion(score);
    } else {
      print("incorrect!");
    }

    nextQuestion();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 90, 66, 131),
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));

        }, icon: Icon(Icons.home_outlined,
        size: 32,)),
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("vraag 1/5",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
                ),
                StreamBuilder<Object>(
                  stream: _bloc.CurrentIndexStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {} 
                    final int value  = int.parse(snapshot.data.toString());
                    return SizedBox(
                      width: 300,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(16),
                        minHeight: 25,
                        backgroundColor: const Color.fromARGB(90, 0, 0, 0),
                        value:  (value / 5),
                        color: Colors.amber,
                      ),
                    );
                  }
                ),
                ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(90, 0, 0, 0)),
                  ),
                  child: StreamBuilder<int>(
                    stream: _bloc.CurrentCurrentScoreStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                      final int value = int.parse(snapshot.data.toString());
                      return Text('$value',
                        style: TextStyle(
                          color: Colors.white
                        ), 
                      );
                      } else {
                        return Text("score",
                          style: TextStyle(
                          color: Colors.white
                        ), 
                        );
                      }
                    
                    }
                  ),
                ),
                Text("0:02",
                 style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),),
              ],
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Color.fromARGB(255, 90, 66, 131),
        child: StreamBuilder<Vraag>(
          stream: _bloc.CurrentQuestionStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              spacing: 5,
              children: [
                SizedBox(
                  child: Row(
                    spacing: 40,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          shape: RoundedRectangleBorder(),
                          child: Image.asset(
                            "assets/vragen_afbeeldingen/kalender.jpeg",
                          height: 100,
                          fit: BoxFit.cover,
                          ),
                        ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${snapshot.data!.vraag}", 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Column(
                  spacing: 10,
                  children: [
                    Row(
                      children: <Widget>[
                        OptionButton(snapshot, 0),
                        SizedBox(width: 50,),
                        OptionButton(snapshot, 1)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        OptionButton(snapshot, 2),
                        SizedBox(width: 50,),
                       OptionButton(snapshot, 3)
                      ],
                    ),
                  ],
                )
              ],
            );
          }
        ),
        ),
    );
  }

  Widget OptionButton(AsyncSnapshot<Vraag> snapshot, int index) {
    if (snapshot.data!.antwoorden.length <= index) {
      return SizedBox();
    }

    return Expanded(
              flex: 1,
              child: Container(
                height: 70,
                child: ElevatedButton(
                    onPressed: () {
                      CheckQuestion(snapshot.data!.antwoorden[index]);
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 97, 138, 205)),
                    ),
                    child: Text("${snapshot.data!.antwoorden[index]}"),
                  ),
                ),
              );
  }
}