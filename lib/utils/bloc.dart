import 'package:rxdart/subjects.dart';
import 'package:skills_wedstrijd_dag_2/models/question.dart';

class Bloc {
    Bloc._privateConstructor();

    static final Bloc _instance = Bloc._privateConstructor();

    factory Bloc() {
      return _instance;
    }

  static final BehaviorSubject<Vraag> _subject = BehaviorSubject<Vraag>.seeded(Vraag("", "", [], "",));

  final CurrentQuestionStream = _subject.stream;

  final GetCurrentQuestion = _subject.value;

  void sedCurrentQuestion(Vraag vraag) {
    _subject.add(vraag);
  }
  static final BehaviorSubject<int> _currentIndexStream = BehaviorSubject<int>.seeded(0);
  final Stream<int> CurrentIndexStream = _currentIndexStream.stream;

  final int GetIndexQuestion = _currentIndexStream.value;

  void sedIndexQuestion(int index) {
    _currentIndexStream.add(index);
  }
  
  static final BehaviorSubject<int> _currentCurrentScoreStream = BehaviorSubject<int>.seeded(0);
  final Stream<int> CurrentCurrentScoreStream = _currentCurrentScoreStream.stream;

  final int GetCurrentScoreQuestion = _currentCurrentScoreStream.value;

  void setCurrentScoreQuestion(int index) {
    _currentCurrentScoreStream.add(index);
  }

  
  static final BehaviorSubject<int> _timeStreamInSeconds = BehaviorSubject<int>.seeded(0);
  
  final Stream<int> timeStreamInSeconds = _timeStreamInSeconds.stream;

  final int GetTimeInSeconds= _timeStreamInSeconds.value;

  void setTimeInSeconds(int seconds) {
    _timeStreamInSeconds.add(seconds);
  }
  void CloseTime(){
    _timeStreamInSeconds.close();
  }



  
  

}