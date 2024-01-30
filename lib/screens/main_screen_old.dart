import 'package:flutter/material.dart';

class MainScreenOld extends StatefulWidget {
  const MainScreenOld({super.key});
  @override
  State<MainScreenOld> createState() => _MainScreenOldState();
}

class _MainScreenOldState extends State<MainScreenOld> {
  String selectedGenre = 'Progressive rock';

  List<String> genre = [
    'Progressive rock',
    'Hard rock',
    'Jazz fusion',
    'Classic'
  ];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kollektor'),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Genero'),
                const Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: genre.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(genre[index]),
                        value: true, //selectedGenre.contains(genre[index]),
                        onChanged: (newGenre) {
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                ),
                const Text('Autores'),
              ],
            ),
          ),
          Container(
            width: 300,
            child: Column(
              children: [
                /* DropdownButton(
                  value: selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: authors.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                const Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                ), */
                /* Container(
                  height: 600,
                  child: GridView(
                    padding: const EdgeInsets.all(15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    children: availableAlbums
                        .map((album) => AlbumGridItem(album: album))
                        .where((album) =>
                            album.album.genre.contains(selectedGenre))
                        .toList(),
                  ),
                ), */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
