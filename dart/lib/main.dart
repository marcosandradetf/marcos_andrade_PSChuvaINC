import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:chuva_dart/serialize.dart';
import 'package:chuva_dart/activities.dart';
import 'package:chuva_dart/data.dart';
import 'package:chuva_dart/home_content.dart';
import 'package:chuva_dart/author.dart';
import 'package:chuva_dart/otherActivity.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF456189),
      systemNavigationBarColor: Colors.white,
    ),
  );
  initializeDateFormatting('pt_BR', null);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const ChuvaDart(),
    ),
  );
}

class AppState extends ChangeNotifier {
  int clickedID = 0;

  void updateClickedID(int id) {
    clickedID = id;
    notifyListeners();
  }

  String clickedName = "";

  void setClickedName(String name) {
    clickedName = name;
  }

  DateTime currentDate = DateTime(2023, 11, 26);

  void setDate(DateTime newDate) {
    currentDate = newDate;
  }

  late List<EventData> events;

  late EventData event;

  late Color myColor;
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Calendar();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'Activities',
          builder: (BuildContext context, GoRouterState state) {
            return const Activity();
          },
        ),
        GoRoute(
          path: 'Author',
          builder: (BuildContext context, GoRouterState state) {
            return const Author();
          },
        ),
        GoRoute(
          path: 'AnyActivity',
          builder: (BuildContext context, GoRouterState state) {
            return const AnyActivity();
          },
        ),
      ],
    ),
  ],
);

/// The main app.
class ChuvaDart extends StatelessWidget {
  /// Constructs a [MyApp]
  const ChuvaDart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF456189)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

/// The home screen
class _CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime(2023, 11, 26);

  void _changeDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF456189),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Text(
                  "Chuva 💜 Flutter",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Programação",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Container(
              width: 50,
            ),
          ],
        ),
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .9,
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        )),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
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
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                color: const Color(0xFF306DC3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
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
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.133),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                  side: const BorderSide(
                                      style: BorderStyle.none)),
                              onPressed: () {
                                _changeDate(DateTime(2023, 11, day));
                                appState.setDate(DateTime(2023, 11, day));
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
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12.0),
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
                    //return EventList(events: events);
                    return KeyedSubtree(
                        key: UniqueKey(),
                  child: EventList(
                      key: GlobalKey(),
                      events: events));
                  } else {
                    return const Text('Nenhum dado disponível');
                  }
                },
              )),
            ]),
      ),
    );
  }
}
