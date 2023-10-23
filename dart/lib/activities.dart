import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chuva_dart/serialize.dart';
import 'package:chuva_dart/main.dart';
import 'package:provider/provider.dart';
import 'package:chuva_dart/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class SubActivity {
  final String title;
  final String author;

  const SubActivity(this.title, this.author);
}

class Activity extends StatefulWidget {
  const Activity({super.key});

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
    final appState = Provider.of<AppState>(context, listen: false);
    final List<EventData> events = appState.events;
    final EventData event = appState.event;
    final Color myColor = appState.myColor;
    List<Widget> cardList = [];
    List<SubActivity> subs = [
      SubActivity(
          events[15].title, "${events[4].personName}, ${events[2].personName}"),
      SubActivity(
          events[14].title, "${events[2].personName}, ${events[4].personName}"),
    ];
    for (int i = 0; i < 2; i++) {
      cardList.add(
        Card(
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
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.only(top: 10.0, left: 15.0, bottom: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 20),
                  child: Row(
                    children: [
                      Text(
                        '${event.type} de ${event.time} até ${event.timeEnd}',
                        style: const TextStyle(
                            fontSize: 14.0,
                            height: 2,
                            color: Color(0xFF393939)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    maxLines: 2, // Define o número máximo de linhas
                    overflow: TextOverflow.ellipsis,
                    subs[i].title,
                    style: const TextStyle(fontSize: 18.2, height: 1.1),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 5, right: 20),
                    child: Row(
                      children: [
                        Text(
                          subs[i].author,
                          style: const TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: const Color(0xFF456189),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Chuva 💜 Flutter",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 50,
                  )
                ],
              ),
              leading: IconButton(
                onPressed: () => GoRouter.of(context).go('/'),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Center(
            child: Column(children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return event.id == appState.clickedID
                    ? Column(
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
                                      " ${event.day} ${event.time}h - ${event.timeEnd}h",
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
                              onPressed: () {
                                setState(() {
                                  _favorited = !_favorited;
                                });
                                toggleFavorited;
                              },
                              icon: _favorited
                                  ? const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                    )
                                  : const Icon(Icons.star_outline,
                                      color: Colors.white),
                              label: Text(
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                          GestureDetector(
                              onTap: () {
                                //appState.clickedID == 8921 || appState.clickedID == 8924  ? GoRouter.of(context).go('/Author') : null;
                                appState.clickedName ==
                                            "Stephen William Hawking" ||
                                        appState.clickedName ==
                                            " Neil deGrasse Tyson"
                                    ? GoRouter.of(context).go('/Author')
                                    : null;
                              },
                              child: Column(children: [
                                Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          event.function,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                (event.id != 8922)
                                    ? Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 15, left: 20),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  imageUrl: event.picture,
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
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
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 250,
                                                  child: Text(
                                                    event.institution,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF8D8D8D)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ))
                                    : Column(children: [
                                        Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 20, left: 20),
                                            alignment: Alignment.topLeft,
                                            child: const Text(
                                              "Sub-atividades",
                                              style: TextStyle(
                                                  color: Color(0xFF747474),
                                                  fontSize: 17),
                                            )),
                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 2, right: 2),
                                            child: Column(children: cardList))
                                      ])
                              ])),
                        ],
                      )
                    : Container();
              })
        ])));
  }
}
