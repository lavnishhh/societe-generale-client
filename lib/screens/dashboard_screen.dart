import 'package:flutter/material.dart';
import 'package:societe_generale_client/main.dart';

import '../helpers/general.dart';
import '../helpers/main_helper.dart';
import 'module_screen.dart';

class DashboardScren extends StatefulWidget {
  const DashboardScren({super.key});

  @override
  State<DashboardScren> createState() => _DashboardScrenState();
}

class _DashboardScrenState extends State<DashboardScren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi $globalName,", style: TextStyle(fontSize: 40),),
            Divider(color: Colors.red, ),
            Text("Your modules", style: TextStyle(fontSize: 20),),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: MainHelper().fetchModules(),
                builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if(snapshot.connectionState != ConnectionState.done){
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.data == null){
                    return Center(child: CircularProgressIndicator());
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> module = snapshot.data![index];
                          return AppCard(
                            title: module['name'],
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ModuleScreen(id: module['id'])),
                              );
                            },
                          );
                        }),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
