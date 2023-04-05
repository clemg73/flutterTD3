import 'package:event_poll/result.dart';
import 'package:event_poll/states/polls_state.dart';
import 'package:event_poll/ui/popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../states/auth_state.dart';

class PollPage extends StatefulWidget {
  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  Widget _buildPopupDialog(BuildContext context, Poll poll) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Popup(
          poll: poll,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<Result<List<Poll>, String>>(
                    future: context.read<PollsState>().getPolls(),
                    builder: (context, snapshot) {
                      List<Widget> widgets = [];
                      final dateFormater = DateFormat('dd/MM/yyyy', 'fr');
                      if (snapshot.hasData) {
                        snapshot.data!.value!.forEach((Poll poll) {
                          widgets.add(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(context, poll),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 245, 245, 245)),
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            poll.name,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                          Text(poll.description,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(dateFormater
                                              .format(poll.eventDate)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
                        });
                        return Column(
                          children: widgets,
                        );
                      } else {
                        return const Text("pas");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "1",
                  onPressed: () {
                    // Code à exécuter lorsque le premier bouton est pressé
                    setState(() {});
                  },
                  backgroundColor: Color.fromARGB(255, 238, 248, 255),
                  child: Icon(Icons.replay_outlined,
                      color: Color.fromARGB(255, 0, 145, 255)),
                  shape: CircleBorder(),
                ),
                FloatingActionButton(
                  heroTag: "2",
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/polls/create', (_) => false);
                    // Code à exécuter lorsque le premier bouton est pressé
                  },
                  backgroundColor: Color.fromARGB(255, 238, 248, 255),
                  child:
                      Icon(Icons.add, color: Color.fromARGB(255, 0, 145, 255)),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
