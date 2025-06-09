import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<Produtos> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  final String apiUri = "http://localhost:8080/produtos";
  List produtos = [];

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descricaController = TextEditingController();

  Future<void> fetchProdutos() async {
    final resp = await http.get(Uri.parse(apiUri));
    setState(() {
      produtos = resp.statusCode == 200 ? json.decode(resp.body) : [];
    });
  }

  Future<void> addProduct(String nome, String descricao) async {
    final resp = await http.post(
      Uri.parse(apiUri),

      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": nome, "descricao": descricao}),
    );

    if (resp.statusCode == 201) {
      fetchProdutos();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome"),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: TextField(
                  controller: _descricaController,
                  decoration: InputDecoration(labelText: "Descricao"),
                ),
              ),
              SizedBox(width: 24),
              ElevatedButton(
                onPressed: () {
                  addProduct(_nomeController.text, _descricaController.text);
                  _nomeController.clear();
                  _descricaController.clear();
                },
                child: Text("Adicionar"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                String nome = produto["nome"] ?? "Produto sem nome";
                String descricao =
                    produto["descricao"] ?? "produto sem descricao";
                return ListTile(title: Text(nome), subtitle: Text(descricao));
              },
            ),
          ),
        ],
      ),
    );
  }
}
