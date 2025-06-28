import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EstudoPage extends StatefulWidget {
  const EstudoPage({super.key});

  @override
  State<EstudoPage> createState() => _EstudoPageState();
}

class _EstudoPageState extends State<EstudoPage> {
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

    bool estudou = false;
    String? assunto;
    String? local;

    await showDialog(
      context: context,
      builder: (context) {
        final assuntoController = TextEditingController();
        final localController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Detalhes do Estudo"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: const Text("Estudou?"),
                      value: estudou,
                      onChanged: (val) {
                        setStateDialog(() {
                          estudou = val ?? false;
                        });
                      },
                    ),
                    TextField(
                      controller: assuntoController,
                      decoration: const InputDecoration(
                        labelText: "Assunto estudado",
                      ),
                    ),
                    TextField(
                      controller: localController,
                      decoration: const InputDecoration(
                        labelText: "Local do estudo",
                      ),
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
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: const Text("Salvar"),
                  onPressed: () {
                    assunto = assuntoController.text;
                    local = localController.text;
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );

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
        'estudou': estudou,
        'assunto': assunto ?? '',
        'local': local ?? '',
      });
    });

    // Fecha a página e retorna para HomePage os dados do registro criado
    Navigator.pop(context, {
      'titulo': estudou ? 'Estudou' : 'Não estudou',
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
    final estudou = item['estudou'] as bool? ?? false;
    final assunto = item['assunto'] ?? '';
    final local = item['local'] ?? '';

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: estudou ? Colors.blue.shade100 : Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          estudou ? "Estudou" : "Não estudou",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: estudou ? Colors.blue.shade900 : Colors.grey.shade600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text("Data: $dataFormatada"),
            if (assunto.isNotEmpty) Text("Assunto: $assunto"),
            if (local.isNotEmpty) Text("Local: $local"),
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
        title: const Text("Estudo"),
        backgroundColor: const Color(0xFFFF7043),
        elevation: 6,
        shadowColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _registros.isEmpty
            ? const Center(
                child: Text(
                  "Nenhum registro de estudo ainda.",
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
        label: const Text("Novo Estudo"),
      ),
    );
  }
}
