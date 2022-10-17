import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/themes.dart';

class SeekBar extends StatefulWidget {
  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);
  final Duration duration;
  final Duration position;
  final Duration? bufferedPosition;
  final ValueChanged<Duration?>? onChanged;
  final ValueChanged<Duration?>? onChangeEnd;

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      activeTrackColor: tappedAccent,
      inactiveTrackColor: tappedAccent,
      thumbColor: tappedAccent,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      trackHeight: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            activeTrackColor: Colors.blue.shade100,
            inactiveTrackColor: Colors.grey.shade300,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
          ),
          child: ExcludeSemantics(
            child: Slider(
              max: widget.duration.inMilliseconds.toDouble(),
              value: widget.bufferedPosition!.inMilliseconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                widget.onChanged?.call(Duration(milliseconds: value.round()));
              },
              onChangeEnd: (value) {
                widget.onChangeEnd?.call(Duration(milliseconds: value.round()));
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
          child: Slider(
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(
              _dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble(),
            ),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              widget.onChanged?.call(Duration(milliseconds: value.round()));
            },
            onChangeEnd: (value) {
              widget.onChangeEnd?.call(Duration(milliseconds: value.round()));
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16,
          bottom: 0,
          child: Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch('$_remaining')
                    ?.group(1) ??
                '$_remaining',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class PositionData {
  PositionData(this.position, this.bufferedPosition);
  final Duration position;
  final Duration bufferedPosition;
}
