/// A Riverpod provider that manages the state of notes in the application.
///
/// This provider handles CRUD operations for notes, including:
/// * Fetching notes from the local database
/// * Adding new notes
/// * Toggling note completion status
/// * Editing note descriptions
/// * Removing notes
///
/// The state is maintained as an [AsyncValue] of [List<Note>].
///
/// Example usage:
/// ```dart
/// final notesProvider = ref.watch(notesProviderProvider);
/// ```
///
/// Methods:
/// - [build]: Initializes the provider by fetching notes from the database
/// - [add]: Creates and stores a new note
/// - [toggle]: Toggles the completion status of a note
/// - [edit]: Updates the description of an existing note
/// - [remove]: Deletes a note from storage
/// - [fetchNotes]: Refreshes the note list from the database
///
/// Dependencies:
/// - Requires [DatabaseHelper] for persistence
/// - Uses [Uuid] for generating unique IDs
/// - Implements [riverpod_annotation] for state management
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/db_helper.dart';
import '../models/note.dart';

part 'notes_provider.g.dart';

@riverpod
class NotesProvider extends _$NotesProvider {
  @override
  Future<List<Note>> build() async {
    final dbHelper = DatabaseHelper.instance;
    final notes = await dbHelper.fetchNotes();
    return notes
        .map((note) => Note(
              id: note['id'],
              description: note['description'],
              completed: note['completed'] == 1,
            ))
        .toList();
  }

  Future<void> add(String description) async {
    const uuid = Uuid();
    final newNote = Note(
      id: uuid.v4(),
      description: description,
    );

    await DatabaseHelper.instance.insertNote(newNote);

    state = AsyncData([...state.value ?? [], newNote]);
  }

  Future<void> toggle(String id) async {
    if (state.value == null) return;

    final note = state.value!.firstWhere((note) => note.id == id);
    final updatedNote = Note(
      id: note.id,
      completed: !note.completed,
      description: note.description,
    );

    await DatabaseHelper.instance.updateNote(updatedNote);

    state = AsyncData([
      for (final note in state.value!)
        if (note.id == id) updatedNote else note,
    ]);
  }

  Future<void> edit({required String id, required String description}) async {
    if (state.value == null) return;

    final note = state.value!.firstWhere((note) => note.id == id);
    final updatedNote = Note(
      id: note.id,
      completed: note.completed,
      description: description,
    );

    // Update in database
    await DatabaseHelper.instance.updateNote(updatedNote);

    state = AsyncData([
      for (final note in state.value!)
        if (note.id == id) updatedNote else note,
    ]);
  }

  Future<void> remove(Note target) async {
    if (state.value == null) return;

    await DatabaseHelper.instance.deleteNote(target.id);

    state =
        AsyncData(state.value!.where((note) => note.id != target.id).toList());
  }

  Future<void> fetchNotes() async {
    final dbHelper = DatabaseHelper.instance;
    final notes = await dbHelper.fetchNotes();

    state = AsyncData(notes
        .map((note) => Note(
              id: note['id'],
              description: note['description'],
              completed: note['completed'] == 1,
            ))
        .toList());
  }
}
