import 'package:flutter/material.dart';
import 'package:learning_dart/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "You can't share an empty note.",
    optionsBuilder: () => {"OK": null},
  );
}
