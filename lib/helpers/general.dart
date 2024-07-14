import 'dart:math';
import 'package:flutter/material.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

const _nums = '1234567890';

String getRandomNum(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _nums.codeUnitAt(_rnd.nextInt(_nums.length))));

class AppButton extends StatefulWidget {
  final Widget content;
  final VoidCallback onTap;
  final Color color;
  const AppButton({super.key, required this.content, required this.onTap, this.color = Colors.red});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(color: Theme.of(context).primaryColor),
          color: widget.color
        ),
        padding: EdgeInsets.all(12),
        child: widget.content,
      ),
    );
  }
}

class AppCard extends StatefulWidget {

  final String title;
  final Function onTap;

  const AppCard({super.key, required this.title, required this.onTap});
  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onTap();
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(50),
          color: Colors.red
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title, style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}