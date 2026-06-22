import 'package:flutter/material.dart';

class AddSymptomBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialEntry;

  const AddSymptomBottomSheet({
    super.key,
    required this.onSave,
    this.initialEntry,
  });

  @override
  State<AddSymptomBottomSheet> createState() => _AddSymptomBottomSheetState();
}

class _AddSymptomBottomSheetState extends State<AddSymptomBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _triggerController;
  late TextEditingController _sobrecargaController;

  String intensity = "Baixa";

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.initialEntry?['titulo'] ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.initialEntry?['descricao'] ?? '',
    );

    _triggerController = TextEditingController(
      text: widget.initialEntry?['gatilho'] ?? '',
    );

    _sobrecargaController = TextEditingController(
      text: widget.initialEntry?['nivel_sobrecarga']?.toString() ?? '',
    );

    intensity = widget.initialEntry?['intensidade'] ?? "Baixa";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _triggerController.dispose();
    _sobrecargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initialEntry != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              editing ? "Editar Registro" : "Novo Registro",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Sintoma"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _triggerController,
              decoration: const InputDecoration(labelText: "Gatilho"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sobrecargaController,
              decoration: const InputDecoration(
                  labelText: "Nível de Sobrecarga (0-10)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: intensity,
              decoration: const InputDecoration(labelText: "Intensidade"),
              items: const [
                DropdownMenuItem(value: "Baixa", child: Text("Baixa")),
                DropdownMenuItem(value: "Média", child: Text("Média")),
                DropdownMenuItem(value: "Alta", child: Text("Alta")),
              ],
              onChanged: (value) {
                setState(() => intensity = value!);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final novoDado = {
                    'titulo': _titleController.text,
                    'descricao': _descriptionController.text,
                    'gatilho': _triggerController.text,
                    'intensidade': intensity,
                    'nivel_sobrecarga':
                        int.tryParse(_sobrecargaController.text) ?? 0,
                  };

                  widget.onSave(novoDado);
                  Navigator.pop(context);
                },
                child: Text(editing ? "Salvar Alterações" : "Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
