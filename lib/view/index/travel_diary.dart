import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 旅行日记
 * **/
class TravelDiary extends StatefulWidget {
  @override
  createState() => _TravelDiaryPageState();
}

class _TravelDiaryPageState extends State<TravelDiary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(child: Text("旅行日记")),
          ],
        )
    );
  }
}
