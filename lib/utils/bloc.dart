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
    print(vraag);
    _subject.add(vraag);
    print(" value ${_subject.value.vraag}");
  }

}