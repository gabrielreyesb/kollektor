import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedGenre = 'Rock progresivo';
  List<Map> availableGenres = [
    {'id': '1', 'name': 'Progresivo', 'isChecked': false},
    {'id': '2', 'name': 'Metal', 'isChecked': false},
    {'id': '3', 'name': 'Jazz', 'isChecked': false},
    {'id': '4', 'name': 'Pop', 'isChecked': false},
  ];
  List<Map> availableAlbums = [
    {
      'name': 'In the Court of the Crimson King',
      'year': 1972,
      'cover': 'assets/images/king_crimson_inthecourt.jpeg',
      'authorName': 'King Krimson',
      'genre': 'Rock progresivo',
      'isChecked': false
    },
    {
      'name': 'Wish you were here',
      'year': 1972,
      'cover': 'assets/images/Pink_Floyd,_Wish_You_Were_Here.png',
      'authorName': 'Pink Floyd',
      'genre': 'Rock progresivo',
      'isChecked': false
    },
    {
      'name': 'Uomo di pezza',
      'year': 1973,
      'cover': 'assets/images/le_orme_uomodipezza.jpeg',
      'authorName': 'Le Orme',
      'genre': 'Rock progresivo',
      'isChecked': false
    },
    {
      'name': 'Dark side of the moon',
      'year': 1973,
      'cover': 'assets/images/Pink_floy_Dark_side.jpeg',
      'authorName': 'Pink Floyd',
      'genre': 'Rock progresivo',
      'isChecked': false
    },
    {
      'name': 'Cincinnato',
      'year': 1971,
      'cover': 'assets/images/Cincinnato.jpeg',
      'authorName': 'Cincinnato',
      'genre': 'Jazz fusion',
      'isChecked': false
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kollektor'),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 300,
                  height: 200,
                  child: ListView.builder(
                    itemCount: availableGenres.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(availableGenres[index]['name']),
                        value: availableGenres[index]['isChecked'],
                        onChanged: (value) {
                          setState(
                            () {
                              availableGenres[index]['isChecked'] = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  width: 300,
                  height: 200,
                  child: ListView.builder(
                    itemCount: availableAlbums.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(availableAlbums[index]['name']),
                        value: availableAlbums[index]['isChecked'],
                        onChanged: (value) {
                          setState(
                            () {
                              availableAlbums[index]['isChecked'] = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(
                  height: 10,
                ),
                const Expanded(
                  child: Text('Data1'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          /* Container(
            width: 1200,
            child: GridView(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
              ),
              children: availableAlbums
                  .map((album) => AlbumGridItem(album: album))
                  .where((album) => album.album.genre.contains(selectedGenre))
                  .toList(),
            ),
          ), */
        ],
      ),
    );
  }
}
