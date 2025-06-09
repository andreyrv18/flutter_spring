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

  Future<void> fetchProdutos() async {
    final resp = await http.get(Uri.parse(apiUri));
    setState(() {
      produtos = resp.statusCode == 200 ? json.decode(resp.body) : [];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            String nome = produto["nome"] ?? "Produto sem nome";
            String descricao = produto["descricao"] ?? "produto sem descricao";
            return ListTile(title: Text(nome), subtitle: Text(descricao));
          },
        ),
      ),
    );
  }
}
