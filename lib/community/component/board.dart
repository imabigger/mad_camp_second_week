enum Board {
  all,
  questionAndAnswer,
  together,
  sell,
  joke
}

extension BoardExtension on Board {
  String get name {
    switch (this) {
      case Board.all:
        return '전체';
      case Board.questionAndAnswer:
        return '묻고 답해요';
      case Board.together:
        return '함께 해요';
      case Board.sell:
        return '판매 해요';
      case Board.joke:
        return '농담 이야기';
    }
  }
}
