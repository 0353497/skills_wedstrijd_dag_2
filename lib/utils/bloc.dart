import 'package:rxdart/src/streams/value_stream.dart';
import 'package:rxdart/subjects.dart';
import 'package:skills_wedstrijd_dag_2/models/question.dart';
import 'package:skills_wedstrijd_dag_2/models/score.dart';

class Bloc {
  //singleton
    Bloc._privateConstructor();

    static final Bloc _instance = Bloc._privateConstructor();

    factory Bloc() {
      return _instance;
    }

  //huidige vraag
  static final BehaviorSubject<Vraag> _subject = BehaviorSubject<Vraag>.seeded(Vraag("", "", [], "",));

  final CurrentQuestionStream = _subject.stream;

  final GetCurrentQuestion = _subject.value;

  void sedCurrentQuestion(Vraag vraag) {
    _subject.add(vraag);
  }

  //current index
  static final BehaviorSubject<int> _currentIndexStream = BehaviorSubject<int>.seeded(0);
  final Stream<int> CurrentIndexStream = _currentIndexStream.stream;

  final int GetIndexQuestion = _currentIndexStream.value;

  void sedIndexQuestion(int index) {
    _currentIndexStream.add(index);
  }
  
  //huidige score
  static final BehaviorSubject<int> _currentCurrentScoreStream = BehaviorSubject<int>();
  final Stream<int> CurrentCurrentScoreStream = _currentCurrentScoreStream.stream;

   int get GetCurrentScoreQuestion => _currentCurrentScoreStream.value;

  void setCurrentScoreQuestion(int index) {
    _currentCurrentScoreStream.add(index);
  }

  //tijdloper
  static final BehaviorSubject<int> _timeStreamInSeconds = BehaviorSubject<int>.seeded(0);
  
  final Stream<int> timeStreamInSeconds = _timeStreamInSeconds.stream;

   int get GetTimeInSeconds => _timeStreamInSeconds.value;

  void setTimeInSeconds(int seconds) {
    _timeStreamInSeconds.add(seconds);
  }
  void CloseTime(){
    _timeStreamInSeconds.close();
  }

  //scores cache
  static final BehaviorSubject<List<Score>> _scoreSubject = BehaviorSubject<List<Score>>.seeded([]);
  
  final ValueStream<List<Score>> GetScoreSubjectStream = _scoreSubject.stream;

  final List<Score> GetScoreSubjectValue = _scoreSubject.value;

  void AddScore(Score score) {
    _scoreSubject.value.add(score);
  }

}