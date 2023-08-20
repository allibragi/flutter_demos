class QuizQuestion {
  const QuizQuestion(this.text, this.answers);

  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    // In the ansers list the first is always the right one
    // shuffle changes the order of the list
    // so we copy the list and then shuffle the copy
    // in this way we still have the oridinal list with the correct answer first
    final shuffledList = List.of(answers); // create a copy
    shuffledList.shuffle(); // shuffle the copy
    return shuffledList; // return the shuffled answers
  }
}
