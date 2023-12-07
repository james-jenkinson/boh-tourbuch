import 'package:sqflite_sqlcipher/sqflite.dart';

import '../databases/database.dart';
import '../models/faq_question.dart';

class FAQQuestionDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createFAQQuestion(FAQQuestion faqQuestion) async {
    final Database db = await _database.database;
    return db.insert(faqTable, toDatabaseJson(faqQuestion));
  }

  Future<int> updateFAQQuestion(FAQQuestion faqQuestion) async {
    final Database db = await _database.database;
    return await db.update(faqTable, toDatabaseJson(faqQuestion),
        where: 'id = ?', whereArgs: [faqQuestion.id]);
  }

  Future<int> deleteFAQQuestion(int faqQuestionId) async {
    final Database db = await _database.database;
    return await db
        .delete(faqTable, where: 'id = ?', whereArgs: [faqQuestionId]);
  }

  Future<List<FAQQuestion>> getAllFAQQuestion() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result = await db.query(faqTable);
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  FAQQuestion fromDatabaseJson(Map<String, dynamic> data) {
    return FAQQuestion(
      id: int.parse(data['id'].toString()),
      question: data['question'].toString().trim(),
      answer: data['answer'].toString().trim(),
    );
  }

  Map<String, dynamic> toDatabaseJson(FAQQuestion faqQuestion) => {
        'id': faqQuestion.id == -1 ? null : faqQuestion.id,
        'question': faqQuestion.question,
        'answer': faqQuestion.answer,
      };
}
