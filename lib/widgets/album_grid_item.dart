import 'package:flutter/material.dart';
import 'package:kollektor/models/album.dart';

class AlbumGridItem extends StatelessWidget {
  const AlbumGridItem({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Image.asset(album.cover),
      //Text(album.name),
    );
  }
}
