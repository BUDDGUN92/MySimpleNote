/// A widget that represents a single note item in a list.
///
/// This widget is built using [HookConsumerWidget] to manage state and focus handling.
/// It displays a note with a checkbox for completion status and a text field that
/// becomes editable when focused.
///
/// Features:
/// * Displays note description as text when unfocused
/// * Transforms into editable text field when focused
/// * Checkbox to toggle note completion status
/// * Auto-saves changes when focus is lost
/// * Material design with elevation for visual hierarchy
///
/// The widget manages two types of focus:
/// * [itemFocusNode] - Controls the focus state of the entire item
/// * [textFieldFocusNode] - Controls the focus state of the text field specifically
///
/// Parameters:
/// * [note] - The [Note] object containing the data to be displayed
///
/// Example:
/// ```dart
/// NoteItem(
///   note: Note(
///     id: '1',
///     description: 'Sample note',
///     completed: false,
///   ),
/// )
/// ```
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'hooks/focused_hook.dart';

class NoteItem extends HookConsumerWidget {
  final Note note;

  const NoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemFocusNode = useFocusNode();
    final itemIsFocused = useIsFocused(itemFocusNode);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            textEditingController.text = note.description;
          } else {
            ref
                .read(notesProviderProvider.notifier)
                .edit(id: note.id, description: textEditingController.text);
          }
        },
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: note.completed,
            onChanged: (value) =>
                ref.read(notesProviderProvider.notifier).toggle(note.id),
          ),
          title: itemIsFocused
              ? TextField(
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                  controller: textEditingController,
                )
              : Text(note.description),
        ),
      ),
    );
  }
}
