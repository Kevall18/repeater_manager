import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'startup_splash_gate.dart';
import '../modules/auth/bloc/auth_cubit.dart';
import '../modules/auth/bloc/auth_state.dart';

class LoadingSplashScreen extends StatefulWidget {
  const LoadingSplashScreen({super.key});

  @override
  State<LoadingSplashScreen> createState() => LoadingSplashScreenState();
}

class LoadingSplashScreenState extends State<LoadingSplashScreen>
    with TickerProviderStateMixin {
  static const List<String> _letters = ['G', 'N', 'I', 'D', 'A', 'O', 'L'];
  final List<AnimationController> _controllers = [];

  late final TweenSequence<double> _leftTween;
  late final TweenSequence<double> _opacityTween;
  late final TweenSequence<double> _rotationTween;

  static const int _animationDurationMs = 2000;
  static const int _staggerDelayMs = 200;
  static const int _navigationDelayMs = 3000;

  @override
  void initState() {
    super.initState();

    _leftTween = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.41), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.41, end: 0.59), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.59, end: 1.0), weight: 35),
    ]);

    _opacityTween = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 35),
    ]);

    _rotationTween = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: math.pi, end: 0.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -math.pi), weight: 35),
    ]);

    for (var index = 0; index < _letters.length; index++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: _animationDurationMs),
        vsync: this,
      );
      _controllers.add(controller);

      Future.delayed(Duration(milliseconds: index * _staggerDelayMs), () {
        if (mounted) {
          controller.repeat();
        }
      });
    }

    Future.delayed(const Duration(milliseconds: _navigationDelayMs), () {
      if (!mounted) {
        return;
      }

      StartupSplashGate.markCompleted();
      final authState = context.read<AuthCubit>().state;
      if (authState.status == AuthStatus.authenticated) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final letterColor = Theme.of(context).colorScheme.tertiary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 36,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: List.generate(_letters.length, (index) {
                  final controller = _controllers[index];

                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      final double leftFraction =
                          _leftTween.evaluate(controller);
                      final double opacity = _opacityTween.evaluate(controller);
                      final double rotation =
                          _rotationTween.evaluate(controller);

                      return Positioned(
                        top: 0,
                        left: leftFraction * constraints.maxWidth,
                        child: Transform.rotate(
                          angle: rotation,
                          child: Opacity(
                            opacity: opacity,
                            child: Container(
                              width: 20,
                              height: 36,
                              alignment: Alignment.center,
                              child: Text(
                                _letters[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: letterColor,
                                  fontFamily: 'Verdana',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
