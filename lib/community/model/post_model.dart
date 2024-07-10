import 'package:kaist_summer_camp_second_week/user/model/user_model.dart';

class PostModel {
  final String id;
  final String title;
  final String content;
  final String region;
  final String topic;
  final int boardId; // 1,2,3,4 중에 하나여야만 함.
  final User owner; // 글을 쓴 유저의 uid를 저장하는 변수
  final List<String> likesUid; // 좋아요를 누른 유저의 uid를 저장하는 변수
  final List<CommentModel> comments; // 댓글을 저장하는 변수
  final DateTime createdAt; // 글이 작성된 시간을 저장하는 변수
  final List<String> imageUrl; // 이미지 url을 저장하는 변수
  final int viewCount ; // 조회수를 저장하는 변수

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.region,
    required this.topic,
    required this.boardId,
    required this.owner,
    required this.likesUid,
    required this.comments,
    required this.createdAt,
    required this.imageUrl,
    required this.viewCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      region: json['region'] ?? '',
      topic: json['topic'] ?? '',
      boardId: json['board'] is int ? json['board'] : int.parse(json['board']),
      owner: User.fromJson(json['owner']),
      likesUid: List<String>.from(json['likes']),
      comments: List<CommentModel>.from(json['comments'].map((comment) => CommentModel.fromJson(comment))),
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: List<String>.from(json['imageUrls']),
      viewCount: json['views'] is int ? json['views'] : int.parse(json['views']),
    );
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? content,
    String? region,
    String? topic,
    int? boardId,
    User? owner,
    List<String>? likesUid,
    List<CommentModel>? comments,
    DateTime? createdAt,
    List<String>? imageUrl,
    int? viewCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      region: region ?? this.region,
      topic: topic ?? this.topic,
      boardId: boardId ?? this.boardId,
      owner: owner ?? this.owner,
      likesUid: likesUid ?? this.likesUid,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      viewCount: viewCount ?? this.viewCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}



class CommentModel {
  final String id;
  final String content;
  final User owner;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.content,
    required this.owner,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      content: json['content'],
      owner: User.fromJson(json['owner']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  CommentModel copyWith({
    String? id,
    String? content,
    User? owner,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}