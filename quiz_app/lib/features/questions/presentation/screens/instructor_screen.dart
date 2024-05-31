// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/features/questions/domain/entities/question.dart';
import 'package:quiz_app/features/questions/presentation/bloc/question_bloc.dart';
import 'package:quiz_app/features/questions/presentation/bloc/question_event.dart';
import 'package:quiz_app/features/questions/presentation/bloc/question_state.dart';

// InstructorScreen widget for displaying and managing questions
class InstructorScreen extends StatefulWidget {
  const InstructorScreen({super.key});

  @override
  State<InstructorScreen> createState() => _InstructorScreenState();
}

class _InstructorScreenState extends State<InstructorScreen> {
  List<int?> selectedOptionIndices = [];
  List<bool> showExplanations = [];

  @override
  void initState() {
    super.initState();
    // Fetch questions when the screen is initialized
    BlocProvider.of<QuestionBloc>(context).add(FetchQuestionsEvent());
  }

  // Handle option selection for a question
  void _handleOptionSelected(int questionIndex, int optionIndex) {
    setState(() {
      selectedOptionIndices[questionIndex] = optionIndex;
      showExplanations[questionIndex] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Solve Questions'),
        ),
        body: BlocConsumer<QuestionBloc, QuestionState>(
          listener: (context, state) {
            // Display a SnackBar for success or error messages
            if (state is QuestionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Center(child: Text(state.message))),
              );
              BlocProvider.of<QuestionBloc>(context).add(FetchQuestionsEvent());
            } else if (state is QuestionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Center(child: Text(state.message))),
              );
              BlocProvider.of<QuestionBloc>(context).add(FetchQuestionsEvent());
            }
          },
          builder: (context, state) {
            // Show a loading indicator while fetching questions
            if (state is QuestionLoading) {
              return Center(child: CircularProgressIndicator());
            }
            // Display the questions when they are loaded
            else if (state is QuestionLoaded && state.questions.isNotEmpty) {
              final questions = state.questions;

              if (selectedOptionIndices.isEmpty) {
                selectedOptionIndices = List.filled(questions.length, null);
                showExplanations = List.filled(questions.length, false);
              }

              return Container(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    Question question = questions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  question.description,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to the question form for editing
                                  context.go('/question_form', extra: {
                                    'question': question,
                                    'edit': true
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  print('this will delete the question');
                                  // Trigger question deletion
                                  BlocProvider.of<QuestionBloc>(context)
                                      .add(DeleteQuestionEvent(question));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children:
                                question.options.asMap().entries.map((entry) {
                              int idx = entry.key;
                              String text = entry.value;
                              bool isSelected =
                                  selectedOptionIndices[index] == idx;
                              bool isCorrect =
                                  selectedOptionIndices[index] != null
                                      ? idx == question.answer
                                      : false;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: OptionButton(
                                  onPressed: () =>
                                      _handleOptionSelected(index, idx),
                                  title: text,
                                  isSelected: isSelected,
                                  isCorrect: isSelected ? isCorrect : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          // Show the explanation if an option has been selected
                          if (showExplanations[index])
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                question.explanation,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            // Show an error message if fetching questions failed
            else if (state is QuestionFetchError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No Questions Available'));
          },
        ),
        // Bottom navigation bar for navigation to other screens
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            if (index == 0) {
              context.push('/settings');
            } else if (index == 2) {
              context.go('/question_form',
                  extra: {'edit': false, 'question': null});
            } else if (index == 3) {
              context.push('/note');
            }
          },
          indicatorColor: Color(0xFF4280EF),
          selectedIndex: 1,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            NavigationDestination(
              icon: Icon(Icons.quiz),
              label: 'Solve Problems',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle),
              label: 'Add new Question',
            ),
            NavigationDestination(
              icon: Icon(Icons.note),
              label: 'Notebook',
            ),
          ],
        ),
      ),
    );
  }
}

// Custom button widget for displaying question options
class OptionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool? isCorrect;
  final bool isSelected;

  const OptionButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isCorrect,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Set the background color based on selection and correctness
    Color backgroundColor = Colors.white;
    if (isSelected) {
      backgroundColor = isCorrect == true ? Colors.green : Colors.red;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
