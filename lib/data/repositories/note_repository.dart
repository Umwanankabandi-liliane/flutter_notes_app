import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  CollectionReference get _notesCollection =>
      _firestore.collection('users').doc(_userId).collection('notes');

  Future<List<Note>> fetchNotes() async {
    try {
      final querySnapshot =
          await _notesCollection.orderBy('createdAt', descending: true).get();

      return querySnapshot.docs
          .map(
              (doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<void> addNote(String text) async {
    try {
      final now = DateTime.now();
      await _notesCollection.add({
        'text': text,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await _notesCollection.doc(id).update({
        'text': text,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
