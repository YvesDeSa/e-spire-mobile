import 'package:flutter/material.dart';

class ToastAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onDismiss;

  const ToastAnimation({
    Key? key,
    required this.child,
    required this.duration,
    required this.onDismiss,
  }) : super(key: key);

  @override
  _ToastAnimationState createState() => _ToastAnimationState();
}

class _ToastAnimationState extends State<ToastAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // Velocidade da entrada
      vsync: this,
    );

    // Configura o Slide (Vem de cima -1.0 para o lugar 0.0)
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut)); // Efeito elástico bonito

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Inicia entrada
    _controller.forward();

    // Agenda a saída
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((value) {
          widget.onDismiss(); // Remove do Overlay quando terminar de subir
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter, // Garante que fica no topo e centro
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16), 
          child: Material(
            type: MaterialType.transparency, 
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}