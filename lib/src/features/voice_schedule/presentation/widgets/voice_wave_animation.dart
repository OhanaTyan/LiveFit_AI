import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class VoiceWaveAnimation extends StatefulWidget {
  final bool isListening;

  const VoiceWaveAnimation({
    super.key,
    required this.isListening,
  });

  @override
  State<VoiceWaveAnimation> createState() => _VoiceWaveAnimationState();
}

class _VoiceWaveAnimationState extends State<VoiceWaveAnimation> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final int _barCount = 5;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _barCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300 + (index * 100)),
      )..repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isListening) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Container(
                width: 8,
                height: 20 + (_controllers[index].value * 40),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
