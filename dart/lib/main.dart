import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  initializeDateFormatting('pt_BR', null);
  runApp(const ChuvaDart());
}

class ChuvaDart extends StatelessWidget {
  const ChuvaDart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF456189)),
        useMaterial3: true,
      ),
      home: const Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime(2023, 11, 26);
  bool _clicked = false;

  void _changeDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: null,
          bottom: PreferredSize(
            preferredSize: _clicked == false
                ? Size.fromHeight(screenHeight * 0.075)
                : Size.fromHeight(screenHeight * 0.01),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 35,
                      padding: EdgeInsets.all(const Size.fromWidth(5).width),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _clicked = false;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth - (screenWidth * .35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Chuva ",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            MdiIcons.heart,
                            color: const Color(0xFFB53FF5),
                            size: const Size.fromWidth(30.0).width,
                          ),
                          const Text(
                            " Flutter",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: const Text(
                    "Programação",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (_clicked == false)
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          )),
                      child: SizedBox(
                          width: screenWidth * .9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Card(
                                color: const Color(0xFF306DC3),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: const Icon(
                                      Icons.calendar_month_outlined,
                                    )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Exibindo todas atividades",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            ],
                          ))),
                if (_clicked == false)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4.0),
                  )
              ],
            ),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (_clicked == false)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                color: const Color(0xFF306DC3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      color: Colors.white,
                      child: const Column(
                        children: [
                          Text(
                            'Nov',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '2023',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        for (int day = 26; day <= 30; day++)
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: screenWidth * 0.125),
                            // Defina a largura mínima desejada
                            child: TextButton(
                              onPressed: () {
                                _changeDate(DateTime(2023, 11, day));
                              },
                              child: Text(
                                day.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: _currentDate.day == day
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.only(bottom: 7.0),
            ),
            Expanded(
              child: FutureBuilder<List<EventData>?>(
                future: fetchData(_currentDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final events = snapshot.data!;
                    return EventList(
                      events: events,
                      clicked: _clicked,
                    );
                  } else {
                    return Text('Nenhum dado disponível');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////
class Activity extends StatefulWidget {
  final event;

  const Activity({super.key, required this.event});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    if (kDebugMode) {
      print(event.picture);
    }
    if (event.id == 8921 ||
        event.id == 8922 ||
        event.id == 8924 ||
        event.id == 8925) {
      return Column(children: [
        Column(
          children: [
            Container(
              child: Row(
                children: [Text(event.category)],
              ),
            ),
            Container(
              child: Text(event.title),
            ),
            Container(
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                  ),
                  Text(" ${event.day} ${event.time} - ${event.timeEnd}"),
                ],
              ),
            ),
            Container(
              child: HtmlWidget(event.description)
            ),
            Container(
              child: CachedNetworkImage(
                imageUrl: "${event.picture}",
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Container(
              child:
              Row(children: [
                Row(children: [Text(event.personName)],),
                Row(children: [Text(event.institution)],)
              ],)
            ),
          ],
        )
      ]);
    }
    return Container();
  }
}

////////////////////////////////////////////////////////////////////////////////////////////

Future<List<EventData>> fetchData(DateTime newDate) async {
  DateTime currentDate = newDate;

  try {
    // Carrega o conteúdo do arquivo JSON local
    final String jsonData1 =
        await rootBundle.loadString('assets/activities.json');
    final String jsonData2 =
        await rootBundle.loadString('assets/activities-1.json');

    // Analisa os JSONs carregados
    final List<dynamic> data1 = json.decode(jsonData1)['data'];
    final List<dynamic> data2 = json.decode(jsonData2)['data'];

    // Converte os dados em objetos EventData
    final List<EventData> events1 =
        data1.map((json) => EventData.fromJson(json)).toList();
    final List<EventData> events2 =
        data2.map((json) => EventData.fromJson(json)).toList();

    // Combine os eventos de ambos os arquivos
    final events = [...events1, ...events2];

    final eventDay = events
        .where((event) => event.date == "2023-11-${currentDate.day}")
        .toList();

    eventDay.sort((a, b) {
      int inOrderning(
          List<int> customOrder, EventData eventA, EventData eventB) {
        final aIsCustom = customOrder.contains(eventA.id);
        final bIsCustom = customOrder.contains(eventB.id);

        if (aIsCustom && bIsCustom) {
          return customOrder.indexOf(eventA.id) -
              customOrder.indexOf(eventB.id);
        } else if (aIsCustom) {
          return -1;
        } else if (bIsCustom) {
          return 1;
        } else {
          return eventA.id - eventB.id;
        }
      }

      if (currentDate.day == 27) {
        final customOrder = [8935, 8936, 8937, 8938, 8939, 8941, 8942];
        return inOrderning(customOrder, a, b);
      }

      if (currentDate.day == 28) {
        final customOrder = [8949, 8952, 8950, 8953, 8951, 8954];
        return inOrderning(customOrder, a, b);
      }

      if (currentDate.day == 29) {
        final customOrder = [8963, 8964, 8965, 8966, 8968, 8970, 8969];
        return inOrderning(customOrder, a, b);
      }

      if (currentDate.day == 30) {
        final customOrder = [8978, 8977, 8980, 8981, 8982, 8983, 8984];
        return inOrderning(customOrder, a, b);
      }

      final defaultOrder = [8921, 8923, 8924, 8922, 8925, 8926, 8927];
      return inOrderning(defaultOrder, a, b);
    });

    return eventDay;
  } catch (error) {
    throw Exception('Falha ao carregar os dados: $error');
  }
}

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

  EventData({
    required this.id,
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
  });

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
    );
  }
}

//class EventList extends StatelessWidget {
class EventList extends StatefulWidget {
  final List<EventData> events;
  bool clicked;

  EventList({super.key, required this.events, required this.clicked});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final List<EventData> events = widget.events;
    bool clicked = widget.clicked;

    Color hexToColor(String hexColor) {
      // Remova o "#" do início da string, se existir
      hexColor = hexColor.replaceAll("#", "");

      // Verifique se a string possui 6 caracteres (representando RGB)
      if (hexColor.length != 6) {
        // Em caso de erro, retorne uma cor padrão ou null
        return Colors.grey; // Ou outra cor de sua escolha
      }

      // Divida a string em pares de caracteres para vermelho, verde e azul
      final r = int.parse(hexColor.substring(0, 2), radix: 16);
      final g = int.parse(hexColor.substring(2, 4), radix: 16);
      final b = int.parse(hexColor.substring(4, 6), radix: 16);

      // Crie uma instância de Color com os valores RGB
      return Color.fromARGB(255, r, g, b);
    }

    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          Color myColor = hexToColor(event.color);
          if (clicked == false) {
            return Stack(
              children: [
                if (event.id == 8922)
                  Card(
                    margin: const EdgeInsets.only(top: 12, left: 14, right: 14),
                    elevation: 5,
                    color: myColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white, // Cor de fundo do container
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          // Arredonda o canto superior direito
                          bottomRight: Radius.circular(
                              8), // Arredonda o canto inferior direito
                        ), // Define um raio de 10 para arredondar as bordas
                      ),
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15.0, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${event.type} de ${event.time} até ${event.timeEnd}',
                                style: const TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                event.personName,
                                style: const TextStyle(
                                  color: Color(0xFF7C7C7C),
                                  fontSize: 14.0,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                if (event.id == 8922)
                  Card(
                    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    elevation: 5,
                    color: myColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white, // Cor de fundo do container
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          // Arredonda o canto superior direito
                          bottomRight: Radius.circular(
                              8), // Arredonda o canto inferior direito
                        ), // Define um raio de 10 para arredondar as bordas
                      ),
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15.0, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${event.type} de ${event.time} até ${event.timeEnd}',
                                style: const TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                event.personName,
                                style: const TextStyle(
                                  color: Color(0xFF7C7C7C),
                                  fontSize: 14.0,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    if (event.id == 8921 ||
                        event.id == 8922 ||
                        event.id == 8924 ||
                        event.id == 8925) {
                      setState(() {
                        setState(() {
                          widget.clicked = true;
                        });
                      });
                    }
                  },
                  child: Card(
                    elevation: 5,
                    color: myColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white, // Cor de fundo do container
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          // Arredonda o canto superior direito
                          bottomRight: Radius.circular(
                              8), // Arredonda o canto inferior direito
                        ), // Define um raio de 10 para arredondar as bordas
                      ),
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15.0, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${event.type} de ${event.time} até ${event.timeEnd}',
                                style: const TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                event.personName,
                                style: const TextStyle(
                                  color: Color(0xFF7C7C7C),
                                  fontSize: 14.0,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Activity(event: event);
          }
        });
  }
}
