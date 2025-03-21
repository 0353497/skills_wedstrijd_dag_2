// {
//       "vraag": "Wat is de meest voorkomende vogel ter wereld?",
//       "foto": "images/veertje.jpeg",
//       "antwoorden": ["De merel", "De duif", "De meeuw", "De kip"],
//       "goed_antwoord": "De kip"
//     },
class Vraag{
  final String vraag;
  final String foto;
  final List<String> antwoorden;
  final String goed_antwoord;
  Vraag(this.vraag, this.foto, this.antwoorden, this.goed_antwoord);

  static Vraag fromJSON(Map<String, dynamic> json) {

    List<String> antwoorden = List<String>.from(json['antwoorden'] as List);
    return Vraag(
      json["vraag"] ?? "",
      json["foto"] ?? "",
      antwoorden ?? [],
      json["goed_antwoord"]?? ""
      );
  }
}