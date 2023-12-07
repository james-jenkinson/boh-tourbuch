import '../dao/faq_question_dao.dart';
import '../models/faq_question.dart';

class FAQQuestionRepository {
  final _faqQuestionDao = FAQQuestionDao();

  Future<int> createFAQQuestion(FAQQuestion faqQuestion) =>
      _faqQuestionDao.createFAQQuestion(faqQuestion);

  Future<List<FAQQuestion>> getAllFAQQuestion() =>
      _faqQuestionDao.getAllFAQQuestion();

  Future<int> deleteFAQQuestion(int id) async =>
    _faqQuestionDao.deleteFAQQuestion(id);


  Future<int> updateFAQQuestion(FAQQuestion faqQuestion) =>
      _faqQuestionDao.updateFAQQuestion(faqQuestion);
}
