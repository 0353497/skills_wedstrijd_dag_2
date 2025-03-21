import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:skills_wedstrijd_dag_2/components/timer.dart';
import 'package:skills_wedstrijd_dag_2/models/question.dart';
import 'package:skills_wedstrijd_dag_2/pages/homepage.dart';
import 'package:skills_wedstrijd_dag_2/pages/scorepage.dart';
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
  int CurrentIndex = 0;
  int? indexFout = null;
  bool IsWaiting = false;
  int indexgoed = 0;
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
    _bloc.sedIndexQuestion(CurrentIndex);
    _getVragen();
  }

  void nextQuestion() {
    if (lijstVragen.isNotEmpty) {
      _bloc.sedCurrentQuestion(lijstVragen[CurrentIndex]);
      if (CurrentIndex == 5) {
        CurrentIndex = 0;
      _bloc.sedIndexQuestion(CurrentIndex);
     Navigator.push(context, MaterialPageRoute(builder: (context) => Scorepage(fromQuiz: true,)));
      } else {
      CurrentIndex++;
      _bloc.sedIndexQuestion(CurrentIndex);
      }
    }
  }
  void CheckQuestion(String antwoord, String goed_antwoord, int index) async{
    print("$antwoord $goed_antwoord");
    setState(() {
      IsWaiting = true;
    });
    if (antwoord == goed_antwoord) {
      print("correct");
      score += 20;
      indexFout = null;
      _bloc.setCurrentScoreQuestion(score);
    } else {
      setState(() {
      indexFout = index;
      });
      print("incorrect!");
    }
    
     await Future.delayed(Duration(seconds: 1));
     setState(() {
       indexFout = null;
       IsWaiting= false;
     });
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
        color: Colors.white,
        size: 32,)),
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<Object>(
                  stream: _bloc.CurrentIndexStream,
                  builder: (context, snapshot) {
                    final int value  = int.parse(snapshot.data.toString());
                    return Text("vraag $value/5",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                    );
                  }
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
                TimerWidget()
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
                            "assets/${snapshot.data!.foto}",
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
    Color buttonColor = Color.fromARGB(255, 97, 138, 205);
    if (indexFout == index) {
      buttonColor = Colors.redAccent;
    } else if (IsWaiting && snapshot.data!.antwoorden[index] == snapshot.data!.goed_antwoord) {
      buttonColor = Colors.green;
    } 
    return Expanded(
              flex: 1,
              child: Container(
                height: 70,
                child: ElevatedButton(
                    onPressed: (IsWaiting) ? null : () {
                      CheckQuestion(snapshot.data!.antwoorden[index], snapshot.data!.goed_antwoord, index);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(buttonColor),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text("${snapshot.data!.antwoorden[index]}"),
                  ),
                ),
              );
  }
}