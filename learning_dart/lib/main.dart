import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/services/auth/bloc/auth_bloc.dart';
import 'package:learning_dart/services/auth/bloc/auth_event.dart';
import 'package:learning_dart/services/auth/bloc/auth_state.dart';
import 'package:learning_dart/services/auth/firebase_auth_provider.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
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
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStatePendingVerification) {
          return const VerifiyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const AnimatedSquareView();
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
