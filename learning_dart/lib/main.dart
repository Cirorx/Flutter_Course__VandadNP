import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
import 'package:learning_dart/views/notes/notes_view.dart';
import 'package:learning_dart/views/register_view.dart';
import 'package:learning_dart/views/verify_email_view.dart';
import 'views/animations/loading_square.dart';
import 'views/login_view.dart';
import 'views/notes/create_update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
      routes: {
        notesRoute: (context) => const NotesView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifiyEmailView(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user == null) {
              //Go to login
              return const LoginView();
            } else if (!user.isEmailVerified) {
              //Offer the user to verify email
              return const VerifiyEmailView();
            } else {
              //Home page of the app
              return const NotesView();
            }

          default:
            return const AnimatedSquare();
        }
      },
    );
  }
}

Future<bool> logOutDialog(BuildContext buildContext) {
  return showDialog<bool>(
    context: buildContext,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Log out")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
        ],
      );
    },
  ).then((value) => value ?? false); //return value or false if value is null
}
