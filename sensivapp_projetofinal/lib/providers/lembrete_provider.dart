import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../model/reminder_model.dart';

class LembreteProvider with ChangeNotifier {
  List<ReminderModel> _lembretes = [];
  final NotificationService _notifService = NotificationService();

  List<ReminderModel> get reminders => _lembretes;

  LembreteProvider() {
    _initService();
  }

  Future<void> _initService() async {
    await _notifService.init();
    await carregarLembretes();
  }

  Future<void> carregarLembretes() async {
    try {
      final response = await ApiService().get('/lembretes');

      _lembretes = (response as List)
          .map((json) => ReminderModel(
                id: json['id_lembrete'],
                title: json['titulo'],
                createdBy: json['criado_por'],
                date: DateTime.parse(json['data_hora']),
              ))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao buscar lembretes: $e");
    }
  }

  Future<void> adicionarLembrete(ReminderModel novo) async {
    try {
      final response = await ApiService().post('/lembretes', {
        'titulo': novo.title,
        'data_hora': novo.date.toIso8601String(),
        'criado_por': novo.createdBy,
      });

      if (response != null) {
        await carregarLembretes();
      }
    } catch (e) {
      debugPrint("Erro ao adicionar: $e");
      rethrow;
    }
  }

  Future<void> editarLembrete(int id, String novoTitulo) async {
    try {
      await ApiService().put('/lembretes/$id', {'titulo': novoTitulo});

      final index = _lembretes.indexWhere((l) => l.id == id);
      if (index != -1) {
        _lembretes[index].title = novoTitulo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erro ao editar: $e");
    }
  }

  Future<void> deletarLembrete(int id) async {
    try {
      await ApiService().delete('/lembretes/$id');

      _lembretes.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao deletar: $e");
    }
  }
}
