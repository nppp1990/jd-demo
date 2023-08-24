import 'dart:async';

import 'package:flutter/material.dart';

class AutoChangedText extends StatefulWidget {
  final List<String> data;
  final TextStyle style;
  final Duration interval;

  const AutoChangedText(
      {super.key,
      required this.data,
      this.style = const TextStyle(fontSize: 18, color: Colors.grey),
      this.interval = const Duration(seconds: 3)});

  @override
  State<AutoChangedText> createState() => _AutoChangedTextState();
}

class _AutoChangedTextState extends State<AutoChangedText> {
  late Timer _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (timer) {
      setState(() {
        _index++;
        _index = _index % widget.data.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data[_index],
      style: widget.style,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
