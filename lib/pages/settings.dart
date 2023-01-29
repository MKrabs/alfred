import 'package:alfred/logic/reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  final Color bgc;

  const SettingsPage({super.key, required this.bgc});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color bgc;
  dynamic light1;
  bool light0 = true;
  bool light2 = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bgc = widget.bgc;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      color: bgc,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SafeArea(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: user == null
                              ? const FaIcon(FontAwesomeIcons.doorOpen)
                              : (user.photoURL != null
                                  ? const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://mkrabs.de/media/profile_pictures/71791731_NSOUkR9.jpg"),
                                    )
                                  : const Icon(
                                      Icons.badge,
                                      size: 36,
                                    )),
                          title: user == null
                              ? const Text("Sign in / Register")
                              : Text(user.email!),
                          trailing: const FaIcon(
                            FontAwesomeIcons.google,
                            size: 14,
                          ),
                        ),
                        SwitchListTile(
                          title: Text("Settings $light0"),
                          value: light0,
                          onChanged: (bool value) {
                            setState(() {
                              light0 = value;
                            });
                          },
                        ),
                        const ListTile(
                          title: Text("Settings"),
                        ),
                        if (user == null)
                          TextField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                          ),
                        if (user == null)
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "password",
                            ),
                          ),
                        if (user != null)
                          TextButton.icon(
                            onPressed: signOut,
                            icon: const Icon(Icons.bedtime_outlined),
                            label: const Text("Sign out"),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: signUp,
                                icon: const Icon(Icons.badge),
                                label: const Text("Sign Up"),
                              ),
                              TextButton.icon(
                                onPressed: signIn,
                                icon: const Icon(Icons.fingerprint),
                                label: const Text("Sign in"),
                              ),
                            ],
                          ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((value) {
      // do something when success
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${error}')),
      );
    });
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
