import 'package:flutter/material.dart';

class AutoShinyText extends StatefulWidget {
  final double width;
  final double height;
  final double borderWidth;

  final Color bgColor;
  final TextStyle? textStyle;
  final List<String> data;
  final Duration interval;
  final Duration animationDuration;

  const AutoShinyText(
      {super.key,
      required this.data,
      required this.width,
      required this.height,
      this.borderWidth = 1,
      this.bgColor = Colors.red,
      this.textStyle,
      this.interval = const Duration(seconds: 3),
      this.animationDuration = const Duration(milliseconds: 2000)});

  @override
  State<StatefulWidget> createState() => _AutoShinyTextState();
}

class _AutoShinyTextState extends State<AutoShinyText> with SingleTickerProviderStateMixin {
  int _index = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration * 0.5);
    _animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
          setState(() {
            _index = (_index + 1) % widget.data.length;
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(widget.interval, () {
            _controller.forward();
          });
        }
      });
    Future.delayed(widget.interval, () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.height / 2),
              topRight: Radius.circular(widget.height / 2),
              bottomRight: Radius.circular(widget.height / 2),
            ),
            border: Border.all(
              color: Colors.white,
              width: widget.borderWidth,
            ),
          ),
          child: Center(
            child: Text(
              widget.data[_index],
              style: widget.textStyle,
            ),
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
