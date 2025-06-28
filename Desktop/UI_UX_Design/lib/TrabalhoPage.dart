import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrabalhoPage extends StatefulWidget {
  const TrabalhoPage({super.key});

  @override
  State<TrabalhoPage> createState() => _TrabalhoPageState();
}

class _TrabalhoPageState extends State<TrabalhoPage> {
  final List<Map<String, dynamic>> _registros = [];

  // Função para adicionar novo registro
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

    bool trabalhou = false;
    String? local;

    // Diálogo para informações adicionais
    await showDialog(
      context: context,
      builder: (context) {
        final localController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Detalhes do Trabalho"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text("Trabalhou?"),
                    value: trabalhou,
                    onChanged: (val) {
                      setStateDialog(() {
                        trabalhou = val ?? false;
                      });
                    },
                  ),
                  TextField(
                    controller: localController,
                    decoration: const InputDecoration(
                      labelText: "Local do trabalho",
                    ),
                  ),
                ],
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

    // Monta o objeto com data/hora e informações
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
        'trabalhou': trabalhou,
        'local': local ?? '',
      });
    });

    // Fecha a página retornando os dados para o HomePage
    Navigator.pop(context, {
      'titulo': trabalhou ? 'Trabalhou' : 'Folga/Feriado',
      'hora': DateFormat('dd/MM/yyyy - HH:mm').format(dataHora),
    });
  }

  // Função para excluir um registro
  void _excluirRegistro(int index) {
    setState(() {
      _registros.removeAt(index);
    });
  }

  // Widget para exibir cada item
  Widget _buildRegistroItem(Map<String, dynamic> item, int index) {
    final dataHora = item['dataHora'] as DateTime;
    final trabalhou = item['trabalhou'] as bool? ?? false;
    final local = item['local'] ?? '';

    final dataFormatada = DateFormat('dd/MM/yyyy - HH:mm').format(dataHora);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: trabalhou ? Colors.green.shade100 : Colors.red.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          trabalhou ? "Trabalhou" : "Folga/Feriado",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: trabalhou ? Colors.green.shade900 : Colors.red.shade900,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text("Data: $dataFormatada"),
            Text("Local: $local"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _excluirRegistro(index),
        ),
      ),
    );
  }

  // Tela principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trabalho Pago"),
        backgroundColor: const Color(0xFFFF7043),
        elevation: 6,
        shadowColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _registros.isEmpty
            ? const Center(
                child: Text(
                  "Nenhum registro de trabalho ainda.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: _registros.length,
                itemBuilder: (context, index) =>
                    _buildRegistroItem(_registros[index], index),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarRegistro,
        backgroundColor: const Color(0xFFFF7043),
        icon: const Icon(Icons.add),
        label: const Text("Novo Trabalho"),
      ),
    );
  }
}
