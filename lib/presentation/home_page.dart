import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/notes_provider.dart';
import '../providers/providers.dart';
import 'note_item_widget.dart';
import 'title_widget.dart';
import 'toolbar.dart';

/// A home screen widget that displays a list of notes and allows adding new notes.
///
/// This widget is a [HookConsumerWidget] that uses Riverpod for state management
/// and Flutter Hooks for managing the text controller.
///
/// Features:
/// * Displays a title widget at the top
/// * Provides a text field for adding new notes
/// * Shows a toolbar for filtering/managing notes
/// * Lists all notes with the ability to dismiss (delete) them
/// * Automatically unfocuses when tapping outside input fields
///
/// The notes are displayed in a scrollable list view with dividers between them.
/// Each note can be removed by swiping it away (using [Dismissible]).
///
/// Example:
/// ```dart
/// Home()
/// ```
class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(filteredNoteProvider);
    final newNoteController = useTextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            const TitleWidget(),
            TextField(
              controller: newNoteController,
              decoration: const InputDecoration(
                labelText: 'Add a Note',
              ),
              onSubmitted: (value) {
                ref.read(notesProviderProvider.notifier).add(value);
                newNoteController.clear();
              },
            ),
            const SizedBox(height: 42),
            const Toolbar(),
            if (notes.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < notes.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              Dismissible(
                key: ValueKey(notes[i].id),
                onDismissed: (_) {
                  ref.read(notesProviderProvider.notifier).remove(notes[i]);
                },
                child: NoteItem(note: notes[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
