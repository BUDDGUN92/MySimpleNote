/// A toolbar widget that displays note filtering options and count.
///
/// This widget is part of the note management UI and provides:
/// * Display of remaining uncompleted note count
/// * Filter buttons for viewing all, active, or completed notes
/// * Visual feedback for currently selected filter
///
/// The toolbar uses [HookConsumerWidget] to access the following providers:
/// * [noteFilterProvider] - manages the current filter state
/// * [uncompletedNotesCountProvider] - tracks count of uncompleted notes
///
/// Example:
/// ```dart
/// Toolbar(
///   key: Key('toolbar'),
/// )
/// ```
///
/// The toolbar supports three filtering modes:
/// * All - shows all notes
/// * Active - shows only uncompleted notes
/// * Completed - shows only completed notes
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/notelist_filter.dart';
import '../providers/note_filter_provider.dart';
import '../providers/providers.dart';

class Toolbar extends HookConsumerWidget {
  const Toolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(noteFilterProvider);

    Color? textColorFor(NoteListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${ref.watch(uncompletedNotesCountProvider)} items left',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            message: 'All Notes',
            child: TextButton(
              onPressed: () => ref.read(noteFilterProvider.notifier).setFilter(
                    NoteListFilter.all,
                  ),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor:
                    WidgetStatePropertyAll(textColorFor(NoteListFilter.all)),
              ),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            message: 'Only uncompleted Notes',
            child: TextButton(
              onPressed: () => ref.read(noteFilterProvider.notifier).setFilter(
                    NoteListFilter.active,
                  ),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(NoteListFilter.active),
                ),
              ),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            message: 'Only completed Notes',
            child: TextButton(
              onPressed: () => ref.read(noteFilterProvider.notifier).setFilter(
                    NoteListFilter.completed,
                  ),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(NoteListFilter.completed),
                ),
              ),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}
