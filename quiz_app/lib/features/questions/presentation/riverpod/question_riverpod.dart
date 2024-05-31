// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/features/questions/domain/usecases/create_question_usecase.dart';
import 'package:quiz_app/features/questions/domain/usecases/delete_question_usecase.dart';
import 'package:quiz_app/features/questions/domain/usecases/fetch_questions_usecase.dart';
import 'package:quiz_app/features/questions/domain/usecases/update_question_usecase.dart';
import 'package:quiz_app/features/questions/presentation/bloc/question_event.dart';
import 'package:quiz_app/features/questions/presentation/bloc/question_state.dart';

// Bloc class for handling question-related events and states
class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final CreateQuestion createQuestion; // Use case for creating a question
  final DeleteQuestion deleteQuestion; // Use case for deleting a question
  final FetchQuestions fetchQuestions; // Use case for fetching questions
  final UpdateQuestion updateQuestion; // Use case for updating a question

  // Constructor for initializing the Bloc with necessary use cases
  QuestionBloc({
    required this.createQuestion,
    required this.deleteQuestion,
    required this.fetchQuestions,
    required this.updateQuestion,
  }) : super(QuestionInitial()) {
    // Event handlers
    on<FetchQuestionsEvent>(_onFetchQuestions);
    on<CreateQuestionEvent>(_onCreateQuestion);
    on<UpdateQuestionEvent>(_onUpdateQuestion);
    on<DeleteQuestionEvent>(_onDeleteQuestion);
  }

  // Event handler for fetching questions
  Future<void> _onFetchQuestions(
      FetchQuestionsEvent event, Emitter<QuestionState> emit) async {
    emit(QuestionLoading()); // Emit loading state
    final result = await fetchQuestions();
    result.fold(
      (failure) => emit(
          QuestionFetchError('Failed to load questions')), // Emit error state
      (questions) =>
          emit(QuestionLoaded(questions)), // Emit loaded state with questions
    );
  }

  // Event handler for creating a question
  Future<void> _onCreateQuestion(
      CreateQuestionEvent event, Emitter<QuestionState> emit) async {
    emit(QuestionLoading()); // Emit loading state
    final result = await createQuestion(event.question);
    result.fold(
      (failure) =>
          emit(QuestionError('Failed to create question')), // Emit error state
      (success) => emit(QuestionSuccess(success.message)), // Emit success state
    );
  }

  // Event handler for updating a question
  Future<void> _onUpdateQuestion(
      UpdateQuestionEvent event, Emitter<QuestionState> emit) async {
    emit(QuestionLoading()); // Emit loading state
    final result = await updateQuestion(event.question);
    result.fold(
      (failure) =>
          emit(QuestionError('Failed to update question')), // Emit error state
      (success) => emit(QuestionSuccess(success.message)), // Emit success state
    );
  }

  // Event handler for deleting a question
  Future<void> _onDeleteQuestion(
      DeleteQuestionEvent event, Emitter<QuestionState> emit) async {
    emit(QuestionLoading()); // Emit loading state
    final result = await deleteQuestion(event.question);
    result.fold(
      (failure) =>
          emit(QuestionError('Failed to delete question')), // Emit error state
      (success) => emit(QuestionSuccess(success.message)), // Emit success state
    );
  }
}
