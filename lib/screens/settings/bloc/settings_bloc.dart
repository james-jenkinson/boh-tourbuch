import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/faq_question.dart';
import '../../../models/product_type.dart';
import '../../../repository/faq_question_repository.dart';
import '../../../repository/product_type_repository.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ProductTypeRepository _productTypeRepository = ProductTypeRepository();
  final FAQQuestionRepository _faqQuestionRepository = FAQQuestionRepository();

  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) async {
      if (event is LoadOrdersEvent) {
        final List<ProductType> productTypes =
            await _productTypeRepository.getProductTypes();
        final List<FAQQuestion> faqQuestions =
            await _faqQuestionRepository.getAllFAQQuestion();
        emit(DataLoaded(productTypes, faqQuestions));
      } else if (event is OpenProductTypeDialogEvent) {
        emit(OpenDialog(DialogType.product, productType: event.productType));
      } else if (event is OpenFAQQuestionDialogEvent) {
        emit(OpenDialog(DialogType.faq, faqQuestion: event.faqQuestion));
      } else if (event is DeleteProductTypeEvent) {
        if (event.shouldDelete == true) {
          await _productTypeRepository
              .deleteProductTypeById(event.productTypeId);
          final List<ProductType> productTypes =
              await _productTypeRepository.getProductTypes();
          final List<FAQQuestion> faqQuestions =
              await _faqQuestionRepository.getAllFAQQuestion();
          emit(DataLoaded(productTypes, faqQuestions));
        }
      } else if (event is DeleteFAQQuestionEvent) {
        if (event.shouldDelete == true) {
          await _faqQuestionRepository.deleteFAQQuestion(event.faqQuestionId);
          final List<ProductType> productTypes =
              await _productTypeRepository.getProductTypes();
          final List<FAQQuestion> faqQuestions =
              await _faqQuestionRepository.getAllFAQQuestion();
          emit(DataLoaded(productTypes, faqQuestions));
        }
      } else if (event is DialogClosedEvent) {
        final List<ProductType> productTypes =
            await _productTypeRepository.getProductTypes();
        final List<FAQQuestion> faqQuestions =
            await _faqQuestionRepository.getAllFAQQuestion();
        emit(DataLoaded(productTypes, faqQuestions));
      }
    });
  }
}
