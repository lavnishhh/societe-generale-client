import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societe_generale_client/helpers/main_helper.dart';
import 'package:societe_generale_client/main.dart';
import 'package:societe_generale_client/screens/dashboard_screen.dart';

import '../helpers/general.dart';

class TestScreen extends StatefulWidget {
  final String testId;
  const TestScreen({super.key, required this.testId});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  ScrollController questionViewController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("wrg");
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 1280 ? 1280 : MediaQuery.of(context).size.width,
          child: FutureBuilder<Object>(
            future: MainHelper().fetchTest(widget.testId),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if(snapshot.connectionState != ConnectionState.done){
                return const Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> test = snapshot.data as Map<String, dynamic>;
              int questionIndex = 0;
              return Column(
                children: [
                  Text(
                    test['testName'],
                    style: TextStyle(
                      fontSize: 30
                    ),
                  ),
                  Expanded(
                    child: TestQuestion(test: test,)
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class TestQuestion extends StatefulWidget {
  final Map<String, dynamic> test;
  const TestQuestion({super.key, required this.test});

  @override
  State<TestQuestion> createState() => _TestQuestionState();
}

class _TestQuestionState extends State<TestQuestion> with SingleTickerProviderStateMixin {

  Map<String, dynamic> test = {};
  int questionIndex = 0;
  List<String> answers = [];
  final int totalTime = 5;
  int start = 5;
  int score = 0;
  List<int> answerScores = [];
  Timer? _timer;
  late AnimationController animationController;

  void startTimer() {
    animationController.reset();
    animationController.duration = Duration(seconds: totalTime);
    animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (start > 0) {
            start--;
          } else {
            if (questionIndex == test['questions'].length - 1) {
              questionIndex += 1;
              _timer?.cancel();
              return;
            } // Reset the timer
            _timer?.cancel();
            questionIndex += 1;
            start = totalTime;
            startTimer();
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    test = widget.test;
    answers = List.generate(test['questions'].length, (index) {
      return test['questions'][index]['options'][0]['id'] as String;
    }).toList();
    answerScores = List.generate(test['questions'].length + 1, (index) => 0).toList();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: totalTime));
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(questionIndex >= test['questions'].length){

      FirebaseFirestore.instance.collection('tests').doc(test['id']).collection('scores').doc(globalPhoneNumber).set({'score': answerScores.reduce((value, element) => value + element)}).then((value){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScren()));
      });

      _timer?.cancel();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
          Text("Evaluating answers", style: TextStyle(fontSize: 40),)
        ],
      );
    }

    Map<String, dynamic> question = test['questions'][questionIndex];


    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: animationController.value,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              question['question'],
              style: TextStyle(
                  fontSize: 30
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: test['questions'][questionIndex]['options'].length,
              itemBuilder: (context, answerIndex) {
                Map<String, dynamic> option = test['questions'][questionIndex]['options'][answerIndex];
                bool selected = option['id'] == answers[questionIndex];
                return InkWell(
                  onTap: (){
                    setState(() {
                      answerScores[questionIndex + 1] = option['id'] == question['answer']  ? 500 * (totalTime - start) : 0;
                      answers[questionIndex] = option['id'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.red : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                          child: Text("${String.fromCharCode(answerIndex + 65)}.", style: TextStyle(fontSize: 30, color: selected ? Colors.white : Colors.red),),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Text(
                              option['text'],
                              style: TextStyle(
                                  color: selected ? Colors.white : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // AppButton(
                      //     content: Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //           child: const Icon(Icons.chevron_left, color: Colors.white,),
                      //         ),
                      //         Text("Previous", style: TextStyle(color: Colors.white)),
                      //       ],
                      //     ),
                      //     onTap: (){
                      //       setState(() {
                      //         questionIndex = max(0, questionIndex-1);
                      //       });
                      //     }),
                      AppButton(
                          content: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: Row(
                              children: [
                                Text("Next", style: TextStyle(color: Colors.white),),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: const Icon(Icons.chevron_right, color: Colors.white,),
                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              _timer?.cancel();
                              startTimer();
                              questionIndex += 1;
                              // questionIndex = min(test['questions'].length - 1, questionIndex+1);
                            });
                            // print(test.toJson());
                            // TestHelper().saveTest(test);
                          }),
                      Text('Score ${answerScores.sublist(0, questionIndex + 1).reduce((a, b) => a + b)}'),
                      Text('${questionIndex + 1}/${test.length}'),
                    ],
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}

// class CustomCheckBox extends StatefulWidget {
//   final List<Option> options;
//   final Function selectCallback;
//   const CustomCheckBox({super.key, required this.options, required this.selectCallback});
//
//   @override
//   State<CustomCheckBox> createState() => _CustomCheckBoxState();
// }
//
// class _CustomCheckBoxState extends State<CustomCheckBox> {
//
//   List<Option> options = [];
//   List<bool> selectedStates = [];
//   int selectedAnswer = 0;
//   @override
//   void initState() {
//     options = [widget.options.first];
//     selectedStates = List.generate(widget.options.length, (index) => false);
//     selectedStates[0] = true;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     while(widget.options.length > selectedStates.length){
//       selectedStates.add(false);
//     }
//
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: widget.options.length,
//       itemBuilder: (context, answerIndex) {
//         TextEditingController optionController = TextEditingController();
//         Option option = widget.options[answerIndex];
//         optionController.text = String.fromCharCode(answerIndex + 65);
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
//           child: InkWell(
//             onTap: (){
//               setState(() {
//                 selectedAnswer = answerIndex;
//                 selectedStates[answerIndex] = !selectedStates[answerIndex];
//               });
//               widget.selectCallback(answerIndex);
//             },
//             borderRadius: BorderRadius.circular(50),
//             child: Container(
//               width: 50,
//               height: 50,
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: answerIndex == selectedAnswer ? Theme.of(context).primaryColor : Colors.white,
//                 borderRadius: BorderRadius.circular(40),
//                 border: Border.all(color: Theme.of(context).primaryColor),
//               ),
//               child: Center(child: Text(String.fromCharCode(answerIndex + 65), style: TextStyle(color: answerIndex == selectedAnswer ? Colors.white : Colors.red,),)),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }




