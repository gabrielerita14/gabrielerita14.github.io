// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'planet.dart';

class PlanetForm extends StatefulWidget {
  final Planet? planet;
  final Function(Planet) onSubmit;

  PlanetForm({this.planet, required this.onSubmit});

  @override
  _PlanetFormState createState() => _PlanetFormState();
}

class _PlanetFormState extends State<PlanetForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late double distance;
  late double size;
  String? nickname;
  String? imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.planet != null) {
      name = widget.planet!.name;
      distance = widget.planet!.distance;
      size = widget.planet!.size;
      nickname = widget.planet!.nickname;
      imageUrl = widget.planet!.imageUrl;
    } else {
      name = '';
      distance = 0;
      size = 0;
      nickname = null;
      imageUrl = '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        imageUrl = _imageFile?.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome'),
              initialValue: name,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Distância (UA)'),
              initialValue: distance.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  distance = double.parse(value);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a distância';
                }
                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                  return 'Insira um valor válido e positivo';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Tamanho (km)'),
              initialValue: size.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  size = double.parse(value);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o tamanho';
                }
                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                  return 'Insira um valor válido e positivo';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Apelido'),
              initialValue: nickname,
              onChanged: (value) {
                setState(() {
                  nickname = value;
                });
              },
            ),
            SizedBox(height: 10),
            if (_imageFile != null)
              Image.file(_imageFile!),
            TextButton.icon(
              icon: Icon(Icons.image),
              label: Text('Escolher Imagem'),
              onPressed: _pickImage,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo, foregroundColor: Colors.white, // Cor do texto
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  widget.onSubmit(
                    Planet(
                      name: name,
                      distance: distance,
                      size: size,
                      nickname: nickname,
                      imageUrl: imageUrl,
                    ),
                  );
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
