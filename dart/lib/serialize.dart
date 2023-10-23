import 'package:intl/intl.dart';

class EventData {
  final int id;
  final String date;
  final String time;
  final String dateEnd;
  final String timeEnd;
  final String day;
  final String title;
  final String description;
  final String category;
  final String color;
  final String location;
  final String type;
  final String personName;
  final String allPersonsNames;
  final String institution;
  final String bio;
  final String picture;
  final String function;

  EventData(
      {required this.id,
        required this.date,
        required this.time,
        required this.dateEnd,
        required this.timeEnd,
        required this.day,
        required this.title,
        required this.description,
        required this.category,
        required this.color,
        required this.location,
        required this.type,
        required this.personName,
        required this.allPersonsNames,
        required this.institution,
        required this.bio,
        required this.picture,
        required this.function});



  factory EventData.fromJson(Map<String, dynamic> json) {
    final startDateTime = DateTime.parse(json['start']).toLocal();
    final day = DateFormat('EEEE', 'pt_BR').format(startDateTime);
    final endDateTime = DateTime.parse(json['end']).toLocal();

    const timeZoneOffset = Duration(hours: 0); // Fuso horário -3 horas

    final timeFormatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('yyyy-MM-dd');

    final time = timeFormatter.format(startDateTime.toLocal());
    final timeEnd = timeFormatter.format(endDateTime.toLocal().add(timeZoneOffset));
    final date = dateFormatter.format(startDateTime.toLocal());
    final dateEnd = dateFormatter.format(endDateTime.toLocal().add(timeZoneOffset));

    final people = json['people'];
    final allPeoples = <String>[];

    for (var person in people) {
      if (person['name'] != null) {
        allPeoples.add(person['name']);
      }
    }

    return EventData(
      id: json['id'] ?? 0,
      date: date,
      time: time,
      dateEnd: dateEnd,
      timeEnd: timeEnd,
      day: day,
      title: json['title']?['pt-br'] ?? '',
      description: json['description']?['pt-br'] ?? '',
      category: json['category']?['title']?['pt-br'] ?? '',
      color: json['category']?["color"] ?? '',
      location: json['locations']?.isNotEmpty == true
          ? json['locations'][0]['title']['pt-br'] ?? ''
          : '',
      type: json['type']?['title']?['pt-br'] ?? '',
      personName: allPeoples.isNotEmpty ? allPeoples.first : '', // Primeiro nome
      allPersonsNames: allPeoples.join(', '), // Concatena os nomes com uma vírgula e espaço
      institution: people.isNotEmpty ? people[0]['institution'] ?? '' : '',
      bio: people.isNotEmpty ? people[0]['bio']['pt-br'] ?? '' : '',
      picture: people.isNotEmpty ? people[0]['picture'] ?? '' : '',
      function: people.isNotEmpty ? people[0]['role']['label']['pt-br'] ?? '' : '',
    );
  }
}