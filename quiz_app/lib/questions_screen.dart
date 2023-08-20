import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/data/questions.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
  });

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currenQuestionIndex = 0;

  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    //currenQuestionIndex = currenQuestionIndex + 1;
    //currenQuestionIndex += 1;
    setState(() {
      currenQuestionIndex++;
    });
  }

  @override
  Widget build(context) {
    final currentQuestion = questions[currenQuestionIndex];

    return SizedBox(
      width: double
          .infinity, // this is an alternative to wrap the column in a Center widget
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // this is an alternative to wrap the column in a Center widget
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            ...currentQuestion.getShuffledAnswers().map((answerText) {
              return AnswerButton(
                answerText: answerText,
                onTap: () {
                  answerQuestion(answerText);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
