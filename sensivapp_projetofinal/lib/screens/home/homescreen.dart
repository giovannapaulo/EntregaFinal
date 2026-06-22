import 'package:flutter/material.dart';
import '../../model/course.dart';
import '../../services/api_service.dart'; 
import 'components/course_card.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../core/app_theme.dart';
import '../userprofile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<dynamic>> _tarefasFuture;

  @override
  void initState() {
    super.initState();
    _tarefasFuture = ApiService.instance.get('/sessoes').then((data) => data as List<dynamic>);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scroll(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF7553F6) : AppTheme.pastelPurple;
    final navContentColor = isDark ? Colors.white : AppTheme.textPurpleDark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(navColor, navContentColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Monitoramento"),
            _buildMonitoramentoComSetas(),
            _buildSectionHeader("Tarefas Médicas"),
            _buildTarefasList(), 
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTarefasList() {
    return FutureBuilder<List<dynamic>>(
      future: _tarefasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Padding(padding: EdgeInsets.all(20), child: Text("Erro ao carregar tarefas."));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
              padding: EdgeInsets.all(20), child: Text("Sem tarefas no momento."));
        }

        return Column(
          children: snapshot.data!.map((tarefa) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const Icon(Icons.assignment, color: Color(0xFF7553F6)),
                  title: Text(tarefa['licao_de_casa'] ?? "Sem descrição"),
                  subtitle: Text("Data: ${tarefa['data_sessao'] ?? 'N/A'}"),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }


  AppBar _buildAppBar(Color bgColor, Color contentColor) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      iconTheme: IconThemeData(color: contentColor),
      title: Text("SensivApp",
          style: TextStyle(color: contentColor, fontWeight: FontWeight.bold)),
      actions: [
        const ThemeToggleButton(),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const UserProfileScreen())),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: contentColor.withOpacity(0.15),
              child: Icon(Icons.person_rounded, color: contentColor, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Text(title,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black)),
    );
  }

  Widget _buildMonitoramentoComSetas() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 300,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/details', arguments: course),
                  child: CourseCard(
                      title: course.title,
                      icon: course.icon,
                      color: course.color),
                ),
              );
            },
          ),
        ),
        Positioned(
            left: 5, child: _navArrow(Icons.chevron_left, () => _scroll(-300))),
        Positioned(
            right: 5,
            child: _navArrow(Icons.chevron_right, () => _scroll(300))),
      ],
    );
  }

  Widget _navArrow(IconData icon, VoidCallback onPress) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: IconButton(
          icon: Icon(icon, color: const Color(0xFF7553F6), size: 30),
          onPressed: onPress),
    );
  }
}