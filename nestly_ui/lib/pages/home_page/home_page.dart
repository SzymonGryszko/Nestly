import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestly_ui/state/nestly_auth_provider.dart' as provider;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Provider.of<provider.NestlyAuthProvider>(context, listen: false)
                  .setUser(null);
            },
          )
        ],
      ),
      body: const Center(child: Text('Welcome!')),
    );
  }
}
