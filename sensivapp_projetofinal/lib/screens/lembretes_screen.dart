import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../core/app_theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../screens/userprofile_screen.dart';
import '../model/reminder_model.dart';
import '../widgets/reminder_card.dart';
import '../widgets/add_reminder_bottom_sheet.dart';
import '../providers/lembrete_provider.dart';

class LembretesScreen extends StatefulWidget {
  const LembretesScreen({super.key});

  @override
  State<LembretesScreen> createState() => _LembretesScreenState();
}

class _LembretesScreenState extends State<LembretesScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late String _currentMonthYear;
  late String _selectedDayFormatted;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _selectedDay = _focusedDay;
    _updateStrings();
  }

  void _updateStrings() {
    String monthText =
        DateFormat("MMMM 'de' yyyy", "pt_BR").format(_focusedDay);
    _currentMonthYear =
        monthText.substring(0, 1).toUpperCase() + monthText.substring(1);
    _selectedDayFormatted = DateFormat("d 'de' MMMM 'de' yyyy", "pt_BR")
        .format(_selectedDay ?? _focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF7553F6) : AppTheme.pastelPurple;
    final navContentColor = isDark ? Colors.white : AppTheme.textPurpleDark;

    return Consumer<LembreteProvider>(
      builder: (context, provider, child) {
        final targetDay = _selectedDay ?? _focusedDay;
        final currentReminders = provider.reminders
            .where((r) =>
                r.date.year == targetDay.year &&
                r.date.month == targetDay.month &&
                r.date.day == targetDay.day)
            .toList();

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          appBar: AppBar(
            backgroundColor: navColor,
            elevation: 0,
            title: Text("SensivApp", style: TextStyle(color: navContentColor)),
            leading: IconButton(
              icon:
                  Icon(Icons.arrow_back_ios, color: navContentColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              const ThemeToggleButton(),
              IconButton(
                icon: Icon(Icons.person, color: navContentColor),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UserProfileScreen())),
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 15),
                  _buildMonthSelector(isDark),
                  const SizedBox(height: 10),
                  const Text("Lembretes",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A55A2))),
                  _buildCalendar(provider, isDark),
                  const SizedBox(height: 15),
                  Text("Dia selecionado: $_selectedDayFormatted",
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              isDark ? Colors.white60 : Colors.grey.shade600)),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: currentReminders.length,
                      itemBuilder: (context, index) => ReminderCard(
                        reminder: currentReminders[index],
                        onTap: () => _showOptionsDialog(
                            context, provider, currentReminders[index]),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => _showAddReminder(context, provider),
                    child: _buildAddButton(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthSelector(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(Icons.chevron_left,
                  color: isDark ? Colors.white70 : const Color(0xFF4A4A4A)),
              onPressed: () => setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month - 1);
                    _updateStrings();
                  })),
          Expanded(
              child: Text(_currentMonthYear,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF4A4A4A)))),
          IconButton(
              icon: Icon(Icons.chevron_right,
                  color: isDark ? Colors.white70 : const Color(0xFF4A4A4A)),
              onPressed: () => setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month + 1);
                    _updateStrings();
                  })),
        ],
      ),
    );
  }

  Widget _buildCalendar(LembreteProvider provider, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        locale: 'pt_BR',
        headerVisible: false,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (s, f) => setState(() {
          _selectedDay = s;
          _focusedDay = f;
          _updateStrings();
        }),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final hasReminders =
                provider.reminders.any((r) => isSameDay(r.date, day));
            return Container(
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: hasReminders
                      ? const Color(0xFFB4C7FF)
                      : const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(8)),
              child: Text('${day.day}',
                  style: TextStyle(
                      color: const Color(0xFF4A4A4A),
                      fontWeight:
                          hasReminders ? FontWeight.bold : FontWeight.w500)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(colors: [
            Color(0xFFD2E0FB),
            Color(0xFFF9F1F6),
            Color(0xFFFBCFEE)
          ])),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.add, color: Color(0xFF4A55A2), size: 20),
        SizedBox(width: 6),
        Text("Novo Lembrete",
            style: TextStyle(
                color: Color(0xFF4A55A2), fontWeight: FontWeight.bold))
      ]),
    );
  }

  void _showOptionsDialog(BuildContext context, LembreteProvider provider,
      ReminderModel reminder) {}

  void _showAddReminder(BuildContext context, LembreteProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddReminderBottomSheet(
        onSave: (newReminder) {
          newReminder.date = _selectedDay ?? DateTime.now();
          provider.adicionarLembrete(newReminder);
        },
      ),
    );
  }
}
