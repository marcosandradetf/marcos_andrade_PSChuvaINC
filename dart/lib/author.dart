import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chuva_dart/serialize.dart';
import 'package:chuva_dart/main.dart';
import 'package:provider/provider.dart';
import 'package:chuva_dart/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:chuva_dart/home_content.dart';

class Author extends StatefulWidget {
  const Author({super.key});

  @override
  State<Author> createState() => _AuthorState();
}

class _AuthorState extends State<Author> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    List<EventData> events = appState.events;
    final EventData event = appState.event;
    events = events.where((item) => item.allPersonsNames.contains(appState.clickedName)).toList();

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
                onPressed: () => GoRouter.of(context).go('/Activities'),
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
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, bottom: 20),
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
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          color: Color(0xFF898989),
                                          size: 45,
                                        ),
                                        width: 100.0,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          event.personName,
                                          style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          event.institution,
                                          style: const TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              children: [
                                const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bio",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                    ]),
                                Text(
                                  event.bio,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16.04,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Atividades",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))
                                  ])),
                          Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Row(children: [
                                Text("dom., 26/11/2023",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                              ])),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                final activities = events[index];
                                final Color myColor = hexToColor(activities.color);
                                return InkWell(
                                    onTap: () {
                                      if (activities.id == appState.clickedID) {
                                        GoRouter.of(context).go('/Activities');
                                      } else if (activities.id == 8991) {
                                        GoRouter.of(context).go('/AnyActivity');
                                      }

                                    },
                                child: Card(
                                  margin: const EdgeInsets.only(
                                      top: 8, left: 5, right: 5, bottom: 10),
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
                                        top: 10.0, left: 20.0, bottom: 10, right: 25),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${activities.type} de ${activities.time} até ${activities.timeEnd}',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xFF393939)
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child:
                                              Text(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                activities.title,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  height: 1.2
                                                ),
                                              )
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              activities.allPersonsNames,
                                              style: const TextStyle(
                                                color: Color(0xFF7C7C7C),
                                                fontSize: 16.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));

                              }),
                        ],
                      )
                    : Container();
              })
        ])));
  }
}

