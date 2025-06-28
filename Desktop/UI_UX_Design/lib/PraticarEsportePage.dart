import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PraticarEsportePage extends StatefulWidget {
  const PraticarEsportePage({super.key});

  @override
  State<PraticarEsportePage> createState() => _PraticarEsportePageState();
}

class _PraticarEsportePageState extends State<PraticarEsportePage> {
  final List<Map<String, dynamic>> _registros = [];

  void _adicionarRegistro() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (data == null) return;

    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora == null) return;

    String? esporte;
    String? lugar;
    String? local;

    await showDialog(
      context: context,
      builder: (context) {
        final esporteController = TextEditingController();
        final lugarController = TextEditingController();
        final localController = TextEditingController();

        return AlertDialog(
          title: const Text("Detalhes do Esporte"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: esporteController,
                  decoration: const InputDecoration(
                    labelText: "Esporte praticado",
                  ),
                ),
                TextField(
                  controller: lugarController,
                  decoration: const InputDecoration(labelText: "Lugar"),
                ),
                TextField(
                  controller: localController,
                  decoration: const InputDecoration(labelText: "Localização"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
              ),
              child: const Text("Salvar"),
              onPressed: () {
                esporte = esporteController.text;
                lugar = lugarController.text;
                local = localController.text;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    if (esporte == null || esporte!.isEmpty) return;

    final dataHora = DateTime(
      data.year,
      data.month,
      data.day,
      hora.hour,
      hora.minute,
    );

    setState(() {
      _registros.add({
        'dataHora': dataHora,
        'esporte': esporte,
        'lugar': lugar,
        'local': local,
      });
    });

    // Fecha a página retornando os dados para o HomePage
    Navigator.pop(context, {
      'titulo': esporte!,
      'hora': DateFormat('dd/MM/yyyy - HH:mm').format(dataHora),
    });
  }

  void _excluirRegistro(int index) {
    setState(() {
      _registros.removeAt(index);
    });
  }

  Widget _buildRegistroItem(Map<String, dynamic> item, int index) {
    final dataHora = item['dataHora'] as DateTime;
    final dataFormatada = DateFormat('dd/MM/yyyy - HH:mm').format(dataHora);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.orange.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item['esporte'] ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text("Data: $dataFormatada"),
            Text("Lugar: ${item['lugar']}"),
            Text("Localização: ${item['local']}"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _excluirRegistro(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Praticar Esporte"),
        backgroundColor: const Color(0xFFFF7043),
        elevation: 6,
        shadowColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _registros.isEmpty
            ? const Center(
                child: Text(
                  "Nenhum esporte registrado ainda.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView(
                children: _registros
                    .asMap()
                    .entries
                    .map((e) => _buildRegistroItem(e.value, e.key))
                    .toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarRegistro,
        backgroundColor: const Color(0xFFFF7043),
        icon: const Icon(Icons.add),
        label: const Text("Novo Esporte"),
      ),
    );
  }
}
