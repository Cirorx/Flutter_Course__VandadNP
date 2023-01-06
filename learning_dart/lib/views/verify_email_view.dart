import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/views/register_view.dart';

class VerifiyEmailView extends StatefulWidget {
  const VerifiyEmailView({super.key});

  @override
  State<VerifiyEmailView> createState() => _VerifiyEmailViewState();
}

class _VerifiyEmailViewState extends State<VerifiyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email verification"),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you a verification email, please check your inbox."),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Haven't received an email yet? Re-send email."),
          ),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Restart."))
        ],
      ),
    );
  }
}
