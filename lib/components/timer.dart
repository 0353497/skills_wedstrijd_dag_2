import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skills_wedstrijd_dag_2/utils/bloc.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final Stopwatch watch = Stopwatch();
  late Timer _timer;
  final Bloc _bloc = Bloc();
  String seconden = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    watch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (watch.elapsed.inSeconds < 10) {
          seconden = "0${watch.elapsed.inSeconds % 60}";
        } else {
          seconden = (watch.elapsed.inSeconds % 60).toString();
        }
        _bloc.setTimeInSeconds(watch.elapsed.inSeconds);
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.CloseTime();
  }

  @override
  Widget build(BuildContext context) {
    return Text("${(watch.elapsed.inSeconds / 60).floor()}:${(seconden)}");
  }
}