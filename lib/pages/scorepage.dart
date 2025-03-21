import 'package:flutter/material.dart';
import 'package:skills_wedstrijd_dag_2/models/score.dart';
import 'package:skills_wedstrijd_dag_2/pages/homepage.dart';
import 'package:skills_wedstrijd_dag_2/pages/quizpage.dart';
import 'package:skills_wedstrijd_dag_2/utils/bloc.dart';

class Scorepage extends StatefulWidget {
  final bool fromQuiz;
  final int score;
  final int tijdInSeconden;
  const Scorepage({super.key, this.fromQuiz = false,  this.score = 0, this.tijdInSeconden = 0, });

  @override
  State<Scorepage> createState() => _ScorepageState();
}

class _ScorepageState extends State<Scorepage> {

  Bloc _bloc = Bloc();

  final TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.fromQuiz) {
       Future.delayed(Duration.zero, () {
      _showModal();
      });
    }
  }
  _showModal() {
    showDialog(context: context, builder: (context) {
      return StreamBuilder<int>(
        stream: _bloc.CurrentCurrentScoreStream,
        builder: (context, snapshot) {
          return AlertDialog(
            title: Text("Gefeliciteert! je score is ${snapshot.data}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Voer je naam in als je in het scorebord wilt komen."),
                TextField(
                  controller: nameController,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
              child: Text("anuleer")
              ),
              ElevatedButton(
                onPressed: () async{
                  final int scoreGetal = _bloc.GetCurrentScoreQuestion;
                  final int tijdInSeconden = _bloc.GetTimeInSeconds;
                  final Score score = Score(nameController.text, scoreGetal, tijdInSeconden);
                  _addScore(score);
                  Navigator.pop(context);
                },
              child: Text("ok")
              )
            ],
          );
        }
      );
    });
  }


  _addScore(Score score) {
    setState(() {
      _bloc.AddScore(score);
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 90, 66, 131),
        foregroundColor: Colors.white,
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
          child: StreamBuilder<List<Score>>(
            stream: _bloc.GetScoreSubjectStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.length == 0) {
                return Center(
                  child: Text("geen scores"),
                );
              }
              snapshot.data!.sort((a, b) => a.score.compareTo(b.score));
              final list = snapshot.data!;
              list.sort((a, b) => a.score.compareTo(b.score));
              list.reversed.toList();
              return ListView(
                children: [
                  for (int i = 1; i < list.length; i ++)
                    ListTile(
                      tileColor: Colors.grey.shade100,
                      leading: CircleAvatar(
                        backgroundColor: (i == 1) ? Colors.amberAccent : (i==2) ? Colors.grey : (i == 3) ? Colors.brown : Colors.grey.shade100,
                        child: Text("$i", 
                        style: TextStyle(
                          color: Colors.black
                        ),
                        ),
                      ),
                      title: Text("${list[i].naam}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(onPressed: null, child: Text("${list[i].score}")),
                          SizedBox(
                            width: 10,
                          ),
                          Text("${((list[i].tijdInSeconden / 60)).floor()}:${list[i].tijdInSeconden % 60}"),
                        ],
                      ),
                    ),
                ],
              );
            }
          )
        ),
      ),
    );
  }
}