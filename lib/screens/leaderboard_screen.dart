import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  final String testId;

  const LeaderboardScreen({super.key, required this.testId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Competitive Leaderboard 🎉'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('tests')
            .doc(testId)
            .collection('scores')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No scores found'));
          }

          // Data is ready
          List<DocumentSnapshot> scores = snapshot.data!.docs;

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              var score = scores[index];

              // Fetch user name asynchronously
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('user')
                    .doc(score.id) // Assuming score.id is the user ID
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${userSnapshot.error}'),
                    );
                  }
                  if (!userSnapshot.hasData ||
                      !userSnapshot.data!.exists) {
                    return ListTile(
                      title: Text('User not found'),
                    );
                  }

                  // User data found
                  var userData = userSnapshot.data!;
                  var userName = userData['name']; // Assuming 'name' is a field in your 'users' collection

                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("${index+1}.", style: TextStyle(fontSize: 20),),
                        Text(userName, style: TextStyle(fontSize: 20)),
                        Spacer(),
                        Text(score.get('score').toString(), style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
