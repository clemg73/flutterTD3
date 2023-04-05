import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../result.dart';
import '../states/auth_state.dart';
import '../states/polls_state.dart';

class Popup extends StatefulWidget {
  Popup({super.key, required this.poll});
  final Poll poll;
  @override
  State<Popup> createState() => _PopupState(poll: poll);
}

class _PopupState extends State<Popup> {
  _PopupState({required this.poll});
  final poll;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      child: FutureBuilder<Result<Poll, String>>(
          future: context.read<PollsState>().getPoll(poll.id),
          builder: (context, snapshot) {
            List<Widget> widgets = [];
            final dateFormater = DateFormat('dd/MM/yyyy', 'fr');

            if (snapshot.hasData) {
              print((snapshot.data as SuccessResult<Poll, String>)
                  .value
                  .votes!
                  .length);
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 245, 245, 245)),
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        poll.name,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromARGB(255, 245, 245, 245)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child:
                                    Text(dateFormater.format(poll.eventDate)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Text(poll.description),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Participation",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "(" +
                                      poll.countParticipation().toString() +
                                      ")",
                                  style: TextStyle(fontSize: 8),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              color: Color.fromARGB(255, 246, 246, 246),
                              child: ListView.builder(
                                itemCount: (snapshot.data
                                        as SuccessResult<Poll, String>)
                                    .value
                                    .votes!
                                    .length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Text((snapshot.data
                                              as SuccessResult<Poll, String>)
                                          .value
                                          .votes![index]
                                          .user
                                          .username),
                                      (snapshot.data as SuccessResult<Poll,
                                                  String>)
                                              .value
                                              .votes![index]
                                              .status
                                          ? Icon(Icons.check)
                                          : Icon(Icons.close)
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                        onPressed: () => {
                              context.read<AuthState>().isLoggedIn
                                  ? (snapshot.data
                                              as SuccessResult<Poll, String>)
                                          .value
                                          .userParticipated(context
                                              .read<AuthState>()
                                              .currentUser!
                                              .id)
                                      ? context.read<PollsState>().setStatusPoll(
                                          (snapshot.data as SuccessResult<Poll,
                                                  String>)
                                              .value
                                              .id as int,
                                          false)
                                      : context
                                          .read<PollsState>()
                                          .setStatusPoll(
                                              (snapshot.data as SuccessResult<
                                                      Poll, String>)
                                                  .value
                                                  .id as int,
                                              true)
                                  : Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (_) => false),
                              setState(() {}),
                            },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                              child: Text(
                            context.read<AuthState>().isLoggedIn
                                ? (snapshot.data as SuccessResult<Poll, String>)
                                        .value
                                        .userParticipated(context
                                            .read<AuthState>()
                                            .currentUser!
                                            .id)
                                    ? "Ne plus participer"
                                    : "Participer"
                                : 'Pas connecté !',
                            style: TextStyle(color: Colors.white),
                          )),
                        )),
                  )
                ],
              );
            }
            return Center(child: Text("Chargement"));
          }),
    );
  }
}
