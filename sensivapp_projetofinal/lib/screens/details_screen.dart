import 'package:flutter/material.dart';
import '../model/course.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../services/api_service.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  void _openFullScreenReport(BuildContext context, String title, Color color) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Relatório",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Relatório: $title"),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: FutureBuilder(
            future: ApiService.instance.get('/sessoes'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return const Center(child: Text("Nenhum dado disponível."));
              }

              final sessoes = snapshot.data as List;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Table(
                  border: TableBorder.all(
                      color: Colors.grey.withValues(alpha: 0.3)),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2)
                  },
                  children: [
                    const TableRow(children: [
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Anotações",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Lição de Casa",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ]),
                    ...sessoes.map((s) => TableRow(children: [
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(s['anotacoes_profissional'] ?? "-")),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(s['licao_de_casa'] ?? "-")),
                        ])),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final course = (args is Course)
        ? args
        : Course(title: "Detalhes", color: const Color(0xFF7553F6));

    bool isAudioType = course.title.toLowerCase().contains("ruído") ||
        course.icon == Icons.volume_up;

    final Color primaryColor = course.color;
    final Color headerColor =
        isDark ? primaryColor : primaryColor.withValues(alpha: 0.15);
    final Color contentColor = isDark ? Colors.white : primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(course.title,
            style: TextStyle(
                color: isDark ? Colors.white : primaryColor,
                fontWeight: FontWeight.bold)),
        actions: const [ThemeToggleButton(), SizedBox(width: 10)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroHeader(course, headerColor, contentColor, isDark),
            _buildBody(isAudioType, course, primaryColor, isDark, context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(
      Course course, Color bgColor, Color iconColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      child: Hero(
        tag: course.title,
        child: Icon(course.icon,
            size: 100, color: isDark ? Colors.white : iconColor),
      ),
    );
  }

  Widget _buildBody(bool isAudio, Course course, Color color, bool isDark,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sobre o Monitoramento",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 12),
          Text(
              isAudio
                  ? "Análise e mapeamento de frequências sonoras."
                  : "Acompanhamento contínuo de ${course.title}.",
              style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.5)),
          const SizedBox(height: 35),
          InkWell(
            onTap: () => _openFullScreenReport(context, course.title, color),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25)),
              child: Row(children: [
                Icon(Icons.table_chart, color: color),
                const SizedBox(width: 15),
                const Text("Ver Relatório em Tabela",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
