// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'planet.dart';
import 'planet_form.dart';

class PlanetList extends StatefulWidget {
  @override
  _PlanetListState createState() => _PlanetListState();
}

class _PlanetListState extends State<PlanetList> {
  List<Planet> planets = [];

  @override
  void initState() {
    super.initState();
    _loadPlanets();
  }

  Future<void> _loadPlanets() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/planets.json');
      if (await file.exists()) {
        final data = json.decode(await file.readAsString()) as List;
        setState(() {
          planets = data.map((json) => Planet.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Erro ao carregar os planetas: $e');
    }
  }

  Future<void> _savePlanets() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/planets.json');
      final data = json.encode(planets.map((planet) => planet.toJson()).toList());
      await file.writeAsString(data);
    } catch (e) {
      print('Erro ao salvar os planetas: $e');
    }
  }

  void _addPlanet(Planet planet) {
    setState(() {
      planets.add(planet);
      _savePlanets();
    });
  }

  void _updatePlanet(int index, Planet planet) {
    setState(() {
      planets[index] = planet;
      _savePlanets();
    });
  }

  void _deletePlanet(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir este planeta?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                planets.removeAt(index);
                _savePlanets();
              });
              Navigator.of(context).pop();
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _showDetails(Planet planet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(planet.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (planet.imageUrl != null) Image.file(File(planet.imageUrl!)),
              Text('Distância: ${planet.distance} UA'),
              Text('Tamanho: ${planet.size} km'),
              if (planet.nickname != null) Text('Apelido: ${planet.nickname}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showForm({Planet? planet, int? index}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(planet == null ? 'Novo Planeta' : 'Editar Planeta'),
          content: PlanetForm(
            planet: planet,
            onSubmit: (newPlanet) {
              Navigator.of(context).pop();
              if (planet == null) {
                _addPlanet(newPlanet);
              } else {
                _updatePlanet(index!, newPlanet);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planetas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showForm(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: planets.length,
        itemBuilder: (context, index) {
          final planet = planets[index];
          return Card(
            color: Colors.indigo[100],
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: planet.imageUrl != null
                  ? Image.file(File(planet.imageUrl!), width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.place, size: 50, color: Colors.indigo),
              title: Text(planet.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text(planet.nickname ?? '', style: TextStyle(fontSize: 16, color: Colors.indigo[900])),
              onTap: () => _showDetails(planet),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.indigo[700]),
                    onPressed: () => _showForm(planet: planet, index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[700]),
                    onPressed: () => _deletePlanet(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  getApplicationDocumentsDirectory() {}
}
