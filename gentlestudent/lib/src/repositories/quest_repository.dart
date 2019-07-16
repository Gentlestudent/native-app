import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/network/quest_api.dart';

class QuestRepository {
  final QuestApi _questApi = QuestApi();

  List<Quest> _quests;
  Future<List<Quest>> get quests async {
    if (_quests == null || _quests.isEmpty) {
      await _fetchQuests();
    }
    return _quests;
  }

  Future<Quest> fetchQuestById(String questId) async {
    Quest quest;

    if (_quests == null || _quests.isEmpty) {
      quest = _quests.firstWhere((q) => q.questId == questId);
    }

    if (quest == null) {
      quest = await _questApi.fetchQuestById(questId);
    }

    return quest;
  }

  Future<List<QuestTaker>> fetchQuestTakersByQuestId(String questId) async {
    List<QuestTaker> questTakers = await _questApi.fetchQuestTakersByQuestId(questId);
    return questTakers;
  }

  Future<List<QuestTaker>> fetchQuestTakersByUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return [];

    List<QuestTaker> questTakers = await _questApi.fetchQuestTakersByUserId(user.uid);
    return questTakers;
  }

  Future<QuestTaker> fetchQuestTakerByQuestIdAndParticipantId(String questId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return null;

    QuestTaker questTaker = await _questApi.fetchQuestTakerByQuestIdAndParticipantId(user.uid, questId);
    return questTaker;
  }

  Future<void> _fetchQuests() async {
    _quests = await _questApi.fetchAllQuests();
  }
}
