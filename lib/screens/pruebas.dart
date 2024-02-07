import 'package:flutter/material.dart';
import 'package:kollektor/widgets/firestore_services.dart';

class Pruebas extends StatefulWidget {
  const Pruebas({super.key});
  @override
  State<Pruebas> createState() => _PruebasState();
}

class _PruebasState extends State<Pruebas> {
  String selectedGenre = 'Rock progresivo';
  List<Map> availableGenres = [
    {'id': '1', 'name': 'Progresivo', 'isChecked': false},
    {'id': '2', 'name': 'Metal', 'isChecked': false},
    {'id': '3', 'name': 'Jazz', 'isChecked': false},
    {'id': '4', 'name': 'Pop', 'isChecked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pruebas'),
      ),
      body: FutureBuilder(
        future: getGenres(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final availableGenres = snapshot.data;
            return ListView.builder(
              itemCount: availableGenres?.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  key: ValueKey(availableGenres?[index]['id']),
                  value: availableGenres?[index]['isChecked'],
                  title: Text(availableGenres?[index]['name']),
                  onChanged: (value) {
                    setState(
                      () {
                        availableGenres[index]['isChecked'] = value;
                      },
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
