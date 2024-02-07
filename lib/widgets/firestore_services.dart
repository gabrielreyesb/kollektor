import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getGenres() async {
  List genres = [];
  String genre = '';
  CollectionReference collRefGenres = db.collection('Genres');
  QuerySnapshot queryGenres = await collRefGenres.get();

  if (queryGenres.isNull) {
    genres = ['Vacio'];
  } else {
    for (var doc in queryGenres.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      genre = data['name'];
    }
    genres.add(genre);
  }

  return genres;
}

// Listen to Genres collection in real-time
Stream<List<dynamic>> streamGenres() {
  return db.collection('Genres').snapshots().map((snapshot) => snapshot.docs.map((doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return {
      'id': doc.id,
      'name': data['name'],
      'selected': data['selected'] ?? false, // Assume false if null
    };
  }).toList());
}

// Update the "selected" property of a genre
Future<void> updateGenreSelected(String id, bool selected) async {
  await db.collection('Genres').doc(id).update({'selected': selected});
}