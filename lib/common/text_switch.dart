import 'package:flutter/material.dart';

class TextSwitch extends StatefulWidget {
  final double? height;
  final double? textHorizontalPadding;
  final String textOff;
  final String textOn;
  final double? fontSize;
  final double? borderRadius;
  final bool isOn;
  final ValueChanged<bool>? onChanged;

  // 貌似有点不居中，所以用这个offset改一下
  final double? offset;
  final Duration? duration;

  const TextSwitch(
      {super.key,
      this.onChanged,
      this.isOn = true,
      this.height,
      this.textHorizontalPadding,
      this.textOff = 'off',
      this.textOn = 'on',
      this.fontSize,
      this.borderRadius,
      this.offset,
      this.duration});

  @override
  State<StatefulWidget> createState() => _TextSwitchState();
}

class _TextSwitchState extends State<TextSwitch> with SingleTickerProviderStateMixin {
  static const double _defaultFont = 15;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _widthAnimation;

  late final double _height;
  late final double _borderRadius;
  late final double _textHorizontalPadding;
  late final double _textFont;

  late bool _isOn;
  Size? _onTextSize;
  Size? _offTextSize;

  @override
  void initState() {
    super.initState();
    initSize();
    _animationController = AnimationController(
        vsync: this,
        lowerBound: widget.isOn ? 0 : 1,
        upperBound: widget.isOn ? 1 : 0,
        duration: widget.duration ?? const Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print('status: $status');
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          setState(() {
            _isOn = !_isOn;
            widget.onChanged?.call(_isOn);
          });
        }
      });
    _isOn = widget.isOn;
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void initSize() {
    _textFont = widget.fontSize ?? _defaultFont;
    _height = (widget.height != null && widget.height! > _textFont) ? widget.height! : _textFont * 2;
    _borderRadius = _height / 2;
    _textHorizontalPadding = widget.textHorizontalPadding ?? _height / 2;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void onTapText(bool isTapOn) {
    print('isTapOn: $isTapOn, _isOn: $_isOn, isAnimating: ${_animationController.isAnimating}');
    if (_animationController.isAnimating) {
      return;
    }
    if (isTapOn == _isOn) {
      return;
    }
    if (isTapOn) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_onTextSize == null || _offTextSize == null) {
      final style = DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: _textFont));
      final painter1 = TextPainter(
        text: TextSpan(text: widget.textOn, style: style),
        textDirection: TextDirection.ltr,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
      )..layout();
      _onTextSize = painter1.size;
      final painter2 = TextPainter(
        text: TextSpan(text: widget.textOff, style: style),
        textDirection: TextDirection.ltr,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
      )..layout();
      _offTextSize = painter2.size;

      final double onWidth = _onTextSize!.width + _textHorizontalPadding * 2;
      final double offWidth = _offTextSize!.width + _textHorizontalPadding * 2;

      _widthAnimation = Tween<double>(begin: onWidth, end: offWidth).animate(_animationController);
      _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(onWidth, 0)).animate(_animationController);
    }

    return Container(
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          color: const Color(0x11111111),
        ),
        child: Stack(
          children: [
            Transform.translate(
              offset: _offsetAnimation.value, // 从左到右位移的动画
              child: Container(
                width: _widthAnimation.value, // 宽度的动画
                height: _height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: (_height - _onTextSize!.height) / 2 + (widget.offset ?? 0)),
              child: Wrap(
                children: [
                  GestureDetector(
                    onTap: () {
                      onTapText(true);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: _textHorizontalPadding, vertical: 0),
                      child: Text(
                        widget.textOn,
                        style: TextStyle(color: _isOn ? Colors.red : Colors.black, fontSize: _textFont),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onTapText(false);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: _textHorizontalPadding, vertical: 0),
                      child: Text(
                        widget.textOff,
                        style: TextStyle(color: _isOn ? Colors.black : Colors.red, fontSize: _textFont),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
