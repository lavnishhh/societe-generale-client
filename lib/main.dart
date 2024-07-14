import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:societe_generale_client/helpers/general.dart';
import 'package:societe_generale_client/screens/dashboard_screen.dart';
import 'package:societe_generale_client/screens/login_screen.dart';
import 'package:societe_generale_client/screens/test_screen.dart';
import 'firebase_options.dart';
import 'helpers/localstorage.dart';

String? globalName;
String? globalPhoneNumber;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  catch(e){
    print(e);
  }
  await LocalStorage().initialize();


  runApp(const MyApp());
}

Future<void> addScoresToTests() async {
  // Initialize Firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Step 1: Fetch document IDs from 'user' collection
  QuerySnapshot userSnapshot = await firestore.collection('user').get();

  // Step 2: Iterate through each user document
  for (var userDoc in userSnapshot.docs) {
    String userId = userDoc.id;

    // Step 3: Fetch corresponding test document from 'tests' collection
    DocumentSnapshot testDoc = await firestore.collection('tests').doc(userId).get();

    // Step 4: Generate a random score (multiple of 500)
    Random random = Random();
    int score = random.nextInt(21) * 500; // Generates a random score between 0 and 10000 in steps of 500

    // Step 5: Update 'scores' subcollection inside the test document
    await testDoc.reference.collection('scores').doc(userId).set({
      'score': score,
    });

    print('Added score $score for test ${testDoc.id}');
  }

  print('All scores added successfully');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    Widget nextScreen = const LoginScreen();

    String? user = LocalStorage().storage.getString('user');
    print("user");
    print(user);
    if(user != null){
      Map f = jsonDecode(user);
      globalName = f['name'];
      globalPhoneNumber = f['phone'];
      nextScreen = const DashboardScren();
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: nextScreen
    );
  }
}
