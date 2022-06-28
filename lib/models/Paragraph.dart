import 'ContributionAction.dart';

class Paragraph {
  final String src;
  final String desc;
  final String type;
  final String hash;
  final String text;
  List<ContributionAction>? children = [];
  Paragraph({required this.src, required this.desc, required  this.type, required this.hash,required this.text});

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      src: json['src'] == null ? '' : json['src'],
      desc:  json['desc'] == null ? '' : json['desc'],
      type: json['type'] == null ? '' : json['type'],
      hash:  json['hash'] == null ? '' : json['hash'],
      text: json['text'] == null  ?  '' : json['text']
    );
  }
}