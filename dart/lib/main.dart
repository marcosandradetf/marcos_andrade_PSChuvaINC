import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chuva_dart/appBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  initializeDateFormatting('pt_BR', null);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const ChuvaDart(),
    ),
  );
}

class AppState extends ChangeNotifier {
  bool clicked = false;

  void hideElement() {
    clicked = true;
    notifyListeners();
  }

  void showElement() {
    clicked = false;
    notifyListeners();
  }

  int clickedID = 0;

  void updateClickedID(int id) {
    clickedID = id;
    notifyListeners();
  }
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

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  DateTime _currentDate = DateTime(2023, 11, 26);

  void _changeDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    const myAppbar = CustomAppBar();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF456189),
          title: myAppbar,
          bottom: PreferredSize(
            preferredSize: appState.clicked == false
                ? Size.fromHeight(screenHeight * 0.07)
                : Size.fromHeight(screenHeight * 0.0),
            child: Column(
              children: [
                if (appState.clicked == false)
                  const Text(
                    "Programação",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                if (appState.clicked == false)
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
                                  "       Exibindo todas atividades",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ))),
                if (appState.clicked == false)
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
            if (appState.clicked == false)
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
            if (appState.clicked == false)
              Container(
                margin: const EdgeInsets.only(bottom: 14.0),
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
                    );
                  } else {
                    return const Text('Nenhum dado disponível');
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
  final EventData event;
  final Color myColor;

  const Activity({super.key, required this.event, required this.myColor});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  bool _favorited = false;

  @override
  void initState() {
    super.initState();
    loadFavoritedState();
  }

  Future<void> loadFavoritedState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorited = prefs.getBool('favorited') ?? false;
    });
  }

// No seu onPressed do botão, atualize e salve o estado
  void toggleFavorited() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorited = !_favorited;
      prefs.setBool('favorited', _favorited);
    });
  }

  @override
  Widget build(BuildContext context) {
    final EventData event = widget.event;
    final Color myColor = widget.myColor;
    final appState = Provider.of<AppState>(context);

    if (event.id == appState.clickedID) {
      return Column(children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              color: myColor,
              child: Row(
                children: [
                  Text(
                    event.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * .9,
              child: Text(
                event.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_outlined,
                        color: Color(0xFF366EC0),
                      ),
                      Text(
                        " ${event.day} ${event.time} - ${event.timeEnd}",
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_sharp,
                        color: Color(0xFF366EC0),
                      ),
                      Text(" ${event.location}",
                          style: const TextStyle(fontSize: 15.0)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width * .95,
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF306DC3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: toggleFavorited,
                icon: _favorited
                    ? const Icon(
                        Icons.star,
                        color: Colors.white,
                      )
                    : const Icon(Icons.star_outline, color: Colors.white),
                label: Text(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    _favorited
                        ? 'Remover da sua agenda'
                        : 'Adicionar à sua agenda'),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(
                    top: 70.0, bottom: 70.0, left: 15, right: 15),
                child: HtmlWidget(
                  '<div style="font-size: 16px !important;">${event.description}</div>',
                  key: const Key('html_key'),
                )),
            Container(
              padding: const EdgeInsets.only(left: 15),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      event.function,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: event.picture,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                color: Color(0xFF898989),
                                size: 45,
                              ),
                              width: 60.0,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 250,
                              height: 23,
                              child: Text(
                                event.personName,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                event.institution,
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xFF8D8D8D)),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ]),
            ),
          ],
        ),
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

class EventList extends StatefulWidget {
  final List<EventData> events;

  const EventList({super.key, required this.events});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);

    _controller = AnimationController(
      vsync: this,
      duration: () {
        if (appState.clickedID == 8921) {
          return const Duration(milliseconds: 0);
        } else if (appState.clickedID == 8924) {
          return const Duration(milliseconds: 1200);
        } else {
          return const Duration(milliseconds: 300);
        }
      }(),
    );

    _animation = Tween<Offset>(
      begin: appState.clicked ? const Offset(1, 0) : const Offset(0, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (appState.clicked == false) {
      _controller.value = 1.0; // Defina o valor inicial da animação
    } else {
      _controller.forward();
    }
  }

  void playReverseAnimation() {
    final appState = Provider.of<AppState>(context, listen: false);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Inicia a animação de retorno
  }

  @override
  Widget build(BuildContext context) {
    final List<EventData> events = widget.events;
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.clicked == false && appState.clickedID == 8925) {
      playReverseAnimation();
    }
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

    return SlideTransition(
        position: _animation,
        child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              Color myColor = hexToColor(event.color);
              if (appState.clicked == false) {
                return Stack(
                  children: [
                    if (event.id == 8922)
                      Card(
                        margin:
                            const EdgeInsets.only(top: 12, left: 14, right: 14),
                        elevation: 5,
                        color: myColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 105,
                          ),
                          margin: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            // Cor de fundo do container
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
                        margin: const EdgeInsets.only(
                            top: 8, left: 8, right: 8, bottom: 10),
                        elevation: 5,
                        color: myColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 105,
                          ),
                          margin: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            // Cor de fundo do container
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              // Arredonda o canto superior direito
                              bottomRight: Radius.circular(
                                  8), // Arredonda o canto inferior direito
                            ), // Define um raio de 10 para arredondar as bordas
                          ),
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 15.0, bottom: 20),
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
                          appState.updateClickedID(event.id);
                          appState.hideElement();
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
                            minHeight: 105,
                          ),
                          margin: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            // Cor de fundo do container
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              // Arredonda o canto superior direito
                              bottomRight: Radius.circular(
                                  8), // Arredonda o canto inferior direito
                            ), // Define um raio de 10 para arredondar as bordas
                          ),
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 15.0, bottom: 15),
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
              }
              if (appState.clickedID == appState.clickedID) {
                _controller.forward();
                return Activity(event: event, myColor: myColor);
              } else {
                _controller.reverse();
              }
            }));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
