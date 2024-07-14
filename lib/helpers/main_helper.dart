import 'package:cloud_firestore/cloud_firestore.dart';

class MainHelper {
  static final MainHelper _instance = MainHelper._internal();

  factory MainHelper() {
    return _instance;
  }

  MainHelper._internal();

  Future<List<Map<String, dynamic>>> fetchModules() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('modules').get();
    List<Map<String, dynamic>> docs = [];
    for (var element in querySnapshot.docs) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      data['id'] = element.id;
      docs.add(data);
    }
    return docs;
  }

  Future<Map<String, dynamic>?> fetchModule(String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('modules').doc(id).get();
    if(!documentSnapshot.exists){
      print("module does not exist");
      return null;
    }
    Map<String, dynamic> doc = documentSnapshot.data() as Map<String, dynamic>;
    doc["id"] = documentSnapshot.id;
    return doc;
  }

  Future<List<Map<String, dynamic>>> fetchTests() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tests').get();
    List<Map<String, dynamic>> docs = [];
    for (var element in querySnapshot.docs) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      data['id'] = element.id;
      docs.add(data);
      print(data);
    }
    return docs;
  }

  Future<Map<String, dynamic>> fetchTest(String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('tests').doc(id).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    data['id'] = documentSnapshot.id;
    return data;
  }

  Future saveModule(Map<String, dynamic> module) async {
    try{
      DocumentReference documentReference = FirebaseFirestore.instance.collection('modules').doc(module['id']);
      await documentReference.set(module);
      return documentReference.id;
    }
    catch(e){
      print(e);
      return "";
    }
  }

  fetchTestsForModule({required String id}) {}

}