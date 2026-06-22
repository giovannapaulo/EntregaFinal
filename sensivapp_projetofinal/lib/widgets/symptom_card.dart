import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class SymptomCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onTap;

  const SymptomCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  Color _intensityColor(String intensity) {
    switch (intensity.toLowerCase()) {
      case 'alta':
        return Colors.redAccent;
      case 'média':
      case 'media':
        return Colors.amber;
      case 'baixa':
        return Colors.green;
      default:
        return const Color(0xFFE8C8F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titulo = entry['titulo'] ?? 'Sem título';
    final descricao = entry['descricao'] ?? '';
    final gatilho = entry['gatilho'] ?? 'Nenhum';
    final intensidade = entry['intensidade']?.toString() ?? 'Baixa';

    final data = entry['data_hora'] != null
        ? DateTime.parse(entry['data_hora'])
        : DateTime.now();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242424) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                color: _intensityColor(intensidade),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textPurpleDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    descricao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _tag(titulo),
                      _tag(gatilho),
                      _tag("Grav: $intensidade"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD7E3F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}\n"
                "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D4863),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8C8F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5D4797),
        ),
      ),
    );
  }
}
