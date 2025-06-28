import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovaRotinaPage extends StatefulWidget {
  const NovaRotinaPage({super.key});

  @override
  State<NovaRotinaPage> createState() => _NovaRotinaPageState();
}

class _NovaRotinaPageState extends State<NovaRotinaPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;

  void _selecionarDataHora() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      final hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (hora != null) {
        setState(() {
          _dataSelecionada = data;
          _horaSelecionada = hora;
        });
      }
    }
  }

  void _salvarRotina() {
    final titulo = _tituloController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o título da rotina')),
      );
      return;
    }

    String dataFormatada = 'Sem data definida';
    if (_dataSelecionada != null && _horaSelecionada != null) {
      final dataHora = DateTime(
        _dataSelecionada!.year,
        _dataSelecionada!.month,
        _dataSelecionada!.day,
        _horaSelecionada!.hour,
        _horaSelecionada!.minute,
      );
      dataFormatada = DateFormat('dd/MM/yyyy - HH:mm').format(dataHora);
    }

    Navigator.pop(context, {
      'titulo': titulo,
      'descricao': descricao,
      'dataHora': dataFormatada,
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String textoDataHora;
    if (_dataSelecionada != null && _horaSelecionada != null) {
      final dataHora = DateTime(
        _dataSelecionada!.year,
        _dataSelecionada!.month,
        _dataSelecionada!.day,
        _horaSelecionada!.hour,
        _horaSelecionada!.minute,
      );
      textoDataHora = DateFormat('dd/MM/yyyy - HH:mm').format(dataHora);
    } else {
      textoDataHora = 'Selecione data e hora';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Rotina'),
        backgroundColor: const Color(0xFFFF7043),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selecionarDataHora,
              icon: const Icon(Icons.calendar_today),
              label: Text(textoDataHora),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // ✅ Botão verde
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _salvarRotina,
              child: const Text(
                'Salvar Rotina',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ), // ✅ Texto branco para contraste
              ),
            ),
          ],
        ),
      ),
    );
  }
}
