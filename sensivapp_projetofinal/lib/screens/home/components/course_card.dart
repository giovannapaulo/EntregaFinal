import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.title,
    this.icon = Icons.sensors,
    this.color = const Color(0xFF7553F6),
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final finalCardColor = isDark ? color : color.withOpacity(0.15);
    final finalContentColor = isDark ? Colors.white : color;
    final finalSubtitleColor =
        isDark ? Colors.white.withOpacity(0.7) : color.withOpacity(0.6);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 280,
      height: 280,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: finalCardColor,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: isDark ? color.withOpacity(0.35) : color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: finalContentColor, size: 56),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  color: finalContentColor,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Dados em tempo real",
                style: TextStyle(
                  color: finalSubtitleColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
