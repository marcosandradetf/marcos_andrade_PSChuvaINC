import 'package:flutter/material.dart';
import 'package:chuva_dart/main.dart';
import 'package:provider/provider.dart';


class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: appState.clicked == false
              ? const EdgeInsets.only(top: 17)
              : const EdgeInsets.only(bottom: 0),
          width: 20,
          child: IconButton(
            onPressed: () {
              appState.showElement();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        const Text(
          "Chuva 💜 Flutter",
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 10,
        ),
      ],
    );
  }
}
