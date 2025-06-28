// relatoriodia.dart
import 'package:flutter/material.dart';
import 'package:novo/HomePage.dart'; // ou onde estiver definido RelatorioItem

class RelatorioDia extends StatelessWidget {
  final List<RelatorioItem> registros;

  const RelatorioDia({super.key, required this.registros});

  Widget buildRelatorioItem(RelatorioItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          leading: Icon(item.icone, size: 36, color: item.corIcone),
          title: Text(
            item.titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            item.hora,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Relatório")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: registros.isEmpty
            ? const Center(
                child: Text(
                  "Nenhum registro encontrado.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView(children: registros.map(buildRelatorioItem).toList()),
      ),
    );
  }
}
