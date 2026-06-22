import 'package:flutter/material.dart';

class Course {
  final String title;
  final IconData icon;
  final Color color;

  Course({
    required this.title,
    this.icon = Icons.sensors,
    this.color = const Color(0xFF7553F6),
  });
}

final List<Course> courses = [
  Course(
      title: "Ruído Externo",
      icon: Icons.volume_up,
      color: const Color(0xFF7553F6)),
  Course(
      title: "Luminosidade",
      icon: Icons.light_mode,
      color: const Color(0xFF80A4FF)),
  Course(
      title: "Nível de Estresse",
      icon: Icons.psychology,
      color: const Color(0xFF9B51E0)),
  Course(
      title: "Frequência Cardíaca",
      icon: Icons.favorite,
      color: const Color(0xFFF2994A)),
];

final List<Course> recentCourses = [
  Course(title: "Usar abafadores", color: const Color(0xFF7553F6)),
  Course(title: "Reduzir brilho da tela", color: const Color(0xFF242632)),
  Course(title: "Pausa em local calmo", color: const Color(0xFF7553F6)),
  Course(title: "Exercício de respiração", color: const Color(0xFF242632)),
  Course(title: "Tomar medicação (10h)", color: const Color(0xFFF77D8E)),
];
