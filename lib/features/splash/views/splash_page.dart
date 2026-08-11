import 'dart:async';
import 'dart:math' as math;

import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/auth/views/login_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  Timer? _navigationTimer;

  late final AnimationController _iconController;
  late final AnimationController _pulseController;
  late final AnimationController _textController;

  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Icon entrance animation
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _iconScale = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );
    _iconOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Pulse ring animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseScale = Tween<double>(
      begin: 0.8,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(
      begin: 0.6,
      end: 0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Start animation sequence
    _iconController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _pulseController.repeat();
        _textController.forward();
      }
    });

    // Navigate after splash
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _iconController.dispose();
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF1E88E5),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -80,
              right: -60,
              child: _GlowCircle(
                size: Dimensions.height80 * 2.75,
                opacity: 0.06,
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: _GlowCircle(
                size: Dimensions.height80 * 3.5,
                opacity: 0.05,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: -40,
              child: _GlowCircle(
                size: Dimensions.height80 * 1.5,
                opacity: 0.04,
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pulse ring behind icon
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse ring
                          Transform.scale(
                            scale: _pulseScale.value,
                            child: Opacity(
                              opacity: _pulseOpacity.value,
                              child: Container(
                                width: Dimensions.height80 * 1.75,
                                height: Dimensions.height80 * 1.75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Icon with scale animation
                          child!,
                        ],
                      );
                    },
                    child: ScaleTransition(
                      scale: _iconScale,
                      child: FadeTransition(
                        opacity: _iconOpacity,
                        child: Container(
                          width: Dimensions.height80 * 1.63,
                          height: Dimensions.height80 * 1.63,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF42A5F5),
                                Color(0xFF1565C0),
                                Color(0xFF0D47A1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF1E88E5,
                                ).withValues(alpha: 0.4),
                                blurRadius: Dimensions.radius30,
                                spreadRadius: Dimensions.height10 * 0.8,
                              ),
                            ],
                          ),
                          child: const _BookIcon(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height20 * 2),

                  // App name text
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          Text(
                            'Custom Books',
                            style: TextStyle(
                              fontSize: Dimensions.font26 * 1.08,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: Dimensions.radius15 * 0.53,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 * 0.8),
                          Text(
                            'Smart Accounting Made Simple',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.875,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.7),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom loading indicator
            Positioned(
              bottom: Dimensions.height52 * 1.15,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textOpacity,
                child: const _LoadingDots(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom book icon using stack of shapes for a unique look.
class _BookIcon extends StatelessWidget {
  const _BookIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.height52 * 1.15,
        height: Dimensions.height52 * 1.15,
        child: CustomPaint(painter: _BookPainter()),
      ),
    );
  }
}

class _BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Left page
    paint.color = Colors.white.withValues(alpha: 0.95);
    final leftPage = Path()
      ..moveTo(size.width * 0.5, size.height * 0.15)
      ..lineTo(size.width * 0.1, size.height * 0.25)
      ..lineTo(size.width * 0.1, size.height * 0.85)
      ..lineTo(size.width * 0.5, size.height * 0.75)
      ..close();
    canvas.drawPath(leftPage, paint);

    // Right page
    paint.color = Colors.white.withValues(alpha: 0.8);
    final rightPage = Path()
      ..moveTo(size.width * 0.5, size.height * 0.15)
      ..lineTo(size.width * 0.9, size.height * 0.25)
      ..lineTo(size.width * 0.9, size.height * 0.85)
      ..lineTo(size.width * 0.5, size.height * 0.75)
      ..close();
    canvas.drawPath(rightPage, paint);

    // Spine line
    paint
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.15),
      Offset(size.width * 0.5, size.height * 0.75),
      paint,
    );

    // Text lines on left page
    paint
      ..color = const Color(0xFF1565C0).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 3; i++) {
      final y = size.height * (0.4 + i * 0.1);
      canvas.drawLine(
        Offset(size.width * 0.18, y),
        Offset(size.width * 0.42, y - (i * 1.5)),
        paint,
      );
    }

    // Small chart icon on right page
    paint
      ..color = const Color(0xFF0D47A1).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Bar chart bars
    final barWidth = size.width * 0.06;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.58,
          size.height * 0.52,
          barWidth,
          size.height * 0.15,
        ),
        const Radius.circular(1),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.67,
          size.height * 0.44,
          barWidth,
          size.height * 0.23,
        ),
        const Radius.circular(1),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.76,
          size.height * 0.48,
          barWidth,
          size.height * 0.19,
        ),
        const Radius.circular(1),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Background decorative circle.
class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

/// Animated loading dots.
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = 0.5 + 0.5 * math.sin(value * math.pi);
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: Dimensions.width10 * 0.4,
              ),
              width: Dimensions.width10 * 0.8,
              height: Dimensions.height10 * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: scale * 0.8),
              ),
            );
          }),
        );
      },
    );
  }
}
