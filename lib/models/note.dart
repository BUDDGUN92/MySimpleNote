/// A class representing a note with a description, an ID, and a completion status.
///
/// The [Note] class is immutable and requires a description and an ID to be provided
/// upon instantiation. The completion status is optional and defaults to `false`.
///
/// Example usage:
///
/// ```dart
/// final note = Note(
///   id: '1',
///   description: Today I want to work on my Flutter app.',
/// );
/// print(note); // Output: Note(description: Buy groceries, completed: false)
/// ```
///
/// Properties:
/// - [id]: A unique identifier for the note.
/// - [description]: A brief description of the note.
/// - [completed]: A boolean indicating whether the note is completed or not.
import 'package:flutter/material.dart';

@immutable
class Note {
  const Note({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Note(description: $description, completed: $completed)';
  }
}
