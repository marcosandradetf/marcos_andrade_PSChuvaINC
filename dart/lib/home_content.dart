import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chuva_dart/serialize.dart';
import 'package:chuva_dart/main.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  final List<EventData> events;

  const EventList({super.key, required this.events});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final List<EventData> events = widget.events;

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
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          Color myColor = hexToColor(event.color);

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
                    setState(() {
                      appState.events = events;
                    });
                    setState(() {
                      appState.event = event;
                    });
                    setState(() {
                      appState.myColor = myColor;
                    });
                    GoRouter.of(context).go('/Activities');
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
        });
  }
}
