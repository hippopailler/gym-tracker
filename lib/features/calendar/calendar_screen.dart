import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/formats.dart';
import '../../core/providers.dart';
import '../../domain/models/session_models.dart';
import '../../widgets/empty_state.dart';
import 'session_detail_sheet.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = dayKey(DateTime.now());
  bool _listView = false;

  @override
  Widget build(BuildContext context) {
    final byDayAsync = ref.watch(sessionsByDayProvider);
    final summariesAsync = ref.watch(sessionSummariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          IconButton(
            tooltip: _listView ? 'Vue calendrier' : 'Vue liste',
            icon: Icon(_listView ? Icons.calendar_month : Icons.view_list),
            onPressed: () => setState(() => _listView = !_listView),
          ),
        ],
      ),
      body: _listView
          ? _buildList(summariesAsync)
          : _buildCalendar(byDayAsync),
    );
  }

  Widget _buildCalendar(
      AsyncValue<Map<DateTime, List<SessionSummary>>> byDayAsync) {
    final scheme = Theme.of(context).colorScheme;
    return byDayAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erreur : $error')),
      data: (byDay) {
        final selectedSessions = byDay[_selectedDay] ?? const <SessionSummary>[];
        return Column(
          children: [
            TableCalendar<SessionSummary>(
              locale: 'fr_FR',
              firstDay: DateTime(2020),
              lastDay: DateTime.now().add(const Duration(days: 366)),
              focusedDay: _focusedDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {CalendarFormat.month: 'Mois'},
              eventLoader: (day) => byDay[dayKey(day)] ?? const [],
              selectedDayPredicate: (day) => dayKey(day) == _selectedDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = dayKey(selectedDay);
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                outsideDaysVisible: false,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: selectedSessions.isEmpty
                  ? EmptyState(
                      icon: Icons.self_improvement,
                      title: 'Repos',
                      message:
                          'Aucune séance le ${formatDateShort(_selectedDay)}.',
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        for (final summary in selectedSessions)
                          _SessionCard(summary: summary),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(AsyncValue<List<SessionSummary>> summariesAsync) {
    return summariesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erreur : $error')),
      data: (summaries) {
        if (summaries.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            title: 'Aucune séance',
            message: 'Ton historique apparaîtra ici après ta première séance.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: summaries.length,
          itemBuilder: (context, index) {
            final summary = summaries[index];
            final isNewMonth = index == 0 ||
                summaries[index - 1].session.date.month !=
                    summary.session.date.month ||
                summaries[index - 1].session.date.year !=
                    summary.session.date.year;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNewMonth)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
                    child: Text(
                      formatMonthYear(summary.session.date).capitalized(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                _SessionCard(summary: summary),
              ],
            );
          },
        );
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.summary});

  final SessionSummary summary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: () => showSessionDetailSheet(context, summary.session.id),
        leading: CircleAvatar(
          backgroundColor: scheme.primary.withValues(alpha: 0.15),
          child: Icon(Icons.fitness_center, color: scheme.primary, size: 20),
        ),
        title: Text(
          summary.session.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${formatDateShort(summary.session.date)} · '
          '${formatDuration(summary.session.durationSeconds)}\n'
          '${summary.exerciseCount} exercices · ${summary.setCount} séries · '
          '${formatVolume(summary.totalVolume)}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
