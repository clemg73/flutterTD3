import 'user.dart';

class Vote {
  Vote({
    required this.pollId,
    required this.status,
    required this.created,
    required this.user,
  });
  int pollId;
  bool status;
  DateTime created;
  User user;

  Vote.fromJson(Map<String, dynamic> json)
      : this(
            pollId: json['pollId'] as int,
            status: json['status'] as bool,
            created: DateTime.parse(json['created']),
            user: User.fromJson(json['user']) as User);
}
