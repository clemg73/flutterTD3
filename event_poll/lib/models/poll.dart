import 'vote.dart';

class Poll {
  Poll(
      {this.id,
      required this.name,
      required this.description,
      required this.eventDate,
      this.votes});
  int? id;
  String name;
  String description;
  DateTime eventDate;
  List<Vote>? votes;

  Poll.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as int,
            name: json['name'] as String,
            description: json['description'] as String,
            eventDate: DateTime.parse(json['eventDate']),
            votes: (json['votes'] != null ? json['votes'] as List<dynamic> : [])
                .map((e) => Vote.fromJson(e))
                .toList());

  int countParticipation() {
    int count = 0;
    this.votes?.forEach((element) {
      if (element.status) {
        count++;
      }
    });
    return count;
  }

  bool userParticipated(int idUser) {
    for (Vote vote in this.votes as List<Vote>) {
      if (vote.user.id == idUser) {
        return vote.status;
      }
    }
    return false;
  }
}
