import 'package:event_poll/states/polls_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../states/auth_state.dart';

class AddPollPage extends StatefulWidget {
  const AddPollPage({super.key});

  @override
  State<AddPollPage> createState() => _AddPollPageState();
}

class _AddPollPageState extends State<AddPollPage> {
  final _formKey = GlobalKey<FormState>();
  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  String name = "";
  String description = "";
  DateTime? date = null;
  String? error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final result = await context.read<PollsState>().postPoll(new Poll(
        name: name, description: description, eventDate: date as DateTime));
    if (result.isSuccess) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/polls', (_) => false);
      }
    } else {
      setState(() {
        error = result.failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nom'),
            onChanged: (value) => name = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'description'),
            onChanged: (value) => description = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          InputDatePickerFormField(
            firstDate: new DateTime.now(),
            lastDate: new DateTime(2100),
            onDateSaved: (value) {
              date = value;
            },
          ),
          if (error != null)
            Text(
              error!,
            ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    ;
  }
}
