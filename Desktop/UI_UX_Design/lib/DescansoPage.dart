import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DescansoPage extends StatefulWidget {
  final void Function(DateTime)? onRegistroAdicionado;

  const DescansoPage({super.key, this.onRegistroAdicionado});

  @override
  State<DescansoPage> createState() => _DescansoPageState();
}

class _DescansoPageState extends State<DescansoPage> {
  final List<Map<String, dynamic>> _registros = [];

  void _adicionarRegistro() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (dataSelecionada == null) return;

    final TimeOfDay? horaSelecionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horaSelecionada == null) return;

    final DateTime completo = DateTime(
      dataSelecionada.year,
      dataSelecionada.month,
      dataSelecionada.day,
      horaSelecionada.hour,
      horaSelecionada.minute,
    );

    setState(() {
      _registros.add({'dataHora': completo});
    });
    widget.onRegistroAdicionado?.call(completo);

    // Aqui você adiciona o retorno do registro pra HomePage
    Navigator.pop(context, completo);
  }

  void _editarRegistro(int index) async {
    final original = _registros[index]['dataHora'] as DateTime;

    final DateTime? novaData = await showDatePicker(
      context: context,
      initialDate: original,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (novaData == null) return;

    final TimeOfDay? novaHora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(original),
    );

    if (novaHora == null) return;

    final DateTime atualizado = DateTime(
      novaData.year,
      novaData.month,
      novaData.day,
      novaHora.hour,
      novaHora.minute,
    );

    setState(() {
      _registros[index]['dataHora'] = atualizado;
    });
  }

  void _excluirRegistro(int index) {
    setState(() {
      _registros.removeAt(index);
    });
  }

  Widget buildRegistroItem(DateTime dataHora, int index) {
    final formatado = DateFormat('dd/MM/yyyy - HH:mm').format(dataHora);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.orange.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.bedtime, size: 36, color: Colors.deepOrange),

        title: Text(
          formatado,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromARGB(255, 219, 198, 7),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _excluirRegistro(index),
        ),
        onTap: () => _editarRegistro(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Descanso"),
        backgroundColor: const Color(0xFFFF7043),
        elevation: 6,
        shadowColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _registros.isEmpty
            ? const Center(
                child: Text(
                  "Nenhum descanso registrado ainda.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView(
                children: _registros
                    .asMap()
                    .entries
                    .map((e) => buildRegistroItem(e.value['dataHora'], e.key))
                    .toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarRegistro,
        backgroundColor: const Color(0xFFFF7043),
        icon: const Icon(Icons.add),
        label: const Text("Adicionar Descanso"),
      ),
    );
  }
}
