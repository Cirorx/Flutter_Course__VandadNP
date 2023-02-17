import 'package:flutter/material.dart';
import 'package:learning_dart/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Do you want to delete this note?",
    optionsBuilder: () => {
      "No": false,
      "Yes": true,
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
