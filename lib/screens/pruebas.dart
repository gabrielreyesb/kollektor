import 'package:flutter/material.dart';
import 'package:kollektor/widgets/firestore_services.dart';

class Pruebas extends StatefulWidget {
  const Pruebas({super.key});
  @override
  State<Pruebas> createState() => _PruebasState();
}

class _PruebasState extends State<Pruebas> {
  String selectedGenre = 'Rock progresivo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pruebas'),
      ),
      body: GenreListView(),
    );
  }
}

class GenreListView extends StatelessWidget {
  // Simulating an asynchronous data fetching process
  Future<List<String>> fetchData() async {
    // Simulating network latency
    await Future.delayed(Duration(seconds: 3));
    return List.generate(10, (index) => 'Item $index');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is still running, show a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If we ran into an error, display it
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // When data is fetched successfully, display the ListView
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
              );
            },
          );
        }
      },
    );
  }
}