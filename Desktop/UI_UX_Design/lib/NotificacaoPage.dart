import 'package:flutter/material.dart';

class NotificacaoPage extends StatefulWidget {
  const NotificacaoPage({super.key});

  @override
  State<NotificacaoPage> createState() => _NotificacaoPageState();
}

class NotificacaoItem {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color corIcone;

  NotificacaoItem({
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.corIcone,
  });
}

class _NotificacaoPageState extends State<NotificacaoPage> {
  final List<NotificacaoItem> _notificacoes = [
    NotificacaoItem(
      titulo: 'Estudar',
      descricao: 'Não esqueça de revisar suas matérias!',
      icone: Icons.school_outlined,
      corIcone: Colors.blue,
    ),
    NotificacaoItem(
      titulo: 'Trabalhar',
      descricao: 'Hora de focar nas tarefas do trabalho.',
      icone: Icons.work_outline,
      corIcone: Colors.green,
    ),
    NotificacaoItem(
      titulo: 'Praticar Esportes',
      descricao: 'Vamos movimentar o corpo! Pratique algum esporte.',
      icone: Icons.sports_soccer,
      corIcone: Colors.orange,
    ),
    NotificacaoItem(
      titulo: 'Descanso',
      descricao: 'Lembre-se de tirar pausas para descansar.',
      icone: Icons.bedtime,
      corIcone: Colors.deepPurple,
    ),
    NotificacaoItem(
      titulo: 'Nova Rotina',
      descricao: 'Crie uma nova rotina para organizar seu dia.',
      icone: Icons.schedule,
      corIcone: Colors.deepOrange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notificacoes.length,
        itemBuilder: (context, index) {
          final item = _notificacoes[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(item.icone, color: item.corIcone, size: 40),
              title: Text(
                item.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(item.descricao),
              trailing: IconButton(
                icon: const Icon(
                  Icons.notifications_active,
                  color: Colors.deepOrange,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lembrete: ${item.titulo}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
