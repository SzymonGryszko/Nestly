class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Provider.of<AuthProvider>(context, listen: false).setUser(null);
            },
          )
        ],
      ),
      body: Center(child: Text('Welcome!')),
    );
  }
}
