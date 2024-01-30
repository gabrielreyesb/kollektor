import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getGenres() async {
  List genres = [];
  CollectionReference collRefGenres = db.collection('Genres');
  QuerySnapshot queryGenres = await collRefGenres.get();

  for (var doc in queryGenres.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final genre = {
      'id': doc.id,
      'name': data['name'],
      'isChecked': true,
    };
    genres.add(genre);
  }

  return genres;
}
