class ReminderModel {
  final int? id;
  String title;
  final String createdBy;
  DateTime date;

  ReminderModel({
    this.id,
    required this.title,
    required this.createdBy,
    required this.date,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id_lembrete'],
      title: json['titulo'],
      createdBy: json['criado_por'] ?? 'Você',
      date: DateTime.parse(json['data_hora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lembrete': id,
      'titulo': title,
      'criado_por': createdBy,
      'data_hora': date.toIso8601String(),
    };
  }
}
