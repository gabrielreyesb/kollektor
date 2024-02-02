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