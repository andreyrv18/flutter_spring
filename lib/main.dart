import 'package:flutter/material.dart';
import 'package:flutter_spring/produtos.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PeoplePage());
  }
}

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  List people = [];

  final String apiUrl = 'http://localhost:8080/people';

  Future<void> fetchPeople() async {
    final resp = await http.get(Uri.parse(apiUrl));
    setState(() {
      people = resp.statusCode == 200 ? json.decode(resp.body) : [];
    });
  }

  Future<void> addPerson(String name, String lastName) async {
    final resp = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"firstName": name, "lastName": lastName}),
    );
    if (resp.statusCode == 201) {
      fetchPeople();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'LastName'),
                  ),
                ),
                SizedBox(width: 40),

                ElevatedButton(
                  onPressed: () {
                    addPerson(_nameController.text, _lastNameController.text);
                    _nameController.clear();
                    _lastNameController.clear();
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${people[index]["id"] ?? 0}"),
                  title: Text('${people[index]['firstName'] ?? 'Sem nome'}'),
                  subtitle: Text(
                    "${people[index]['lastName'] ?? 'Sem sobrenome'}",
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_basket),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Produtos()),
          );
        },
      ),
    );
  }
}
