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
  final String institution;
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
        required this.institution,
        required this.picture,
        required this.function});

  factory EventData.fromJson(Map<String, dynamic> json) {
    final startDateTime = DateTime.parse(json['start']).toLocal();
    final day = DateFormat('EEEE', 'pt_BR').format(startDateTime);
    final endDateTime = DateTime.parse(json['end']).toLocal();

    const timeZoneOffset = Duration(hours: 0); // Fuso horário -3 horas

    final timeFormatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('yyyy-MM-dd');

    final time =
    //timeFormatter.format(startDateTime.toLocal().add(timeZoneOffset));
    timeFormatter.format(startDateTime.toLocal());
    final timeEnd =
    timeFormatter.format(endDateTime.toLocal().add(timeZoneOffset));
    final date =
    //dateFormatter.format(startDateTime.toLocal().add(timeZoneOffset));
    dateFormatter.format(startDateTime.toLocal());
    final dateEnd =
    dateFormatter.format(endDateTime.toLocal().add(timeZoneOffset));

    return EventData(
      id: json['id'] ?? 0,
      // Se 'id' for nulo, atribui 0
      date: date,
      time: time,
      // Se 'start' for nulo, atribui uma string vazia
      dateEnd: dateEnd,
      timeEnd: timeEnd,
      day: day,
      // Se 'end' for nulo, atribui uma string vazia
      title: json['title']?['pt-br'] ?? '',
      // Se 'title' ou 'pt-br' for nulo, atribui uma string vazia
      description: json['description']?['pt-br'] ?? '',
      // Mesma lógica aqui
      category: json['category']?['title']?['pt-br'] ?? '',
      color: json['category']?["color"] ?? '',
      location: json['locations']?.isNotEmpty == true
          ? json['locations'][0]['title']['pt-br'] ?? ''
          : '',
      type: json['type']?['title']?['pt-br'] ?? '',
      personName: json['people']?.isNotEmpty == true
          ? json['people'][0]['name'] ?? ''
          : '',
      institution: json['people']?.isNotEmpty == true
          ? json['people'][0]['institution'] ?? ''
          : '',
      picture: json['people']?.isNotEmpty == true
          ? json['people'][0]['picture'] ?? ''
          : '',
      function: json['people']?.isNotEmpty == true
          ? json['people'][0]['role']['label']['pt-br'] ?? ''
          : '',
    );
  }
}