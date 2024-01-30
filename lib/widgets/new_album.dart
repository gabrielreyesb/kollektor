import 'package:flutter/material.dart';
import 'package:kollektor/models/album.dart';

class NewAlbum extends StatefulWidget {
  const NewAlbum({super.key, required this.onAddAlbum});

  final void Function(Album album) onAddAlbum;

  @override
  State<StatefulWidget> createState() {
    return _NewAlbumState();
  }
}

class _NewAlbumState extends State<NewAlbum> {
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _coverController = TextEditingController();
  //Author _selectedAutor = Authors

  void _submitAlbumData() {
    final enteredYear = double.tryParse(_yearController.text);

    if (_nameController.text.trim().isEmpty ||
        _coverController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Datos inválidos'),
          content: const Text('Por favor llene los datos correctamente'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddAlbum(
      Album(
        id: '1',
        name: _nameController.text,
        year: enteredYear!,
        cover: _coverController.text,
        author: '1',
        genre: '',
        isChecked: false,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Crear nuevo album',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              label: Text('Nombre'),
            ),
          ),
          TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text('Año'),
            ),
          ),
          TextField(
            controller: _coverController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text('Portada'),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitAlbumData,
                child: const Text('Grabar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
