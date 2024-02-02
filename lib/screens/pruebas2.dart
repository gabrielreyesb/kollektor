import 'package:flutter/material.dart';
import 'package:kollektor/widgets/firestore_services.dart';

class Pruebas2 extends StatefulWidget {
  const Pruebas2({super.key});

  @override
  State<Pruebas2> createState() => _PruebasState2();

}

class _PruebasState2 extends State<Pruebas2> {

  List<dynamic> genres = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text('Pruebas'),
    ),
        body: GenreListView());
  }

}


class GenreListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: streamGenres(), // This listens to genre changes in real-time
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView(
            children: snapshot.data!.map((genre) {
              return CheckboxListTile(
                title: Text(genre['name']),
                value: genre['selected'],
                onChanged: (bool? newValue) {
                  // Update the "selected" property in Firestore when toggled
                  updateGenreSelected(genre['id'], newValue ?? false);
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}