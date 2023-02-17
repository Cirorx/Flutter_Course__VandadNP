import 'package:flutter/material.dart';
import 'package:learning_dart/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Log out",
    content: "Do you want to log out?",
    optionsBuilder: () => {
      "Cancel": false,
      "Log out": true,
    },
  ).then(
    (value) => value ?? false,
  );
  /*
  On some platforms you're able to dismiss your dialogues without actually 
  responding to any of the options presented in the dialogue, thats why we
  are returning a default value false
   */
}
