import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:chuva_dart/serialize.dart';

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