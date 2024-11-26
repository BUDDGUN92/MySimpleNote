/// Returns the count of uncompleted notes in the application.
///
/// This provider watches the [notesProviderProvider] and calculates
/// the number of notes that are not marked as completed.
/// Returns 0 when the notes are loading or if there's an error.

/// Returns a filtered list of notes based on the current filter selection.
///
/// This provider combines the current filter state from [noteFilterProvider]
/// and the notes from [notesProviderProvider] to return:
/// - All completed notes when filter is [NoteListFilter.completed]
/// - All active (uncompleted) notes when filter is [NoteListFilter.active]
/// - All notes when filter is [NoteListFilter.all]
///
/// Returns an empty list when notes are loading or if there's an error.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../enums/notelist_filter.dart';
import '../models/note.dart';
import 'note_filter_provider.dart';
import 'notes_provider.dart';
part 'providers.g.dart';

@riverpod
int uncompletedNotesCount(UncompletedNotesCountRef ref) {
  final notesValue = ref.watch(notesProviderProvider);
  return notesValue.when(
    data: (notes) => notes.where((note) => !note.completed).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

@riverpod
List<Note> filteredNote(FilteredNoteRef ref) {
  final filter = ref.watch(noteFilterProvider);
  final notesValue = ref.watch(notesProviderProvider);

  return notesValue.when(
    data: (notes) {
      switch (filter) {
        case NoteListFilter.completed:
          return notes.where((note) => note.completed).toList();
        case NoteListFilter.active:
          return notes.where((note) => !note.completed).toList();
        case NoteListFilter.all:
          return notes;
      }
    },
    loading: () => [],
    error: (_, __) => [],
  );
}
