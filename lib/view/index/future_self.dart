import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 未来的自己
 * **/
class FutureSelf extends StatefulWidget {
  @override
  createState() => _FutureSelfPageState();
}

class _FutureSelfPageState extends State<FutureSelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(child: Text("未来的自己")),
      ],
    ));
  }
}
