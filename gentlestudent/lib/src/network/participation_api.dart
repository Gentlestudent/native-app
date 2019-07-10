import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';

class ParticipationApi {
  Future<List<Participation>> getAllParticipationsFromUser(String userId) async {
    return (await Firestore.instance
            .collection('Participations')
            .where("participantId", isEqualTo: userId)
            .getDocuments())
        .documents
        .map((snapshot) => Participation.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<bool> participationExists(
      FirebaseUser firebaseUser, Opportunity opportunity) async {
    return (await Firestore.instance
                .collection('Participations')
                .where("participantId", isEqualTo: firebaseUser.uid)
                .where("opportunityId", isEqualTo: opportunity.opportunityId)
                .getDocuments())
            .documents
            .length !=
        0;
  }

  Future<void> updateParticipationAfterBadgeClaim(
      Participation participation, String message) async {
    Map<String, dynamic> data = <String, dynamic>{
      "status": 1,
      "message": message,
    };
    await Firestore.instance
        .collection("Participations")
        .document(participation.participationId)
        .updateData(data)
        .whenComplete(() {
      print("Participation updated");
    }).catchError((e) => print(e));
  }

  Future<Participation> getParticipantByUserAndOpportunity(
      FirebaseUser firebaseUser, Opportunity opportunity) async {
    return Participation.fromDocumentSnapshot((await Firestore.instance
            .collection('Participations')
            .where("participantId", isEqualTo: firebaseUser.uid)
            .where("opportunityId", isEqualTo: opportunity.opportunityId)
            .getDocuments())
        .documents
        .first);
  }
}