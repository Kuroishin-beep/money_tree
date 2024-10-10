import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tracker_model.dart';

class FirestoreService {
  // get collection of tracks
  final CollectionReference tracks = FirebaseFirestore.instance.collection('tracks');

  // CREATE: add new income, expenses, budget, and savings
  Future<void> addTrack(Tracker track) {
    return tracks.add({
      'name': track.name,
      'category': track.category,
      'account': track.account,
      'amount': track.amount,
      'type': track.type,
      'date': track.date.toIso8601String(),
    });
  }

  // READ: get data from database
  Stream<QuerySnapshot> getTracksStream() {
    final tracksStream = tracks.orderBy('date', descending: true).snapshots();

    return tracksStream;
  }

  // UPDATE: edit income, expenses, budget, and savings
  Future<void> updateTrack(String docID, Tracker newTrack) {
    return tracks.doc(docID).update({
      'name': newTrack.name,
      'category': newTrack.category,
      'account': newTrack.account,
      'amount': newTrack.amount,
      'type': newTrack.type,
      'date': newTrack.date.toIso8601String(),
    });
  }

  // DELETE: delete transactions
  Future<void> deleteTrack(String docID) {
    return tracks.doc(docID).delete();
  }
}