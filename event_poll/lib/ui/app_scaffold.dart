import 'package:event_poll/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    this.title,
    this.body,
    super.key,
  });

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Event Poll'),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(context.watch<AuthState>().isLoggedIn
                  ? context.watch<AuthState>().currentUser!.username
                  : 'Connectez-vous pour vous inscrire à un événement !'),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Événements'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/polls', (_) => false);
              },
            ),
            !context.watch<AuthState>().isLoggedIn
                ? ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Connexion'),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (_) => false);
                    },
                  )
                : Container(),
            !context.watch<AuthState>().isLoggedIn
                ? ListTile(
                    leading: const Icon(Icons.save_alt),
                    title: const Text('Inscription'),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/signup', (_) => false);
                    },
                  )
                : Container(),
            context.watch<AuthState>().isLoggedIn
                ? ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Déconnexion'),
                    onTap: () {
                      context.read<AuthState>().logout();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/polls', (_) => false);
                    },
                  )
                : Container(),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: body,
      ),
    );
  }
}
