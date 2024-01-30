//import 'package:uuid/uuid.dart';

//const uuid = Uuid();

class Author {
  Author({
    required this.authorid,
    required this.name,
    required this.genreId,
  }); //: authorid = uuid.v4();

  final String authorid;
  final String name;
  final String genreId;
}
