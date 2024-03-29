class Album {
  Album({
    required this.id,
    required this.name,
    required this.year,
    required this.cover,
    required this.author,
    required this.genre,
    required this.isChecked,
  });

  final String id;
  final String name;
  final double year;
  final String cover;
  final String author;
  final String genre;
  final bool isChecked;
}
