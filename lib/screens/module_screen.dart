import 'package:flutter/material.dart';
import 'package:societe_generale_client/screens/test_screen.dart';

import '../helpers/general.dart';
import '../helpers/main_helper.dart';
import 'leaderboard_screen.dart';

class ModuleScreen extends StatefulWidget {
  final String id;
  const ModuleScreen({super.key, required this.id});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes ❓'),
      ),
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
              future: MainHelper().fetchModule(widget.id),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if(snapshot.connectionState != ConnectionState.done){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.data == null){
                  return Center(child: CircularProgressIndicator());
                }
                return testList(snapshot.data!['content']);
              }
          )
        ],
      ),
    );
  }
}

Widget testList(List<dynamic> tests){


  return Expanded(
    child: ListView.builder(
        itemCount: tests.length,
        itemBuilder: (context, index) {
          String testId = tests[index];
          return FutureBuilder<Map<String, dynamic>?>(
              future: MainHelper().fetchTest(testId),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                print(snapshot);
                if(snapshot.connectionState != ConnectionState.done){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.data == null){
                  return Center(child: CircularProgressIndicator());
                }
                Map<String, dynamic> test = snapshot.data!;
                return Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(test['testName']),
                      Spacer(),
                      AppButton(
                        content: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text('Leaderboard', style: TextStyle(color: Colors.white),),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Icon(Icons.leaderboard, color: Colors.white,),
                              )
                            ],
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LeaderboardScreen(testId: test['id'])),
                          );
                        },
                      ),
                      SizedBox(width: 16,),
                      AppButton(
                        content: Row(
                          children: [
                            Text('Start', style: TextStyle(color: Colors.white),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Icon(Icons.play_arrow, color: Colors.white,),
                            )
                          ],
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TestScreen(testId: test['id'])),
                          );
                        },
                      ),
                    ],
                  ),
                );
                return AppCard(
                  title: test['testName'],
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestScreen(testId: test['id'])),
                    );
                  },
                );
              }
          );
        }),
  );
}
