import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;

//             if (user == null) {
//               //Go to login
//               return const LoginView();
//             } else if (!user.isEmailVerified) {
//               //Offer the user to verify email
//               return const VerifiyEmailView();
//             } else {
//               //Home page of the app
//               return const NotesView();
//             }

//           default:
//             return const AnimatedSquare();
//         }
//       },
//     );
//   }
// }

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

//BLOC EXAMPLE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Testing bloc"),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is InvalidCounterStateNumber) ? state.invalidValue : "";
            return Column(
              children: [
                Text("Current value ==> ${state.value}"),
                Visibility(
                  child: Text("Invalid input: $invalidValue"),
                  visible: state is InvalidCounterStateNumber,
                ),
                TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "Enter a number here."),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        //Grab the controller text and send the increment event
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_controller.text));
                      },
                      child: Text("+"),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_controller.text));
                      },
                      child: Text("-"),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class ValidCounterState extends CounterState {
  const ValidCounterState(int value) : super(value);
}

class InvalidCounterStateNumber extends CounterState {
  final String invalidValue;
  const InvalidCounterStateNumber({
    required this.invalidValue,
    required previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const ValidCounterState(0)) {
    //Depending on the event, we set a block of actions
    on<IncrementEvent>((event, emit) {
      //We receive and event, and send an emit
      final number = int.tryParse(event.value);
      if (number == null) {
        emit(InvalidCounterStateNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(ValidCounterState(state.value + number));
      }
    });
    on<DecrementEvent>((event, emit) {
      //We receive and event, and send an emit
      final number = int.tryParse(event.value);
      if (number == null) {
        emit(InvalidCounterStateNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(ValidCounterState(state.value - number));
      }
    });
  }
}
