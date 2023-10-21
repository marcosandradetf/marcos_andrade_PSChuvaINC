import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chuva_dart/serialize.dart';
import 'package:chuva_dart/main.dart';
import 'package:provider/provider.dart';
import 'package:chuva_dart/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Author extends StatefulWidget {
  const Author({super.key});

  @override
  State<Author> createState() => _AuthorState();
}

class _AuthorState extends State<Author> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final List<EventData> events = appState.events;
    final EventData event = appState.event;
    final Color myColor = appState.myColor;


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
                                      errorWidget: (context, url, error) =>
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
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        event.institution,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF8D8D8D)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ],
                    )
                        : Container();
                  })
            ])));
  }
}

