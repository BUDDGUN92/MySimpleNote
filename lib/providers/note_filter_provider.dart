/// A provider that manages the current filter state for the note list.
///
/// This provider allows setting and managing different filters for displaying notes
/// using [NoteListFilter] enum values.
///
/// Example:
/// ```dart
/// // Get current filter
/// final filter = ref.watch(noteFilterProvider);
///
/// // Set new filter
/// ref.read(noteFilterProvider.notifier).setFilter(NoteListFilter.completed);
/// ```
///
/// The default filter is [NoteListFilter.all].
///
/// See also:
///   * [NoteListFilter], which defines the available filter options
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../enums/notelist_filter.dart';

part 'note_filter_provider.g.dart';

@riverpod
class NoteFilter extends _$NoteFilter {
  @override
  NoteListFilter build() => NoteListFilter.all;

  void setFilter(NoteListFilter filter) {
    state = filter;
  }
}
