import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../configs.dart';
import '../models/poll.dart';
import '../result.dart';

class PollsState extends ChangeNotifier {
  String? _token;
  String? get token => _token;

  List<Poll>? polls;
  Poll? poll;
  String? error;

  void setAuthToken(String? token) {
    _token = token;
  }

  Future<Result<List<Poll>, String>> getPolls() async {
    final pollResponse = await http.get(
      Uri.parse('${Configs.baseUrl}/polls'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );
    if (pollResponse.statusCode == HttpStatus.ok) {
      polls = (json.decode(pollResponse.body) as List<dynamic>)
          .map((e) => Poll.fromJson(e))
          .toList();

      notifyListeners();
      return Result.success(polls!);
    } else {
      error = 'Erreur lors du chargement des évènements';
      return Result.failure(error!);
    }
  }

  Future<Result<Poll, String>> getPoll(int id) async {
    final pollResponse = await http.get(
      Uri.parse('${Configs.baseUrl}/polls/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );
    if (pollResponse.statusCode == HttpStatus.ok) {
      //print(pollResponse.body);
      poll = Poll.fromJson(json.decode(pollResponse.body));
      notifyListeners();
      return Result.success(poll!);
    } else {
      error = 'Erreur lors du chargement de l\'évènement';
      return Result.failure(error!);
    }
  }

  Future<Result<String, String>> setStatusPoll(int id, bool status) async {
    final pollResponse =
        await http.post(Uri.parse('${Configs.baseUrl}/polls/$id/votes'),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $_token',
              HttpHeaders.contentTypeHeader: 'application/json'
            },
            body: jsonEncode(<String, bool>{"status": status}));
    if (pollResponse.statusCode == HttpStatus.created) {
      print("reussi");
      return Result.success("reussi");
    } else {
      error = 'Erreur';
      print(error);
      return Result.failure(error!);
    }
  }

  Future<Result<String, String>> postPoll(Poll poll) async {
    final pollResponse = await http.post(Uri.parse('${Configs.baseUrl}/polls'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(<String, String>{
          "name": poll.name,
          "description": poll.description,
          "eventDate": poll.eventDate.toIso8601String()
        }));
    print(pollResponse.statusCode);
    if (pollResponse.statusCode == HttpStatus.created) {
      print("reussi");
      return Result.success("reussi");
    } else {
      error = 'Erreur';
      print(error);
      return Result.failure(error!);
    }
  }
}
