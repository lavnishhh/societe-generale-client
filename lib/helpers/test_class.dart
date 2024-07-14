import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:societe_generale_gamification/classes/question_helper.dart';

// class TestHelper {
//   static final TestHelper _instance = TestHelper._internal();
//
//   factory TestHelper() {
//     return _instance;
//   }
//
//   Future<String> saveTest(Test test) async {
//     try{
//       DocumentReference documentReference = FirebaseFirestore.instance.collection('tests').doc(test.id);
//       await documentReference.set(test.toJson());
//       return documentReference.id;
//     }
//     catch(e){
//       print(e);
//       return "";
//     }
//   }
//
//   TestHelper._internal();
// }