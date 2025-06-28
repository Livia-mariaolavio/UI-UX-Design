import 'package:flutter/material.dart';
import 'package:novo/PraticarEsportePage.dart';
import 'package:novo/RelatorioDia.dart';
import 'package:novo/DescansoPage.dart';
import 'package:novo/TrabalhoPage.dart';
import 'package:novo/EstudoPage.dart';
import 'package:novo/NovaRotinaPage.dart';
import 'package:intl/intl.dart';
import 'package:novo/NotificacaoPage.dart';
import 'PerfilPage.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class RelatorioItem {
  final String titulo;
  final String hora;
  final String descricao; // novo campo descricao
  final IconData icone;
  final Color corIcone;

  RelatorioItem({
    required this.titulo,
    required this.hora,
    this.descricao = '', // valor padrão vazio
    required this.icone,
    required this.corIcone,
  });
}

class _HomePageState extends State<HomePage> {
  final List<DateTime> _descansosRegistrados = [];
  final List<RelatorioItem> _registros = [];
  int currentPageIndex = 0;
  final List<String> _rotinasCriadas = [];

  Widget buildMenuButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Ink(
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
                offset: const Offset(0, 6),
                blurRadius: 10,
              ),
            ],
          ),
          child: Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, size: 32, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // Página inicial com botões
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            // Descanso
            buildMenuButton("Descanso", Icons.bedtime, () async {
              final resultado = await Navigator.push<DateTime>(
                context,
                MaterialPageRoute(builder: (context) => DescansoPage()),
              );

              if (resultado != null) {
                setState(() {
                  // Adiciona no relatório geral também
                  _registros.add(
                    RelatorioItem(
                      titulo: 'Descansou',
                      hora: DateFormat('dd/MM/yyyy - HH:mm').format(resultado),
                      icone: Icons.bedtime,
                      corIcone: const Color.fromARGB(255, 243, 242, 241),
                    ),
                  );
                  _descansosRegistrados.add(resultado);
                });
              }
            }),

            buildMenuButton("Trabalho", Icons.work_outline, () async {
              final Map<String, String>? resultado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrabalhoPage()),
              );
              if (resultado != null) {
                setState(() {
                  _registros.add(
                    RelatorioItem(
                      titulo: resultado['titulo'] ?? 'Trabalhou',
                      hora: resultado['hora'] ?? '',
                      icone: Icons.work_outline,
                      corIcone: Colors.white,
                    ),
                  );
                });
              }
            }),

            buildMenuButton("Esporte", Icons.sports_soccer_outlined, () async {
              final Map<String, String>? resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PraticarEsportePage(),
                ),
              );
              if (resultado != null) {
                setState(() {
                  _registros.add(
                    RelatorioItem(
                      titulo: resultado['titulo'] ?? 'Praticou esportes',
                      hora: resultado['hora'] ?? '',
                      icone: Icons.sports_soccer,
                      corIcone: Colors.white,
                    ),
                  );
                });
              }
            }),

            buildMenuButton("Estudo", Icons.school_outlined, () async {
              final Map<String, String>? resultado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EstudoPage()),
              );
              if (resultado != null) {
                setState(() {
                  _registros.add(
                    RelatorioItem(
                      titulo: resultado['titulo'] ?? 'Estudou',
                      hora: resultado['hora'] ?? '',
                      icone: Icons.school_outlined,
                      corIcone: Colors.white,
                    ),
                  );
                });
              }
            }),

            buildMenuButton("Nova Rotina", Icons.schedule, () async {
              final Map<String, dynamic>? resultado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NovaRotinaPage()),
              );
              if (resultado != null) {
                setState(() {
                  _registros.add(
                    RelatorioItem(
                      titulo: resultado['titulo'] ?? 'Nova rotina',
                      descricao: resultado['descricao'] ?? '',
                      hora: resultado['dataHora'] ?? '',
                      icone: Icons.schedule,
                      corIcone: Colors.white,
                    ),
                  );
                  _rotinasCriadas.add(resultado['titulo'] ?? 'Nova rotina');
                });
              }
            }),

            const SizedBox(height: 20),
            if (_rotinasCriadas.isNotEmpty)
              const Text(
                'Minhas Rotinas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ..._rotinasCriadas.asMap().entries.map((entry) {
              int index = entry.key;
              String nome = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Você clicou em "$nome"')),
                    );
                  },
                  child: Ink(
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
                          offset: const Offset(0, 6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Container(
                      height: 65,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.task_alt,
                            size: 32,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _rotinasCriadas.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),

      // Página Notificações real (integrada)
      const NotificacaoPage(),

      // Página Perfil (ainda não criada, placeholder)
      const PerfilPage(),

      // Página Relatório
      RelatorioDia(registros: _registros),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043), // Laranja bonito
        centerTitle: true, // Centraliza o título
        elevation: 6,
        shadowColor: Colors.deepOrangeAccent,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Color.fromARGB(255, 241, 240, 240),
                Color(0xFFFFF8F3),
                Color.fromARGB(255, 250, 249, 248),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            "Zenday",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white, // Cor da máscara
              letterSpacing: 2,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 241, 239, 239),
        backgroundColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notificações',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Relatório',
          ),
        ],
      ),
    );
  }

  Widget _buildCenteredIconPage(IconData icon, String label) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 120, color: Colors.deepOrange),
          const SizedBox(height: 24),
          Text(
            label,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoProgresso() {
    // Contar ocorrências por tipo
    final Map<String, int> contagem = {
      'Descanso': 0,
      'Trabalho': 0,
      'Esporte': 0,
      'Estudo': 0,
      'Rotina': 0,
    };

    for (var item in _registros) {
      if (item.titulo.contains('Descans'))
        contagem['Descanso'] = contagem['Descanso']! + 1;
      else if (item.titulo.contains('Trabalh'))
        contagem['Trabalho'] = contagem['Trabalho']! + 1;
      else if (item.titulo.contains('Esport'))
        contagem['Esporte'] = contagem['Esporte']! + 1;
      else if (item.titulo.contains('Estud'))
        contagem['Estudo'] = contagem['Estudo']! + 1;
      else
        contagem['Rotina'] = contagem['Rotina']! + 1;
    }

    final cores = [
      Colors.orange.shade300,
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.purple.shade300,
      Colors.red.shade300,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 10),
          child: Text(
            "Progresso da Semana:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final labels = contagem.keys.toList();
                      return Text(
                        labels[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: false),
              barGroups: List.generate(contagem.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: contagem.values.toList()[i].toDouble(),
                      color: cores[i],
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
