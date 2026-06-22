import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../screens/userprofile_screen.dart';

class ArtigoDetalheScreen extends StatelessWidget {
  final Map<String, dynamic> artigo;

  const ArtigoDetalheScreen({super.key, required this.artigo});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF7553F6) : AppTheme.pastelPurple;
    final navContentColor = isDark ? Colors.white : AppTheme.textPurpleDark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: navColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: navContentColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("SensivApp",
            style: TextStyle(
                color: navContentColor,
                fontSize: 20,
                fontWeight: FontWeight.w400)),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: Icon(Icons.person, color: navContentColor),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const UserProfileScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              artigo['titulo'] ?? 'Sem título',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF4A55A2),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                artigo['imageUrl'] ?? 'https://via.placeholder.com/500',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Conteúdo do Artigo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? const Color(0xFFFFD1E8) : const Color(0xFF4A55A2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              artigo['conteudo'] ??
                  artigo['content'] ??
                  'Sem conteúdo disponível.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                color:
                    isDark ? const Color(0xFFE0E0E0) : const Color(0xFF4A4A4A),
                height: 1.6,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
