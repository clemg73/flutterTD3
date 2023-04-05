import 'package:event_poll/result.dart';
import 'package:event_poll/states/auth_state.dart';
import 'package:event_poll/ui/addPoll_page.dart';
import 'package:event_poll/ui/login_page.dart';
import 'package:event_poll/ui/poll_page.dart';
import 'package:event_poll/ui/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'models/poll.dart';
import 'states/polls_state.dart';
import 'ui/app_scaffold.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthState(),
        ),
        ChangeNotifierProxyProvider<AuthState, PollsState>(
          create: (_) => PollsState(),
          update: (_, authState, pollsState) =>
              pollsState!..setAuthToken(authState.token),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Poll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      supportedLocales: const [Locale('fr')],
      locale: const Locale('fr'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: '/polls',
      routes: {
        '/polls': (context) => AppScaffold(
              title: 'Événements',
              body: PollPage(),
            ),
        '/polls/create': (context) => const AppScaffold(
              title: 'Ajouter un événement',
              body: AddPollPage(),
            ),
        '/polls/detail': (context) => AppScaffold(
              title: 'Événement',
              body: Placeholder(child: Center(child: Text('POLLS_DETAIL'))),
            ),
        '/polls/update': (context) => AppScaffold(
              title: 'Modifier un événement',
              body: Placeholder(child: Center(child: Text('POLLS_UPDATE'))),
            ),
        '/login': (context) => AppScaffold(
              title: 'Connexion',
              body: LoginPage(),
            ),
        '/signup': (context) => AppScaffold(
              title: 'Inscription',
              body: SignupPage(),
            ),
      },
    );
  }
}
