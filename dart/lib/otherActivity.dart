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

class AnyActivity extends StatefulWidget {
  const AnyActivity({super.key});

  @override
  State<AnyActivity> createState() => _AnyActivityState();
}

class _AnyActivityState extends State<AnyActivity> {
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
    List<EventData> events = appState.events;
    final EventData event = appState.event;
    final Color myColor = appState.myColor;
    events = events.where((item) => item.id == 8991).toList();

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
                final activities = events[index];
                final Color myColor = hexToColor(activities.color);

                return Column(children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: myColor,
                    child: Row(
                      children: [
                        Text(
                          activities.category,
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
                    color: const Color(0xFF306DC3),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        // Ajuste o valor para a quantidade de espaço desejada
                        Flexible(
                          child: Text(
                            'Essa atividade é parte de "Vida além da Terra: Uma Perspectiva Astrobiológica"',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * .9,
                    child: Text(
                      activities.title,
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
                              " ${activities.day} ${activities.time} - ${activities.timeEnd}",
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
                            Text(" ${activities.location}",
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
                  GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go('/Activities');
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 70.0, bottom: 70.0, left: 15, right: 15),
                          child: HtmlWidget(
                            '<div style="font-size: 16px !important;">${activities.description}</div>',
                            key: const Key('html_key'),
                          ))),
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            activities.function,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: activities.picture,
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
                          Column(
                            children: [
                              Text(activities.personName),
                              Text(activities.institution)
                            ],
                          )
                        ],
                      )),
                  Container(
                      child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go('/OtherAuthor');
                    },
                    child: const Row(
                      children: [
                        Text("abn")
                      ],
                    ),
                  ))
                ]);
              })
        ])));
  }
}
