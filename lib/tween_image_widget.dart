library tween_image_widget;

import 'package:flutter/material.dart';

/// Tween image widget 💖💖💖
/// Widget that can play the animation repeatedly, or manually control the progress of the animation sequence
///
///example:
///```dart
///TweenImageWidget(
///       ImagesEntry(1, 25, "images/pic_animation%s.png"),
///       durationMilliseconds: 5000,
///       repeat: false,
///       startsValue: 0.2,//animationValue / 100
///     )
/// ```
///
// ignore: must_be_immutable
class TweenImageWidget extends StatefulWidget {
  /// Starts running this animation in the forward direction, and
  /// restarts the animation when it completes.
  ///
  ///Reference on [AnimationController.repeat]
  final bool repeat;
  final double? width;
  final double? height;
  final ImagesEntry entry;
  final int durationMilliseconds;
  AnimationController? _animationController;

  ///Reference on [AnimationController.value],is should be >= 0.0 && <= 1.0
  ///
  ///Because of [animationController] default value is lowerBound = 0.0, upperBound = 1.0,
  final double? startsValue;

  ///Get AnimationController
  AnimationController? get animationController {
    return _animationController;
  }

  ///Stops running this animation.
  ///
  ///Reference on [AnimationController.stop]
  void stop({bool canceled = true}) =>
      _animationController?.stop(canceled: canceled);

  ///Starts running this animation forwards (towards the end).
  ///
  ///Reference on [AnimationController.forward]
  TickerFuture? forward({double? from}) =>
      _animationController?.forward(from: from);

  ///Starts running this animation in reverse (towards the beginning).
  ///
  ///Reference on [AnimationController.reverse]
  TickerFuture? reverse({double? from}) =>
      _animationController?.reverse(from: from);

  ///Drives the animation from its current value to target.
  ///
  ///Reference on [AnimationController.animateTo] and [AnimationController.animateBack]
  TickerFuture? animateToTarget(double target, {Duration? duration}) {
    if (target > (_animationController?.value ?? 0)) {
      return _animationController?.animateTo(target, duration: duration);
    } else {
      return _animationController?.animateBack(target, duration: duration);
    }
  }

  ///[repeat]'s default value is true, if need manually control the animation, please pass in false
  ///
  ///[startsValue] Is a starting state value, if want it to start from a few percent of the animation, please pass in this value
  ///
  ///[durationMilliseconds] is how many milliseconds the animation to run, the default value is 3000 milliseconds
  TweenImageWidget(
    this.entry, {
    this.width,
    this.height,
    this.durationMilliseconds = 3000,
    this.repeat = true,
    this.startsValue,
    key,
  })  : assert(
            (width == null || width > 0), "width is should be null or > 0.0"),
        assert((height == null || height > 0),
            "height is should be null or > 0.0"),
        assert((startsValue == null || (startsValue >= 0 && startsValue <= 1)),
            "startsValue is should be null or >= 0.0 && <= 1.0"),
        super(key: key);

  @override
  _TweenImageWidgetState createState() =>
      _TweenImageWidgetState((animationController) {
        _animationController = animationController;
      });
}

class _TweenImageWidgetState extends State<TweenImageWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<int> _animation;
  void Function(AnimationController? animationController)
      setAnimationController;

  _TweenImageWidgetState(this.setAnimationController);

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.durationMilliseconds));

    if (widget.startsValue != null) {
      _controller!.value = widget.startsValue!;
    }

    if (widget.repeat) {
      _controller!.repeat();
    }

    _animation =
        new IntTween(begin: widget.entry.lowIndex, end: widget.entry.highIndex)
            .animate(_controller!);

    setAnimationController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        int frame = _animation.value;
        return new Image.asset(
          (widget.entry.makePath ?? widget.entry._defaultMakePath()).call(
              frame), //根据传进来的参数拼接路径 Splice the path according to the parameters passed in
          gaplessPlayback: true, //避免图片闪烁 avoid flickering pictures
          width: widget.width,
          height: widget.height,
          fit: (widget.width != null || widget.height != null)
              ? BoxFit.fill
              : null,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class ImagesEntry {
  ///First index of pictures
  int lowIndex = 0;

  ///Last index of pictures
  int highIndex = 0;

  ///File path of pictures,%s will be replaced by the index
  String basePath;

  ///File path constructor
  String Function(int index)? makePath;

  ///Default file path constructor
  String Function(int index) _defaultMakePath() =>
      (index) => basePath.replaceAll("%s", index.toString());

  ///[lowIndex] is the first index of the animation sequence pictures
  ///
  /// [highIndex] is the last index of the animation sequence pictures
  ///
  /// [basePath] is the file path of the animation sequence pictures,example:"images/pic_animation%s.png"
  ///
  /// [makePath] is an optional file path constructor
  ImagesEntry(this.lowIndex, this.highIndex, this.basePath, [this.makePath]);
}
