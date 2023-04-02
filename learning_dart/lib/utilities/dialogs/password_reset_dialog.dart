import 'package:flutter/material.dart';
import 'package:learning_dart/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password reset",
    content: "We have sent you a password reset link, please check your email.",
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
