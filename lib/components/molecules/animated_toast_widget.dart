import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ToastType { success, info, error }

class AnimatedToastWidget extends StatefulWidget {
  final String title;
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const AnimatedToastWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<AnimatedToastWidget> createState() => _AnimatedToastWidgetState();
}

class _AnimatedToastWidgetState extends State<AnimatedToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Color _getColor() {
    switch (widget.type) {
      case ToastType.success:
        return AppColors.successToast;
      case ToastType.info:
        return AppColors.infoToast;
      case ToastType.error:
        return AppColors.errorToast;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.info:
        return Icons.info_outline;
      case ToastType.error:
        return Icons.cancel_outlined;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDismissed();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();
    final borderRadius = BorderRadius.circular(16);

    final backgroundColor = const Color(0xFF1E1E1E); 

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone com fundo circular e efeito de cor
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15), // Cor do tipo com opacidade
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white, // Texto branco
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8), // Texto branco com opacidade
                            fontSize: 13,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Barra de progresso animada
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: 1.0 - _controller.value,
                  backgroundColor: color.withOpacity(0.2), // Fundo da barra com opacidade
                  valueColor: AlwaysStoppedAnimation<Color>(color), // Cor da barra
                  minHeight: 4,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}